import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    // Colors maintained from your LoginScreen code
    const primaryPink = Color(0xFFDB6683);
    const titlePink = Color(0xFFDB6683);
    const textGray = Color(0xFF8D5A6A);
    const borderGray = Color(0xFFD9CACE);
    const scaffoldBg = Color(0xFFFFFBFC);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textGray, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Your cycle story\nstarts here ',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: titlePink,
                      letterSpacing: -0.5,
                      height: 1.1, // Adjust line height for better spacing
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Image.asset(
                      'assets/icons/sakhi icons/star 2.png',
                      height: 35, // Increased slightly to match 40px text better
                      width: 35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join now and explore more.',
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textGray,
              ),
            ),

            const SizedBox(height: 40),

            // Email Field
            const Text(
              'Email address',
              style: TextStyle(
                fontFamily: 'Satoshi',
                color: textGray,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(fontFamily: 'Satoshi'),
              decoration: _inputDecoration(borderGray, primaryPink),
            ),

            const SizedBox(height: 24),

            // Password Field
            const Text(
              'Password',
              style: TextStyle(
                fontFamily: 'Satoshi',
                color: textGray,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              style: const TextStyle(fontFamily: 'Satoshi'),
              decoration: _inputDecoration(borderGray, primaryPink),
            ),

            const SizedBox(height: 24),

            // Confirm Password Field
            const Text(
              'Confirm Password',
              style: TextStyle(
                fontFamily: 'Satoshi',
                color: textGray,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              style: const TextStyle(fontFamily: 'Satoshi'),
              decoration: _inputDecoration(borderGray, primaryPink),
            ),

            const SizedBox(height: 24),

            // Terms and Conditions Checkbox
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isAccepted,
                    activeColor: primaryPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(color: borderGray, width: 1.5),
                    onChanged: (value) {
                      setState(() {
                        _isAccepted = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'I accept the ',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    color: textGray,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Terms and Conditions.',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: textGray,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Sign up Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Divider Section
            Row(
              children: const [
                Expanded(child: Divider(color: borderGray, thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Or Continue with',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: textGray,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: borderGray, thickness: 1)),
              ],
            ),

            const SizedBox(height: 24),

            // Google Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: titlePink),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/sakhi icons/google.png',
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Google',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 16,
                        color: Color(0xFF8D5A6A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper to keep input decoration consistent
  InputDecoration _inputDecoration(Color borderGray, Color primaryPink) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryPink),
      ),
    );
  }
}