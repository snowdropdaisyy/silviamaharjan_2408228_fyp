import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/utils/phase_calculator.dart';
import 'package:silviamaharjan_2408228_fyp/src/features/cycles_tab/sub_tabs/period_logging_screen.dart';
import '../../core/services/database_service.dart';
import '../home_tab/models/phase_model.dart';
import '../home_tab/services/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService _homeService = HomeService();
  final DatabaseService _dbService = DatabaseService();

  Future<PhaseContent?>? _phaseContentFuture;
  String _userName = "User";
  int _currentDay = 1;
  int _userAge = 0;
  String _currentPhaseId = 'follicular';
  bool _isLoadingUser = true;

  List<Map<String, dynamic>> _loggedFeelings = [];
  final String _todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeHomeData();
  }

  // --- FUNCTION: Calculate Age ---
  int _calculateAge(String? birthdayString) {
    if (birthdayString == null || birthdayString.isEmpty) return 0;
    try {
      DateTime birthDate = DateTime.parse(birthdayString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  // --- FUNCTION: Initialize Data ---
  Future<void> _initializeHomeData() async {
    try {
      final fullData = await _dbService.getUserData();
      final DateTime? latestPeriod = await _dbService.getLatestPeriodStart();
      final savedLogs = await _dbService.getFeelingsForDate(_todayKey);

      if (fullData != null) {
        // Checking both top-level and onboarding map for the new 'birthday' key
        final onboarding = fullData['onboarding'] as Map<String, dynamic>?;

        final name = onboarding?['name'] ?? fullData['name'] ?? "User";
        final birthdayStr = onboarding?['birthday'] ?? fullData['birthday'];

        // Handle Period Logic
        final lastPeriodStr = onboarding?['last_period'] ?? fullData['last_period'];

        // If everything is null, we provide defaults to prevent the 'Data Missing' crash
        final DateTime lastPeriod = latestPeriod ??
            (lastPeriodStr != null ? DateTime.parse(lastPeriodStr) : DateTime.now().subtract(const Duration(days: 14)));

        final num cycleLength = onboarding?['cycle_length'] ?? fullData['cycle_length'] ?? 28;
        final num periodDuration = onboarding?['period_duration'] ?? fullData['period_duration'] ?? 5;

        // Linear Day Calculation
        final now = DateTime.now();
        final start = DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day);
        final today = DateTime(now.year, now.month, now.day);
        final int dayInCycle = today.difference(start).inDays + 1;

        final phaseEnum = PhaseCalculator.calculatePhase(
          lastPeriodDate: lastPeriod,
          cycleLength: cycleLength.toInt(),
          periodDuration: periodDuration.toInt(),
        );

        if (mounted) {
          setState(() {
            _userName = name;
            _userAge = _calculateAge(birthdayStr);
            _currentDay = dayInCycle;
            _currentPhaseId = phaseEnum.name.toLowerCase();
            _loggedFeelings = savedLogs;
            _isLoadingUser = false;
            _phaseContentFuture = _homeService.getPhaseData(_currentPhaseId);
          });
        }
      }
    } catch (e) {
      debugPrint("Init Error: $e");
      if (mounted) setState(() => _isLoadingUser = false);
    }
  }

  // --- FUNCTION: Toggle Mood ---
  Future<void> _toggleMood(String label, String iconName) async {
    final bool isSelected = _loggedFeelings.any((log) => log['label'] == label);

    setState(() {
      if (isSelected) {
        _loggedFeelings.removeWhere((item) => item['label'] == label);
        _snack("Mood removed", isError: true);
      } else {
        _loggedFeelings.add({'label': label, 'icon': iconName});
        _snack("Mood Logged!", title: "Success");
      }
    });

    try {
      await _dbService.toggleFeelingLog(_loggedFeelings, _todayKey);
    } catch (e) {
      debugPrint("Error saving moods: $e");
    }
  }

  String _getPhaseMessage() {
    switch (_currentPhaseId) {
      case 'menstrual': return "$_userName, take it easy and prioritize rest today.";
      case 'follicular': return "$_userName, you must be feeling fearless today!";
      case 'ovulatory': return "$_userName, you're glowing and full of energy!";
      case 'luteal': return "$_userName, it's time to slow down and nurture yourself.";
      default: return "$_userName, welcome back to your journey.";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return Scaffold(backgroundColor: appColors.background, body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: appColors.background,
      body: SafeArea(
        top: false,
        child: FutureBuilder<PhaseContent?>(
          future: _phaseContentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data;
            if (data == null) {
              return Center(child: Text("Missing data for phase: $_currentPhaseId", style: const TextStyle(fontFamily: 'Satoshi')));
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeaderSection(context),
                  const SizedBox(height: 40),
                  _buildPhaseDescription(data.description),
                  _buildDuringPhaseSection(data.duringPhase),
                  _buildHormonalInsightsSection(data.hormones, _currentPhaseId),
                  _buildFeelingsSection(data.feelings),
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- UI SECTIONS ---

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.transparent],
            stops: [0.7, 1.0],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height)),
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            'assets/icons/home tab icons/phase display-gradient.png',
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.48,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  _getPhaseMessage(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Day $_currentDay",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${_currentPhaseId[0].toUpperCase()}${_currentPhaseId.substring(1)}\nPhase",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 52,
                fontWeight: FontWeight.w500,
                fontFamily: 'Satoshi',
                height: 1.1,
              ),
            ),

            const SizedBox(height: 60),
            _buildLogPeriodButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildLogPeriodButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PeriodLoggingScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.heading.withOpacity(0.25),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/cycle tab icons/log period.png',
            height: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          const Text(
            "Log period",
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseDescription(String description) {
    return Column(
      children: [
        Transform.translate(offset: const Offset(0, -20), child: Image.asset('assets/icons/sakhi icons/star.png', height: 85)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
          child: Text(description, textAlign: TextAlign.center, style: TextStyle(color: appColors.textPrimary, fontSize: 18, height: 1.5, fontFamily: 'Satoshi')),
        ),
      ],
    );
  }

  Widget _buildDuringPhaseSection(List<String> duringPhase) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/icons/home tab icons/during this phase-gradient.png', fit: BoxFit.contain),
        Column(
          children: [
            Text("During This Phase", style: TextStyle(color: appColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Satoshi')),
            const SizedBox(height: 30),
            ...duringPhase.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
              child: Text(item, textAlign: TextAlign.center, style: TextStyle(color: appColors.textPrimary, fontSize: 16, fontFamily: 'Satoshi')),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildHormonalInsightsSection(List<String> hormones, String currentPhaseId) {
    return Column(
      children: [
        Text("Hormonal Insights", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Satoshi', color: appColors.textPrimary)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: hormones.length,
            itemBuilder: (context, index) => _buildHormoneCard(hormones[index], currentPhaseId),
          ),
        ),
      ],
    );
  }

  Widget _buildHormoneCard(String fullText, String phaseId) {
    List<String> parts = fullText.trim().split(' ');
    String name = parts.last;
    String status = parts.sublist(0, parts.length - 1).join(' ');
    String fileName = name.toLowerCase().trim();

    return GestureDetector(
      onTap: () => _showHormoneInsight(phaseId, fileName),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/icons/home tab icons/$fileName gradient.png', fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(status, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.w500)),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingsSection(List<dynamic> feelings) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          "So, you may be feeling",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Satoshi', color: appColors.textPrimary),
        ),
        const SizedBox(height: 5),
        Text(
          "(Tap on what applies!)",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Satoshi', color: appColors.heading.withOpacity(0.4)),
        ),

        Padding(
          // REDUCED TOP PADDING HERE
          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 40, right: 40),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feelings.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final feeling = feelings[index] as Map<String, dynamic>;
              final String label = feeling['label'] ?? '';
              final String iconName = feeling['icon'] ?? '';
              final bool isSelected = _loggedFeelings.any((log) => log['label'] == label);

              return GestureDetector(
                onTap: () => _toggleMood(label, iconName),
                child: Column(
                  children: [
                    Opacity(
                      opacity: isSelected ? 0.4 : 1.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/icons/home tab icons/icon-gradient.png', height: 70),
                          Image.asset(
                            'assets/icons/mood icons/$iconName.png',
                            height: 45,
                            errorBuilder: (c, e, s) => const Icon(Icons.mood, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(label, style: TextStyle(fontSize: 13, fontFamily: 'Satoshi', color: appColors.textPrimary)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _snack(String message, {String title = "Log Updated", bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(message, style: TextStyle(color: isError ? Colors.red : Colors.green, fontFamily: 'Satoshi')),
      ),
    );
  }

  void _showHormoneInsight(String phaseId, String hormoneId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('home_tab').doc(phaseId).collection('hormone_insights').doc(hormoneId).get(),
          builder: (context, snapshot) {
            bool isLoading = snapshot.connectionState == ConnectionState.waiting;
            var hData = (snapshot.hasData && snapshot.data!.exists) ? snapshot.data!.data() as Map<String, dynamic> : null;
            return Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: appColors.background, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  if (!isLoading && hData != null) ...[
                    Stack(alignment: Alignment.center, children: [
                      Image.asset('assets/icons/home tab icons/icon-gradient.png', height: 200),
                      Image.asset('assets/icons/home tab icons/hormoneinsights.png', height: 80),
                    ]),
                    Text(hData['name'] ?? '', style: TextStyle(fontFamily: 'Satoshi', color: appColors.heading, fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Text(hData['description'] ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Satoshi', color: appColors.textPrimary)),
                    const SizedBox(height: 30),
                    Text("Current Phase Effect", style: TextStyle(fontFamily: 'Satoshi', color: appColors.heading, fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 15),
                    Text(hData['phase_effect'] ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Satoshi', color: appColors.textPrimary)),
                  ] else const SizedBox(height: 300),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }
}