import 'package:flutter/material.dart';
import 'package:silviamaharjan_2408228_fyp/src/features/user_management/verify_email_screen.dart';
import '../../core/theme/theme.dart';
import '../cycles_tab/phase_transition_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import '../../core/services/auth_service.dart';

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
  String? _confirmPasswordError;

  bool _isAccepted = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  bool _hasUppercase = false;
  bool _hasDigits = false;
  bool _hasSpecialCharacters = false;
  bool _hasMinLength = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final pass = _passwordController.text;
    setState(() {
      _hasUppercase = pass.contains(RegExp(r'[A-Z]'));
      _hasDigits = pass.contains(RegExp(r'[0-9]'));
      _hasSpecialCharacters = pass.contains(RegExp(r'[!@#\$&*~]'));
      _hasMinLength = pass.length >= 6;
    });
  }

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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'Your cycle story',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: appColors.heading,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'starts here',
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: appColors.heading,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Image.asset(
                      'assets/icons/sakhi icons/star.png',
                      height: 50,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),


              // EMAIL INPUT
              _inputField(
                  _emailController,
                  hint: 'Email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError
              ),

              const SizedBox(height: 25),

              // PASSWORD INPUT
              _inputField(
                _passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                isPassword: true,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 12),

              // LIVE VALIDATOR CHIPS (Transparent Background)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _validationChip("6+ chars", _hasMinLength),
                  _validationChip("1 uppercase", _hasUppercase),
                  _validationChip("1 digit", _hasDigits),
                  _validationChip("1 special", _hasSpecialCharacters),
                ],
              ),

              const SizedBox(height: 16),

              // CONFIRM PASSWORD INPUT
              _inputField(
                _confirmPasswordController,
                hint: 'Confirm Password',
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                isPassword: true,
                errorText: _confirmPasswordError,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 20),

              // TERMS
              Row(
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      value: _isAccepted,
                      onChanged: (v) => setState(() => _isAccepted = v ?? false),
                      activeColor: appColors.button,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'I accept the Terms and Conditions',
                      style: TextStyle(fontSize: 13, fontFamily: 'Satoshi', color: appColors.textPrimary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ACTIONS
              _primaryButton('Sign up', _handleEmailSignup),
              const SizedBox(height: 15),
              _divider(),
              const SizedBox(height: 15),
              _googleButton(_handleGoogleSignup),

              // This Spacer pushes the "Login" row to the very bottom
              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                          fontFamily: 'Satoshi',
                          color: appColors.textPrimary.withOpacity(0.7)
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen())
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontFamily: 'Satoshi',
                            color: appColors.button,
                            fontWeight: FontWeight.bold
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

  Widget _validationChip(String label, bool isValid) {
    final bool isEntryEmpty = _passwordController.text.isEmpty;

    // ICON COLOR: Grey if empty, Red/Green if typing
    final Color iconColor = isEntryEmpty
        ? Colors.grey.withOpacity(0.5)
        : (isValid ? Colors.green : Colors.red);

    // TEXT COLOR: Stays grey as requested
    final Color textColor = Colors.grey.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            // Show cross by default, check only if valid
            isValid ? Icons.check : Icons.close,
            size: 12,
            color: iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Satoshi',
              color: textColor,
              fontWeight: isValid ? FontWeight.w400 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

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
    // Check if the field is active or has text to trigger the pink color
    final bool isActive = controller.text.isNotEmpty;

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: (value) => setState(() {}), // Triggers rebuild to update icon color live
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
        // Increased padding inside the prefix icon for a breathable look
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: Icon(
            icon,
            // Colors heading pink when typing, otherwise grey
            color: isActive ? appColors.heading : Colors.grey.withOpacity(0.5),
            size: 22,
          ),
        ),
        // Extra horizontal and vertical padding for that "Sakhi" aesthetic
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

  // ================= UI HELPERS =================

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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
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
              style: TextStyle(fontSize: 16, color: appColors.button, fontWeight: FontWeight.w500),
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

  // ================= LOGIC =================

  Future<void> _handleEmailSignup() async {
    // Reset errors
    setState(() {
      _emailError = null;
      _confirmPasswordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Basic Validation
    if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => _emailError = 'Invalid email address');
      return;
    }

    // Check Live Validator requirements
    if (!_hasMinLength || !_hasUppercase || !_hasDigits || !_hasSpecialCharacters) {
      _snack("Please fulfill all password requirements");
      return;
    }

    if (password != confirmPassword) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      return;
    }

    if (!_isAccepted) {
      _snack("Please accept the Terms and Conditions");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUpWithEmail(email: email, password: password);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(email: email),
          ),
        );
      }
    } catch (e) {
      if (mounted) _snack(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignup() async {
    if (!_isAccepted) {
      _snack("Please accept the Terms and Conditions");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Use your AuthService to handle Google Sign-In
      final user = await _authService.signInWithGoogle(isSignUp: true);

      if (user != null && mounted) {
        // Check if user has already completed the onboarding profile
        bool isDone = await _authService.isOnboardingDone();

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => isDone ? const PhaseTransitionScreen() : const OnboardingScreen(),
            ),
                (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) _snack(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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