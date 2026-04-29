import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/lockedcolors.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String oobCode;

  const ResetPasswordScreen({super.key, required this.oobCode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // Validation States
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasDigits = false;
  bool _hasSpecialCharacters = false;

  @override
  void initState() {
    super.initState();
    // Listen for real-time validation updates
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 6;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasDigits = password.contains(RegExp(r'[0-9]'));
      _hasSpecialCharacters = password.contains(RegExp(r'[!@#\$&*~]'));
    });
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (!(_hasMinLength && _hasUppercase && _hasDigits && _hasSpecialCharacters)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please meet all password requirements")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.oobCode,
        newPassword: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated! Please log in.")),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred. The link might be expired.";
      if (e.code == 'expired-action-code') message = "This link has expired.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.oobCode.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("Invalid or expired reset link"),
        ),
      );
    }
    debugPrint("RESET SCREEN LOADED");

    if (widget.oobCode.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("Invalid reset link"),
        ),
      );
    }
    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        title: Text("Reset Password", style: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w500, color: LockedColors. heading)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Set a new password for your Sakhi account.",
                style: TextStyle(fontFamily: 'Satoshi', fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Password Input
              _inputField(
                _passwordController,
                hint: "New Password",
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                isPassword: true,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 12),

              // LIVE VALIDATOR CHIPS
              Wrap(
                spacing: 6,
                runSpacing: 8,
                children: [
                  _validationChip("6+ chars", _hasMinLength),
                  _validationChip("1 uppercase", _hasUppercase),
                  _validationChip("1 digit", _hasDigits),
                  _validationChip("1 special", _hasSpecialCharacters),
                ],
              ),

              const SizedBox(height: 24),

              // Confirm Password Input
              _inputField(
                _confirmPasswordController,
                hint: 'Confirm Password',
                icon: Icons.check_circle_outline,
                obscure: _obscurePassword,
                isPassword: true,
                validator: (value) {
                  if (value != _passwordController.text) return "Passwords do not match";
                  return null;
                },
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LockedColors.heading,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFFFB6C1).withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFFFFB6C1).withOpacity(0.4),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text(
                    "Update Password",
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
      TextEditingController controller, {
        required String hint,
        required IconData icon,
        bool obscure = false,
        bool isPassword = false,
        String? Function(String?)? validator,
        VoidCallback? onSuffixTap,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
          onPressed: onSuffixTap,
        )
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
      ),
    );
  }

  Widget _validationChip(String label, bool isValid) {
    final bool isEntryEmpty = _passwordController.text.isEmpty;
    final Color iconColor = isEntryEmpty ? Colors.grey.withOpacity(0.5) : (isValid ? Colors.green : Colors.red);
    final Color textColor = Colors.grey.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isValid ? Icons.check : Icons.close, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontFamily: 'Satoshi', color: textColor),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}