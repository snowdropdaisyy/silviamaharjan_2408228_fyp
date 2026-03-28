import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/theme.dart';
import '../cycles_tab/phase_transition_screen.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import '../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ================= LOGIC HANDLERS =================

  Future<bool> _isOnboardingDone() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // Use a try-catch specifically here to stop the red error box
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        // Check if the flag exists, otherwise assume false
        return doc.data()?['onboardingComplete'] == true;
      }
      return false; // Document doesn't exist, send to onboarding
    } catch (e) {
      debugPrint("Permission or Read Error: $e");
      return false; // If permission is denied, safe-fail to onboarding
    }
  }

  Future<void> _handleEmailLogin() async {
    setState(() { _emailError = null; _passwordError = null; });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // 1. Perform Login
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      // 2. FORCE a token refresh to make sure Firestore knows who we are
      await credential.user?.getIdToken(true);

      // 3. Double check verification
      if (!credential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        _snack("Please verify your email first!");
        setState(() => _isLoading = false);
        return;
      }

      // 4. Check onboarding status ONLY after we are 100% sure we have a UID
      final isDone = await _isOnboardingDone();

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => isDone ? const PhaseTransitionScreen() : const OnboardingScreen()),
            (_) => false,
      );
    } on FirebaseException catch (e) {
      _snack("Firebase Error: ${e.code} - ${e.message}");
    } catch (e) {
      _snack("Login Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog() {
    final TextEditingController resetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Reset Password",
          style: TextStyle(fontFamily: 'Satoshi', color: appColors.heading),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter your email and we'll send you a reset link.",
              style: TextStyle(fontFamily: 'Satoshi', color: appColors.textPrimary),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: resetController,
              decoration: InputDecoration(
                hintText: "Email address",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: appColors.inputFieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: appColors.button),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: appColors.textPrimary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = resetController.text.trim();
              if (email.isNotEmpty) {
                try {
                  await _authService.sendPasswordReset(email);
                  Navigator.pop(context);
                  _snack("Reset link sent! Check your email.");
                } catch (e) {
                  _snack("Error: ${e.toString()}");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.button,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Send", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              // Matched Header with Signup Screen
              Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: appColors.heading,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      "to Sakhi",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: appColors.heading,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/icons/sakhi icons/star.png',
                      height: 50,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // EMAIL INPUT
              _inputField(
                _emailController,
                hint: "Email address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),

              const SizedBox(height: 25),

              // PASSWORD INPUT
              _inputField(
                _passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                isPassword: true,
                errorText: _passwordError,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 15),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _showForgotPasswordDialog,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: appColors.button,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ACTIONS
              _primaryButton('Log in', _handleEmailLogin),
              const SizedBox(height: 15),
              _divider(),
              const SizedBox(height: 15),
              _googleButton(() => _authService.signInWithGoogle(isSignUp: false)),

              const Spacer(),

              // FOOTER
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account? ',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        color: appColors.textPrimary.withOpacity(0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      ),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          color: appColors.button,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _inputField(
      TextEditingController controller, {
        required String hint,
        required IconData icon,
        bool obscure = false,
        bool isPassword = false,
        VoidCallback? onSuffixTap,
        TextInputType? keyboardType,
        String? errorText,
      }) {
    final bool isActive = controller.text.isNotEmpty;

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: (value) => setState(() {}),
      style: TextStyle(
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
        color: appColors.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.withOpacity(0.6),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: Icon(
            icon,
            color: isActive ? appColors.heading : Colors.grey.withOpacity(0.5),
            size: 22,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        errorText: errorText,
        suffixIcon: isPassword
            ? Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: onSuffixTap,
            child: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: appColors.textPrimary.withOpacity(0.4),
              size: 20,
            ),
          ),
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: appColors.inputFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: appColors.button, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: appColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: appColors.error, width: 2),
        ),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Satoshi',
          ),
        ),
      ),
    );
  }

  Widget _googleButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: appColors.button.withOpacity(0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/sakhi icons/google.png', height: 20),
            const SizedBox(width: 12),
            Text(
              'Google',
              style: TextStyle(
                fontSize: 16,
                color: appColors.button,
                fontWeight: FontWeight.w500,
                fontFamily: 'Satoshi',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Row(
    children: [
      Expanded(child: Divider(color: appColors.inputFieldBorder.withOpacity(0.5))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          "Or Continue With",
          style: TextStyle(color: appColors.textPrimary.withOpacity(0.8), fontSize: 11),
        ),
      ),
      Expanded(child: Divider(color: appColors.inputFieldBorder.withOpacity(0.5))),
    ],
  );

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Satoshi', color: appColors.heading, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      ),
    );
  }
}