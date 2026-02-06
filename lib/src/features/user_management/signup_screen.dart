import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../cycles_tab/phase_transition_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'controllers/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isAccepted = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // HEADER
              Text(
                'Your cycle story\nstarts here',
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: appColors.heading,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Join now and explore more.',
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 17,
                  color: appColors.textPrimary,
                ),
              ),

              const SizedBox(height: 32),

              // EMAIL
              _label('Email address'),
              _inputField(
                _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),

              const SizedBox(height: 20),

              // PASSWORD
              _label("Password"),
              _inputField(
                _passwordController,
                obscure: _obscurePassword,
                isPassword: true,
                errorText: _passwordError,
                onSuffixTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD
              _label('Confirm Password'),
              _inputField(
                _confirmPasswordController,
                obscure: _obscurePassword,
                isPassword: true,
                errorText: _confirmPasswordError,
                onSuffixTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 16),

              // TERMS
              Row(
                children: [
                  Checkbox(
                    value: _isAccepted,
                    onChanged: (v) =>
                        setState(() => _isAccepted = v ?? false),
                    activeColor: appColors.button,
                  ),
                  Expanded(
                    child: Text(
                      'I accept the Terms and Conditions',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                        color: appColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              _primaryButton('Sign up', _handleEmailSignup),

              const SizedBox(height: 25),

              _divider(),

              const SizedBox(height: 25),

              _googleButton(_handleGoogleSignup),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                        color: appColors.textPrimary.withOpacity(0.7)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Text(
                      'Login',
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
    padding: const EdgeInsets.only(bottom: 8.0, left: 4),
    child: Text(
        text,
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
            color: appColors.textPrimary)),
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
        errorStyle: const TextStyle(
          fontFamily: 'Satoshi',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
        suffixIcon: isPassword
            ? GestureDetector(
          onTap: onSuffixTap,
          child: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: appColors.textPrimary.withOpacity(0.4),
            size: 20,
          ),
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: appColors.inputFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: appColors.button),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: appColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: appColors.error, width: 2),
        ),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: _isLoading
            ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
          text,
          style:
          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _googleButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, height: 60,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(side: BorderSide(color: appColors.button.withOpacity(0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/sakhi icons/google.png', height: 22),
            const SizedBox(width: 12),
            Text(
                'Google',
                style: TextStyle(
                    fontSize: 18,
                    color: appColors.button,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Row(
    children: [
      Expanded(child: Divider(color: appColors.inputFieldBorder.withOpacity(0.5))),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("Or Continue with",
              style: TextStyle(
                  color: appColors.textPrimary.withOpacity(0.6),
                  fontSize: 12)
          )
      ),
      Expanded(child: Divider(color: appColors.inputFieldBorder.withOpacity(0.5))),
    ],
  );

  // ================= LOGIC =================

  Future<void> _handleEmailSignup() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    bool hasInputError = false;

    // 1. Email Check
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      hasInputError = true;
    } else if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
      hasInputError = true;
    }

    // 2. Password Check
    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      hasInputError = true;
    } else if (password.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      hasInputError = true;
    }

    // 3. Confirm Password Check
    if (confirmPassword.isEmpty) {
      setState(() => _confirmPasswordError = 'Please confirm your password');
      hasInputError = true;
    } else if (password != confirmPassword) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      hasInputError = true;
    }

    if (hasInputError) return;

    // 4. Terms Check (After inputs are valid)
    if (!_isAccepted) {
      _snack("Please accept the Terms and Conditions");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        _snack(e.toString().replaceAll("Exception: ", ""));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignup() async {
    // 1. Check Terms
    if (!_isAccepted) {
      _snack("Please accept the Terms and Conditions");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Pass isSignUp: true to trigger the "Existence Check" logic
      final user = await _authService.signInWithGoogle(isSignUp: true);

      if (user == null) {
        setState(() => _isLoading = false);
        return; // User cancelled the popup
      }

      // 3. Check onboarding status
      bool isDone = await _authService.isOnboardingDone();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => isDone
                ? const PhaseTransitionScreen()
                : const OnboardingScreen(),
          ),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        // This will now catch the "Account already exists" exception from our service
        _snack(e.toString().replaceAll("Exception: ", ""));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            color: Colors.white,
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