// lib/src/features/user_management/welcome_page.dart
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import '../../core/theme/theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // --- LOGO ---
              SizedBox(
                height: 220,
                width: 220,
                child: Image.asset(
                  'assets/icons/sakhi icons/sakhi.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Uses the error color defined in your theme
                    return Icon(
                      Icons.error,
                      color: colors.error,
                      size: 50,
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // --- APP NAME ---
              Text(
                'Sakhi',
                style: TextStyle(
                  fontFamily: 'Staresso',
                  fontSize: 64,
                  color: colors.heading,
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 50),

              // --- TAGLINE ---
              Text(
                'A gentle companion for your\nmonthly rhythm.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),

              const SizedBox(height: 30),

              // --- DESCRIPTION ---
              Text(
                'Sakhi is here to help you track your cycle,\n'
                    'understand your hormones, and feel cared\n'
                    'for through every phase.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: colors.textPrimary,
                ),
              ),

              const Spacer(flex: 1),

              // --- GET STARTED BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- LOGIN FOOTER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                      color: colors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                        color: colors.button,
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