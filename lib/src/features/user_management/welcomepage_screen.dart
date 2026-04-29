import 'package:flutter/material.dart';
import '../../core/services/deep_link_service.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import '../../core/theme/lockedcolors.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService.instance.handlePendingLink();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = LockedColors; // 👈 FIXED

    return Scaffold(
      backgroundColor: LockedColors.background,
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
                    return Icon(
                      Icons.error,
                      color: LockedColors.error,
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
                  color: LockedColors.heading,
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
                  color: LockedColors.textPrimary,
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
                  color: LockedColors.textPrimary,
                ),
              ),

              const Spacer(flex: 1),

              // --- GET STARTED BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LockedColors.button,
                    foregroundColor: LockedColors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Get Started',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
                      color: LockedColors.textPrimary,
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
                        color: LockedColors.button,
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