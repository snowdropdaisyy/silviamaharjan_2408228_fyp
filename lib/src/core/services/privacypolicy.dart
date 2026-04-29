import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/lockedcolors.dart';


class PrivacyPolicyScreen extends StatelessWidget {
  final bool isLocked;

  const PrivacyPolicyScreen({super.key, this.isLocked = false});

  @override
  Widget build(BuildContext context) {
    String formattedDate = "April 12, 2026";

    // Theme-aware colors
    final Color bgColor = isLocked ? LockedColors.background : context.colors.background;
    final Color textColor = isLocked ? LockedColors.textPrimary : context.colors.textPrimary;
    final Color headingColor = isLocked ? LockedColors.button : context.colors.button;

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
              "Privacy Policy — Sakhi",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isLocked ? LockedColors.heading : context.colors.heading,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Last updated: $formattedDate",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),

            _buildSection(
              "Hey! Thanks for using Sakhi 🌸",
              "We understand that period and health data is deeply personal. It stays private, stored only under your account, and is never shared with anyone.",
              textColor, headingColor,
            ),

            _buildSection(
              "What we collect",
              "We collect personal information you provide during setup — like your email, cycle dates, mood logs, and birthday. This helps us give you a personalised experience.",
              textColor, headingColor,
            ),

            _buildSection(
              "Where it's stored",
              "All your data is securely stored using Google Firebase. We don't sell, share, or do anything sneaky with it.",
              textColor, headingColor,
            ),

            _buildSection(
              "Deleting your account",
              "If you choose to delete your account, all your data — cycle history, mood logs, everything — is permanently deleted from our systems. This cannot be undone or recovered, so please be sure before you go! 💛",
              textColor, headingColor,
            ),

            _buildSection(
              "Contact",
              "Sakhi is a personal project by Silvia Maharjan. For any questions, concerns, or just to say hi — reach out at maharjansilvia456@gmail.com",
              textColor, headingColor,
            ),

            const SizedBox(height: 20),
            Text(
              "By using Sakhi, you agree to this policy.",
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor.withOpacity(0.8),
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