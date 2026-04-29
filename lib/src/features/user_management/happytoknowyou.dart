import 'package:flutter/material.dart';
import '../../core/theme/lockedcolors.dart';
import 'dart:async';
import '../cycles_tab/phase_transition_screen.dart';

class HappyToKnowYou extends StatefulWidget {
  const HappyToKnowYou({super.key});

  @override
  State<HappyToKnowYou> createState() => _HappyToKnowYouState();
}

class _HappyToKnowYouState extends State<HappyToKnowYou> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: _isLoaded ? _buildSuccessState() : _buildLoadingState(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      key: const ValueKey('loading_state'),
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/sakhi icons/happytoknowyou.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Stack(
      key: const ValueKey('success_state'),
      children: [
        // 1. Full Screen Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/icons/sakhi icons/notyourdoctor.png',
            fit: BoxFit.cover,
          ),
        ),

        // 2. UI Elements Overlay
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Keeps button at the bottom
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- CONTINUE BUTTON ---
                  SizedBox(
                    width: 149,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const PhaseTransitionScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LockedColors.button,
                        foregroundColor: LockedColors.buttonText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            'assets/icons/sakhi icons/whitestar.png',
                            height: 18,
                            width: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}