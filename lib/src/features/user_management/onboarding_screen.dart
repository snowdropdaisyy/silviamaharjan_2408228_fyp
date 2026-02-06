import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/theme.dart';
import '../cycles_tab/phase_transition_screen.dart';
import 'widgets/q1.dart';
import 'widgets/q2.dart';
import 'widgets/q3.dart';
import 'widgets/q4.dart';
import 'widgets/q5.dart';
import 'widgets/q6.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();

  int _page = 0;
  bool _loading = false;

  final Map<String, dynamic> _data = {
    'name': '',
    'age': 0,
    'last_period': '',
    'cycle_length': 28,
    'period_duration': 5,
    'diet': '',
    'notifications': false,
  };

  void _next() async {
    if (_page < 5) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        ..._data,
        'onboardingComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PhaseTransitionScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Progress bar
            Row(
              children: List.generate(
                6,
                    (i) => Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: i <= _page
                        ? colors.button
                        : colors.inputFieldBorder,
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  Q1(onDataChanged: (name, age) {
                    _data['name'] = name;
                    _data['age'] = age;
                  }),
                  Q2(onDateSelected: (d) {
                    _data['last_period'] = d.toIso8601String();
                  }),
                  Q3(onLengthChanged: (v) {
                    _data['cycle_length'] = v;
                  }),
                  Q4(onDurationChanged: (v) {
                    _data['period_duration'] = v;
                  }),
                  Q5(onDietChanged: (v) {
                    _data['diet'] = v;
                  }),
                  Q6(onNotificationChanged: (v) {
                    _data['notifications'] = v;
                  }),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextButton(
                onPressed: _loading ? null : _next,
                child: _loading
                    ? const CircularProgressIndicator()
                    : Text(
                  _page == 5 ? 'Finish' : 'Next',
                  style: TextStyle(
                    fontSize: 18,
                    color: colors.button,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
