import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silviamaharjan_2408228_fyp/src/features/cycles_tab/sub_tabs/period_logging_screen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/phase_calculator.dart';
import '../../user_management/controllers/database_service.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  // --- STATE FOR CLICKABLE LOGS ---
  DateTime _selectedDate = DateTime.now();
  List<String> _selectedDateLogs = [];

  final double _monthItemHeight = 460.0;
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 6 * 460.0);
  final DatabaseService _dbService = DatabaseService();

  // COLORS
  final Color follicularColor = const Color(0xFF7BC9C9);
  final Color ovulationColor = const Color(0xFFF9B13A);
  final Color lutealColor = const Color(0xFFD386B1);
  final Color menstrualColor = const Color(0xFFCF4145);

  @override
  void initState() {
    super.initState();
    _loadLogsForDate(DateTime.now()); // Load today's logs by default
  }

  // --- FETCH LOGS FOR CLICKED DATE ---
  Future<void> _loadLogsForDate(DateTime date) async {

    String dateKey = DateFormat('yyyy-MM-dd').format(date);

    final logs = await _dbService.getFeelingsForDate(dateKey);

    setState(() {
      _selectedDate = date;
      _selectedDateLogs = logs; // This now holds whatever was found in the DB
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text("Please Login")));

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;
          DateTime onboardingDate = DateTime.parse(userData['last_period']);
          int cycleLength = userData['cycle_length'] ?? 28;
          int periodDuration = userData['period_duration'] ?? 5;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('period_history')
                .orderBy('start_date', descending: true)
                .snapshots(),
            builder: (context, historySnapshot) {
              List<Map<String, dynamic>> history = [];
              if (historySnapshot.hasData) {
                history = historySnapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
              }

              return Column(
                children: [
                  const SizedBox(height: 20),
                  _buildCountdownCard(onboardingDate, history, cycleLength, periodDuration),
                  const SizedBox(height: 15),
                  _buildWeekDayLabels(),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final now = DateTime.now();
                        final monthDate = DateTime(now.year, now.month - 6 + index, 1);
                        return SizedBox(
                          height: _monthItemHeight,
                          child: _buildSingleMonthGrid(monthDate, onboardingDate, history, cycleLength, periodDuration),
                        );
                      },
                    ),
                  ),
                  _buildBottomActionArea(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSingleMonthGrid(DateTime monthDate, DateTime onboardingStart, List<Map<String, dynamic>> history, int cycleLen, int periodDur) {
    final daysInMonth = DateUtils.getDaysInMonth(monthDate.year, monthDate.month);
    final firstDayOffset = DateTime(monthDate.year, monthDate.month, 1).weekday % 7;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    bool isMonthLogged = history.any((log) {
      DateTime s = (log['start_date'] as Timestamp).toDate();
      return s.month == monthDate.month && s.year == monthDate.year;
    }) || (onboardingStart.month == monthDate.month && onboardingStart.year == monthDate.year);

    DateTime latestStart = (history.isNotEmpty)
        ? (history.first['start_date'] as Timestamp).toDate()
        : onboardingStart;

    bool isLateNow = today.difference(latestStart).inDays >= cycleLen;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(DateFormat('MMMM yyyy').format(monthDate),
              style: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w700, fontSize: 18, color: appColors.heading)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisExtent: 70),
            itemCount: daysInMonth + firstDayOffset,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) return const SizedBox.shrink();
              final day = index - firstDayOffset + 1;
              final date = DateTime(monthDate.year, monthDate.month, day);

              DateTime onboardingEnd = onboardingStart.add(Duration(days: periodDur - 1));
              bool isWithinOnboarding = (date.isAfter(onboardingStart) || DateUtils.isSameDay(date, onboardingStart))
                  && (date.isBefore(onboardingEnd) || DateUtils.isSameDay(date, onboardingEnd));

              bool isLoggedHistory = history.any((log) {
                DateTime s = (log['start_date'] as Timestamp).toDate();
                DateTime e = (log['end_date'] as Timestamp).toDate();
                return (date.isAfter(s) || DateUtils.isSameDay(date, s)) && (date.isBefore(e) || DateUtils.isSameDay(date, e));
              });

              bool isActualLoggedDate = isWithinOnboarding || isLoggedHistory;

              DateTime anchor = onboardingStart;
              for (var log in history) {
                DateTime logStart = (log['start_date'] as Timestamp).toDate();
                if (date.isAfter(logStart) || DateUtils.isSameDay(date, logStart)) {
                  anchor = logStart;
                  break;
                }
              }

              final int diff = date.difference(DateTime(anchor.year, anchor.month, anchor.day)).inDays;
              final int cycleDay = (diff % cycleLen) + 1;
              final phase = _getPhaseForCycleDay(cycleDay, cycleLen, periodDur);
              bool isThisLateMonth = isLateNow && (date.month == now.month && date.year == now.year);

              return _buildDayCell(day, DateUtils.isSameDay(date, now), phase, isActualLoggedDate, isThisLateMonth, isMonthLogged, date);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(int day, bool isToday, CyclePhase phase, bool isLogged, bool isThisLateMonth, bool isMonthLogged, DateTime date) {
    Color bgColor = Colors.transparent;
    Color textColor;

    bool isSelected = DateUtils.isSameDay(date, _selectedDate);

    // 1. Determine Phase Colors
    if (phase == CyclePhase.menstrual) {
      if (isLogged) {
        bgColor = menstrualColor; // Solid red for logged days
        textColor = Colors.white;
      } else if (isMonthLogged || isThisLateMonth) {
        textColor = lutealColor;
      } else {
        textColor = menstrualColor; // Predicted red text, no border
      }
    } else {
      textColor = (phase == CyclePhase.follicular)
          ? follicularColor
          : (phase == CyclePhase.ovulation)
          ? ovulationColor
          : lutealColor;
    }

    // 2. Selection Logic: Apply light grey only if NOT a logged period
    if (isSelected && !isLogged) {
      bgColor = Colors.grey.withOpacity(0.2); // Light grey for selection activity
    }

    return GestureDetector(
      onTap: () => _loadLogsForDate(date),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          SizedBox(
              height: 15,
              child: isToday
                  ? Text("Today", style: TextStyle(fontSize: 10, color: appColors.heading, fontWeight: FontWeight.w700))
                  : null
          ),
          const SizedBox(height: 4),
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: null, // Borders completely removed
            ),
            child: Text(
                "$day",
                style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, // Make selected text bolder
                    color: textColor
                )
            ),
          ),
        ],
      ),
    );
  }

  CyclePhase _getPhaseForCycleDay(int cycleDay, int cycleLen, int periodDur) {
    int follicularEnd = (cycleLen * 0.4).round();
    int ovulationEnd = follicularEnd + (cycleLen * 0.15).round();
    if (cycleDay <= periodDur) return CyclePhase.menstrual;
    if (cycleDay <= follicularEnd) return CyclePhase.follicular;
    if (cycleDay <= ovulationEnd) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  Widget _buildCountdownCard(DateTime onboarding, List<Map<String, dynamic>> history, int cycleLen, int periodDur) {
    final now = DateTime.now();
    DateTime latestStart = (history.isNotEmpty) ? (history.first['start_date'] as Timestamp).toDate() : onboarding;
    final target = DateTime(now.year, now.month, now.day);
    final start = DateTime(latestStart.year, latestStart.month, latestStart.day);
    final int diff = target.difference(start).inDays;
    final int cycleDay = (diff % cycleLen) + 1;
    bool isLate = diff >= cycleLen;
    String text = isLate ? "is ${diff - cycleLen + 1} days late" : (cycleDay <= periodDur) ? "Started" : "in ${cycleLen - cycleDay + 1} days";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFDEEF2), borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/icons/cycle tab icons/menstrual.png', height: 18, width: 18, color: menstrualColor),
            const SizedBox(width: 8),
            RichText(text: TextSpan(
              style: TextStyle(fontFamily: 'Satoshi', fontSize: 17, color: appColors.textPrimary),
              children: [
                const TextSpan(text: "Period "),
                TextSpan(text: text, style: TextStyle(fontWeight: FontWeight.w700, color: appColors.heading))
              ],
            )),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _legendDot("Follicular", follicularColor),
            const SizedBox(width: 26),
            _legendDot("Ovulation", ovulationColor),
            const SizedBox(width: 26),
            _legendDot("Luteal", lutealColor),
          ])
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color) => Row(children: [
    CircleAvatar(radius: 5, backgroundColor: color),
    const SizedBox(width: 6),
    Text(label, style: TextStyle(fontFamily: 'Satoshi', fontSize: 12, color: appColors.textPrimary))
  ]);

  Widget _buildWeekDayLabels() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => Text(day, style: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w500, color: appColors.textPrimary, fontSize: 14))).toList()),
  );

  Widget _buildBottomActionArea() {
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(_selectedDate, now);

    int dayInt = _selectedDate.day; // Get integer day directly
    String suffix = "th";

    if (dayInt >= 11 && dayInt <= 13) {
      suffix = "th";
    } else {
      switch (dayInt % 10) {
        case 1: suffix = "st"; break;
        case 2: suffix = "nd"; break;
        case 3: suffix = "rd"; break;
        default: suffix = "th";
      }
    }

    // Use curly braces to ensure variables are separated properly
    String formattedDate = isToday
        ? "today"
        : "${dayInt}$suffix ${DateFormat("MMM ''yy").format(_selectedDate)}";

      return Container(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 15),

        decoration: const BoxDecoration(
          color: Color(0xFFFDEEF2), // Light pink background from design
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ensures everything is left-aligned
          children: [
            // Sparkle icon and text header in a left-aligned Row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/sakhi icons/star.png', // Sparkle icon
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 14,
                      color: appColors.textPrimary.withOpacity(0.8),
                    ),
                    children: [
                      const TextSpan(text: "Your mood logged for "),
                      const TextSpan(text: " • ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: formattedDate,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: appColors.heading, // Highlighted date color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),


// Check if logs exist
            _selectedDateLogs.isEmpty
                ? Text(
              "No moods logged for this day",
              style: TextStyle(
                  color: const Color(0xFFD386B1).withOpacity(0.6),
                  fontSize: 13,
                  fontFamily: 'Satoshi'
              ),
            )
                : SizedBox(
              height: 60, // Give it a fixed height so the scroll view has a container
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Allows Row to grow horizontally
                  children: _selectedDateLogs.map((label) {
                    final icon = dynamicFeelingIcons[label] ?? 'default';
                    return Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/mood icons/$icon.png',
                            height: 32,
                            width: 32,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Satoshi',
                              color: appColors.textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Action Buttons Row (Log period and Edit Symptoms)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PeriodLoggingScreen())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD3667C),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      minimumSize: const Size(0, 45),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                            'assets/icons/cycle tab icons/log period.png',
                            height: 15,
                            color: Colors.white
                        ),

                        const SizedBox(width: 8),

                        Text(
                            "Log period",
                            style: TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD3667C), width: 1.2),
                      shape: const StadiumBorder(),
                      minimumSize: const Size(0, 45),
                      foregroundColor: const Color(0xFFD3667C),
                    ),
                    child: Text(
                        "Edit Moods",
                        style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    }
  }
