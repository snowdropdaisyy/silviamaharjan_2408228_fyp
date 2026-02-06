import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/theme.dart';
import '../cycles_tab/phase_transition_screen.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import 'controllers/auth_service.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data()?['onboardingComplete'] == true;
  }

  Future<void> _handleEmailLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool hasError = false;

    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty) {
      _emailError = "Email is required";
      hasError = true;
    } else if (!emailRegex.hasMatch(email)) {
      _emailError = "Please enter a valid email";
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = "Password is required";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      final isDone = await _isOnboardingDone();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
          isDone
              ? const PhaseTransitionScreen()
              : const OnboardingScreen(),
        ),
            (_) => false,
      );
    } catch (e) {
      _snack(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithGoogle(isSignUp: false);

      final isDone = await _authService.isOnboardingDone();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
          isDone ? const PhaseTransitionScreen() : const OnboardingScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      _snack(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: appColors.heading,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/icons/sakhi icons/star 2.png',
                    height: 28,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Log in to bloom through your cycle phases.",
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 17,
                  color: appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 40),
              _label("Email address"),
              _inputField(
                _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),
              const SizedBox(height: 20),
              _label("Password"),
              _inputField(
                _passwordController,
                obscure: _obscurePassword,
                isPassword: true,
                errorText: _passwordError,
                onSuffixTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    "Forgot Password? ",
                    style: TextStyle(
                      color:
                      appColors.textPrimary.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _snack("Reset coming soon"),
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: appColors.button,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildPrimaryButton('Log in', _handleEmailLogin),
              const SizedBox(height: 30),
              _divider(),
              const SizedBox(height: 30),
              _googleButton(_handleGoogleLogin),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account? ',
                    style: TextStyle(
                      color:
                      appColors.textPrimary.withOpacity(0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: appColors.button,
                        fontWeight: FontWeight.bold,
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

  // ================= UI HELPERS =================

  Widget _label(String text) => Padding(
    padding:
    const EdgeInsets.only(bottom: 8.0, left: 4),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Satoshi',
        color: appColors.textPrimary,
      ),
    ),
  );

  Widget _inputField(
      TextEditingController controller, {
        bool obscure = false,
        bool isPassword = false,
        VoidCallback? onSuffixTap,
        TextInputType? keyboardType,
        String? errorText,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
        color: appColors.textPrimary,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: TextStyle(
          fontFamily: 'Satoshi',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: appColors.error,
        ),
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: onSuffixTap,
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color:
            appColors.textPrimary.withOpacity(0.4),
            size: 20,
          ),
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
          BorderSide(color: appColors.inputFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
          BorderSide(color: appColors.button),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
          BorderSide(color: appColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
          BorderSide(color: appColors.error, width: 2),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
      String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: appColors.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _googleButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: appColors.button.withOpacity(0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/sakhi icons/google.png',
              height: 22,
            ),
            const SizedBox(width: 12),
            Text(
              'Google',
              style: TextStyle(
                fontSize: 18,
                color: appColors.button,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Row(
    children: [
      Expanded(
        child: Divider(
          color:
          appColors.inputFieldBorder.withOpacity(0.5),
        ),
      ),
      Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          "Or Continue with",
          style: TextStyle(
            color:
            appColors.textPrimary.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ),
      Expanded(
        child: Divider(
          color:
          appColors.inputFieldBorder.withOpacity(0.5),
        ),
      ),
    ],
  );

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: appColors.button,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(15),
      ),
    );
  }
}
