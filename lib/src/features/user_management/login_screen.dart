import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact color hexes from the design
    const primaryPink = Color(0xFFDB6683); // For the main Log In button
    const titlePink = Color(0xFFDB6683);   // For "Welcome Back" and "Reset"
    const textGray = Color(0xFF8D5A6A);    // For subtitles and labels
    const borderGray = Color(0xFFD9CACE);  // For input borders and dividers

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBFC),
        elevation: 0,
        leading: IconButton(
          // Using a thinner icon to match the Figma back arrow
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

// Welcome Back Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 40, // Updated to 40
                    fontWeight: FontWeight.w500,
                    color: titlePink,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 10),
                // Using your specific local asset for the star icon
                Image.asset(
                  'assets/icons/sakhi icons/star 2.png',
                  height: 24,
                  width: 24,
                  // color: titlePink, // Uncomment this if you want to tint the PNG via code
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Log in to bloom through your cycle phases.',
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textGray,
              ),
            ),

            const SizedBox(height: 48),

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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: borderGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: primaryPink),
                ),
              ),
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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: borderGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: primaryPink),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Forgot Password
            Row(
              children: [
                const Text(
                  'Forgot Password? ',
                  style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: textGray,
                      fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: titlePink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // Log in Button
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
                  'Log in',
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
                  // The design shows a pink border for the Google button
                  side: const BorderSide(color: titlePink),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Updated to use your local asset path
                    Image.asset(
                      'assets/icons/sakhi icons/google.png',
                      height: 24, // Slightly increased height for better visibility
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Google',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 16,
                        color: Color(0xFF8D5A6A),
                        fontWeight: FontWeight.w700, // Set to bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}