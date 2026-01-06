import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // --- LOGO SECTION ---
              Center(
                child: SizedBox(
                  height: 220, // Increased size slightly for better visibility
                  width: 220,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      'assets/icons/sakhi icons/sakhi.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // App Name - Staresso Demo
              const Text(
                'Sakhi',
                style: TextStyle(
                  fontFamily: 'Staresso', // Matches pubspec family name
                  fontSize: 64,
                  color: Color(0xFFD85C7B),
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 50),

              // Tagline - Satoshi Medium (600)
              const Text(
                'A gentle companion for your\nmonthly rhythm.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 18,
                  fontWeight: FontWeight.w500, // Linked to Medium per your setup
                  color: Color(0xFF8D5A6A),
                ),
              ),

              const SizedBox(height: 30),

              // Description - Satoshi Regular (300)
              const Text(
                'Sakhi is here to help you track your cycle,\nunderstand your hormones, and feel cared\nfor through every phase.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w400, // Linked to Regular per your setup
                  color: Color(0xFFB57E8F),
                ),
              ),

              const Spacer(flex: 1),

              // Get Started Button - Satoshi Medium (500)
// Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Signup Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD85C7B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFAC7F89),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Login Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD66B81),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}