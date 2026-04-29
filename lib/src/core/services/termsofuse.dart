import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/lockedcolors.dart';

class TermsOfUseScreen extends StatelessWidget {
  final bool isLocked;

  const TermsOfUseScreen({super.key, this.isLocked = false});

  @override
  Widget build(BuildContext context) {
    String formattedDate = "April 12, 2026";

    final Color bgColor = isLocked ? LockedColors.background : context.colors.background;
    final Color textColor = isLocked ? LockedColors.textPrimary : context.colors.textPrimary;
    final Color headingColor = isLocked ? LockedColors.heading : context.colors.button;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms of Use — Sakhi",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isLocked ? LockedColors.heading : context.colors.heading,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Effective Date: $formattedDate",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),

            _buildSection(
              "1. Not Medical Advice 🩺",
              "Sakhi is a tool for self-tracking and wellness education. It is NOT a medical device and does not provide professional medical advice, diagnosis, or treatment. Always consult with a healthcare professional for medical concerns.",
              textColor, headingColor,
            ),

            _buildSection(
              "2. Account Responsibility",
              "You are responsible for keeping your login credentials secure. Sakhi uses Firebase for authentication, but your account's safety also depends on you using a strong password.",
              textColor, headingColor,
            ),

            _buildSection(
              "3. Intellectual Property",
              "The design, code, logos, and 'Sakhi' brand are the intellectual property of Silvia Maharjan. You may not copy, modify, or distribute any part of the app without explicit permission.",
              textColor, headingColor,
            ),

            _buildSection(
              "4. User Conduct",
              "By using Sakhi, you agree not to attempt to reverse engineer the app, bypass security features, or use the service for any illegal activities.",
              textColor, headingColor,
            ),

            _buildSection(
              "5. Limitation of Liability",
              "Sakhi is provided 'as is' without warranties. As a personal project, Silvia Maharjan is not liable for any data loss, inaccuracies in predictions, or decisions made based on the app's output.",
              textColor, headingColor,
            ),

            _buildSection(
              "6. Changes to Terms",
              "We may update these terms from time to time. Your continued use of the app after changes are posted means you accept the new terms.",
              textColor, headingColor,
            ),

            const SizedBox(height: 20),
            Text(
              "If you have questions about these terms, reach out at maharjansilvia456@gmail.com",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body, Color textColor, Color headingColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: textColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}