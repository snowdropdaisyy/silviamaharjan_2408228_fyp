import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/lockedcolors.dart';
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

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc.data()?['onboardingComplete'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Permission or Read Error: $e");
      return false;
    }
  }

  Future<void> _handleEmailLogin() async {
    setState(() { _emailError = null; _passwordError = null; });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      await credential.user?.getIdToken(true);

      if (!credential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        _snack("Please verify your email first!");
        setState(() => _isLoading = false);
        return;
      }

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

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LockedColors.background,
      // Prevents the background from squishing when keyboard appears
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView( // Wrap with ScrollView to prevent RenderFlex overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 110),

                Center(
                  child: Column(
                    children: [
                      Text(
                        "Welcome back",
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: LockedColors.heading,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        "to Sakhi",
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: LockedColors.heading,
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

                _inputField(
                  _emailController,
                  hint: "Email address",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),

                const SizedBox(height: 25),

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
                    onTap: () async {
                      final email = _emailController.text.trim();

                      if (email.isEmpty) {
                        _snack("Please enter your email address above first.");
                        return;
                      }

                      try {
                        setState(() => _isLoading = true);

                        final userExists =
                        await _authService.checkUserExists(email);

                        if (!userExists) {
                          _snack(
                            "No account found with this email.",
                          );
                          return;
                        }

                        await _authService.sendPasswordReset(email);

                        _snack(
                          "Reset link sent! Check your email.",
                        );

                      } catch (e) {
                        _snack("Error: ${e.toString()}");
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: LockedColors.button,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                _primaryButton('Log in', _handleEmailLogin),
                const SizedBox(height: 15),
                _divider(),
                const SizedBox(height: 15),
                _googleButton(() async {
                  setState(() => _isLoading = true);
                  try {
                    final user = await _authService.signInWithGoogle(isSignUp: false);

                    if (user != null) {
                      // Check onboarding status before navigating
                      final isDone = await _isOnboardingDone();

                      if (!mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => isDone ? const PhaseTransitionScreen() : const OnboardingScreen()
                        ),
                            (_) => false,
                      );
                    }
                  } catch (e) {
                    _snack(e.toString().replaceAll("Exception: ", ""));
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                }),

                // Extra space to ensure content doesn't hit the bottom bar
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      // STICKY FOOTER
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don’t have an account? ',
              style: TextStyle(
                fontFamily: 'Satoshi',
                color: LockedColors.textPrimary.withOpacity(0.7),
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
                  color: LockedColors.button,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
    // Triggers the pink heading color when user starts typing
    final bool isActive = controller.text.isNotEmpty;

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      // Triggers rebuild to update icon color in real-time
      onChanged: (value) => setState(() {}),
      style: TextStyle(
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
        color: LockedColors.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          // Using textPrimary with opacity instead of generic grey
          color: LockedColors.textPrimary.withOpacity(0.4),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),

        // Optional: Adds a very subtle fill to the field
        filled: true,
        fillColor: LockedColors.background,

        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: Icon(
            icon,
            // Switches from a soft tint to your main Pink (heading) when active
            color: isActive
                ? LockedColors.heading
                : LockedColors.textPrimary.withOpacity(0.3),
            size: 22,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        errorText: errorText,

        suffixIcon: isPassword
            ? Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: onSuffixTap,
            child: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: LockedColors.textPrimary.withOpacity(0.4),
              size: 20,
            ),
          ),
        )
            : null,

        // --- BORDERS USING LOCKEDCOLORS ---
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: LockedColors.inputFieldBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: LockedColors.button, // Your pink button color
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: LockedColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: LockedColors.error,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: LockedColors.button,
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
            fontWeight: FontWeight.w700,
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
      height: 50,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: LockedColors.button.withOpacity(0.5)),
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
                color: LockedColors.heading,
                fontWeight: FontWeight.w700,
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
      Expanded(child: Divider(color: LockedColors.inputFieldBorder.withOpacity(0.5))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          "Or Continue With",
          style: TextStyle(color: LockedColors.textPrimary.withOpacity(0.8), fontSize: 11),
        ),
      ),
      Expanded(child: Divider(color: LockedColors.inputFieldBorder.withOpacity(0.5))),
    ],
  );

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Satoshi', color: LockedColors.heading, fontWeight: FontWeight.w500),
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