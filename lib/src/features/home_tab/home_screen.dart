import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/utils/phase_calculator.dart';
import 'package:silviamaharjan_2408228_fyp/src/features/user_management/controllers/database_service.dart';
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
  String _currentPhaseId = 'follicular';
  bool _isLoadingUser = true;

  // New State variables for Logging
  List<String> _loggedFeelings = [];
  final String _todayKey = DateTime.now().toIso8601String().split('T')[0];
  // Add these at the top of your _CycleTabState class
  List<String> _selectedDateLogs = []; // Stores the mood labels for the horizontal list
  final DateTime _selectedDate = DateTime.now(); // Tracks which day is currently clicked in the calendar

  @override
  void initState() {
    super.initState();
    _initializeHomeData();
  }

  Future<void> _initializeHomeData() async {
    try {
      // Fetch user info and today's logs simultaneously
      final fullData = await _dbService.getUserData();
      final savedLogs = await _dbService.getDailyLogs(_todayKey);

      if (fullData != null) {
        final onboarding = fullData['onboarding'] as Map<String, dynamic>?;
        final name = onboarding?['name'] ?? fullData['name'] ?? "User";
        final lastPeriodStr = onboarding?['last_period'] ?? fullData['last_period'];
        final num cycleLength = onboarding?['cycle_length'] ?? fullData['cycle_length'] ?? 28;
        final num periodDuration = onboarding?['period_duration'] ?? fullData['period_duration'] ?? 5;

        if (lastPeriodStr != null) {
          final lastPeriod = DateTime.parse(lastPeriodStr);
          final daysSinceStart = DateTime.now().difference(lastPeriod).inDays;
          final int dayInCycle = (daysSinceStart % cycleLength.toInt()) + 1;

          final phaseEnum = PhaseCalculator.calculatePhase(
            lastPeriodDate: lastPeriod,
            cycleLength: cycleLength.toInt(),
            periodDuration: periodDuration.toInt(),
          );

          if (mounted) {
            setState(() {
              _userName = name;
              _currentDay = dayInCycle;
              _currentPhaseId = phaseEnum.name.toLowerCase();
              _loggedFeelings = List<String>.from(savedLogs); // Sync logged icons
              _isLoadingUser = false;
              _phaseContentFuture = _homeService.getPhaseData(_currentPhaseId);
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error initializing home data: $e");
      if (mounted) setState(() => _isLoadingUser = false);
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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

            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!;

              // Populate the global map dynamically from Firebase metadata
              for (var feeling in data.feelings) {
                final label = feeling['label']?.toString() ?? '';
                final icon = feeling['icon']?.toString() ?? '';
                if (label.isNotEmpty) {
                  dynamicFeelingIcons[label] = icon;
                }
              }
            }
            final data = snapshot.data;
            if (data == null) return const Center(child: Text("Data missing"));

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderSection(context),
                  _buildPhaseDescription(data.description),
                  _buildDuringPhaseSection(data.duringPhase),
                  _buildHormonalInsightsSection(data.hormones, _currentPhaseId),
                  _buildFeelingsSection(data.feelings),
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
            height: MediaQuery.of(context).size.height * 0.50,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(_getPhaseMessage(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 40),
            Text("Day $_currentDay", style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.w500)),
            Text("${_currentPhaseId[0].toUpperCase()}${_currentPhaseId.substring(1)}\nPhase",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w500, fontFamily: 'Satoshi', height: 1.1)),
          ],
        ),
      ],
    );
  }

  Widget _buildPhaseDescription(String description) {
    return Column(
      children: [
        Transform.translate(offset: const Offset(0, -50), child: Image.asset('assets/icons/sakhi icons/star.png', height: 90)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 20.0),
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
            const SizedBox(height: 50),
            Image.asset('assets/icons/sakhi icons/star.png', height: 60),
            const SizedBox(height: 50),
            ...duringPhase.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
            Image.asset('assets/icons/home tab icons/$fileName gradient.png', fit: BoxFit.cover),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(status, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi')),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingsSection(List<dynamic> feelings) {
    if (feelings.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 100),
        Text("So, you may be feeling",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Satoshi', color: appColors.textPrimary)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feelings.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85
            ),
            itemBuilder: (context, index) {
              final feeling = feelings[index] as Map<String, dynamic>;
              final String iconName = feeling['icon']?.toString() ?? '';
              final String label = feeling['label']?.toString() ?? '';
              final bool isSelected = _loggedFeelings.contains(label);

              return GestureDetector(
                onTap: () async {
                  // 1. Determine if we are adding or removing BEFORE the async call
                  final bool isCurrentlySelected = _loggedFeelings.contains(label);

                  setState(() {
                    if (isCurrentlySelected) {
                      // REMOVE logic
                      _loggedFeelings.remove(label);
                      _snack("Mood removed", isError: true);
                    } else {
                      // ADD logic
                      _loggedFeelings.add(label);
                      _snack("Mood Logged!", title: "Success");
                    }

                    // 2. IMMEDIATE SYNC for the horizontal calendar row
                    if (DateUtils.isSameDay(_selectedDate, DateTime.now())) {
                      // Use List.from to create a deep copy so the UI detects the change
                      _selectedDateLogs = List.from(_loggedFeelings);
                    }
                  });

                  // 3. Update Firestore in the background
                  await _dbService.toggleFeelingLog(label, _todayKey);
                },

                child: Column(
                  children: [
                    Opacity(
                      opacity: isSelected ? 0.4 : 1.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/icons/home tab icons/icon-gradient.png', height: 100, width: 100),
                          Image.asset('assets/icons/mood icons/$iconName.png', height: 50),
                        ],
                      ),
                    ),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, fontFamily: 'Satoshi', color: appColors.textPrimary),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  void _snack(String message, {String title = "Log Updated", bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
                isError ? Icons.cancel : Icons.check_circle,
                color: isError ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32),
                size: 24
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isError ? "Removed" : title,
                    style: TextStyle(fontFamily: 'Satoshi', color: appColors.heading, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    message,
                    style: TextStyle(fontFamily: 'Satoshi', color: appColors.textPrimary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- HORMONE MODAL ---
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
                  const SizedBox(height: 30),
                  if (!isLoading && hData != null) ...[
                    Stack(alignment: Alignment.center, children: [
                      Image.asset('assets/icons/home tab icons/icon-gradient.png', height: 200),
                      Image.asset('assets/icons/home tab icons/hormoneinsights.png', height: 80),
                    ]),
                    Text(hData['name'] ?? '', style: TextStyle(fontFamily: 'Satoshi', color: appColors.heading, fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 15),
                    Text(hData['description'] ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Satoshi', color: appColors.textPrimary)),
                    const SizedBox(height: 30),
                    Text("Current Phase Effect", style: TextStyle(fontFamily: 'Satoshi', color: appColors.heading, fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 15),
                    Text(hData['phase_effect'] ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Satoshi', color: appColors.textPrimary)),
                  ] else const SizedBox(height: 300),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }
}