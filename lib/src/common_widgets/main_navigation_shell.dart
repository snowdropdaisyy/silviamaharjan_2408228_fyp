import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silviamaharjan_2408228_fyp/src/features/nutrition_tab/nutrition_screen.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/utils/phase_calculator.dart';
import '../features/home_tab/home_screen.dart';
import '../features/cycles_tab/cycles_screen.dart';
import '../core/theme/theme.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;
  String userDiet = 'vegetarian';
  String currentPhase = 'follicular';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data()!;
          // Update our variables with real data
          setState(() {
            userDiet = data['diet'] ?? 'vegetarian';
            // Assuming your PhaseCalculator works as intended
            currentPhase = 'follicular'; // Or use your calculator logic here
          });
        }
      }
    } finally {
      // STOP loading only when data is 100% ready
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX: If we are loading, show a spinner and NOTHING else.
    // This prevents NutritionScreen from building too early.
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.pink)),
      );
    }

    // Now it is safe to build the screens
    final List<Widget> screens = [
      const HomeScreen(),
      const CyclesScreen(),
      NutritionScreen(diet: userDiet, phase: currentPhase),
      const Center(child: Text("Chat")),
      const Center(child: Text("Profile")),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }


  // --- UI Components ---

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: appColors.heading,
                );
              }
              return const TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xFFF2C7D2),
              );
            }),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              backgroundColor: Colors.white,
              elevation: 0,
              height: 70,
              destinations: [
                _buildDestination('Home', 'home.png', 0),
                _buildDestination('Cycles', 'cycles.png', 1),
                _buildDestination('Nutrition', 'nutrition.png', 2),
                _buildDestination('Chat', 'chat.png', 3),
                _buildDestination('Profile', 'profile.png', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildDestination(String label, String iconName, int index) {
    bool isActive = _selectedIndex == index;
    return NavigationDestination(
      icon: Image.asset(
        'assets/icons/navbar icons/$iconName',
        width: 35,
        height: 35,
        color: isActive ? appColors.heading : const Color(0xFFF2C7D2),
      ),
      label: label,
    );
  }
}