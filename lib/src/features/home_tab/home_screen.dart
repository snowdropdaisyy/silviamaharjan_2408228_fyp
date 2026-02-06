import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/phase_calculator.dart';
import '../user_management/controllers/database_service.dart';

// import 'widgets/menstrual_card_home.dart';
// import 'widgets/follicular_card_home.dart';
// import 'widgets/ovulation_card_home.dart';
// import 'widgets/luteal_card_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dbService = DatabaseService();
  CyclePhase? _currentPhase;
  String _userName = "User";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 1. Fetch full user document from Firestore
      final fullData = await _dbService.getUserData();

      if (fullData != null && fullData['onboarding'] != null) {
        final Map<String, dynamic> onboarding = Map<String, dynamic>.from(fullData['onboarding']);

        // 2. Extract metadata for calculation
        final lastPeriodStr = onboarding['last_period'];
        final cycleLength = onboarding['cycle_length'] as int? ?? 28;
        final periodDuration = onboarding['period_duration'] as int? ?? 5;
        final name = onboarding['name'] ?? "User";

        if (lastPeriodStr != null) {
          // 3. Use PhaseCalculator to get the current phase
          final phase = PhaseCalculator.calculatePhase(
            lastPeriodDate: DateTime.parse(lastPeriodStr),
            cycleLength: cycleLength,
            periodDuration: periodDuration,
          );

          if (mounted) {
            setState(() {
              _currentPhase = phase;
              _userName = name;
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Home Load Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show spinner while fetching from Firestore
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Fallback if user hasn't done onboarding
    if (_currentPhase == null) {
      return const Scaffold(body: Center(child: Text("Data not found. Please re-login.")));
    }

    return Scaffold(
      backgroundColor: appColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header showing user name
              _buildHeader(_userName),

              // 2. THE DYNAMIC CARD SWITCHER (The Matching Principle!)
              _buildPhaseSpecificCard(_currentPhase!),

              // 3. You can add more widgets here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Hi, ${name.toLowerCase()} ✨",
        style: TextStyle(
          fontFamily: 'Satoshi',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: appColors.heading,
        ),
      ),
    );
  }

  Widget _buildPhaseSpecificCard(CyclePhase phase) {
    // One variable (phase) decides which complex UI to show.
    switch (phase) {
      case CyclePhase.menstrual:
        return const Center(child: Text("Menstrual UI Card Here"));
      case CyclePhase.follicular:
        return const Center(child: Text("Follicular UI Card Here"));
      case CyclePhase.ovulation:
        return const Center(child: Text("Ovulation UI Card Here"));
      case CyclePhase.luteal:
        return const Center(child: Text("Luteal UI Card Here"));
    }
  }
}