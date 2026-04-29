import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';
import '../../core/services/password_validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({super.key, required this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasDigits = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _newPassword.addListener(_validate);
  }

  void _validate() {
    final result = PasswordValidators.checkPasswordStrength(
      _newPassword.text,
    );

    setState(() {
      _hasMinLength = result["min"]!;
      _hasUppercase = result["upper"]!;
      _hasDigits = result["digit"]!;
      _hasSpecial = result["special"]!;
    });
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (!(_hasMinLength && _hasUppercase && _hasDigits && _hasSpecial)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please meet all password requirements")),
      );
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      final cred = EmailAuthProvider.credential(
        email: widget.email,
        password: _currentPassword.text.trim(),
      );

      await user!.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPassword.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully!")),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Current password is incorrect")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,

      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            color: context.colors.heading,
          ),
        ),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.heading),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Update your password securely inside Sakhi.",
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  color: context.colors.textPrimary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              _field(
                controller: _currentPassword,
                hint: "Current Password",
              ),

              const SizedBox(height: 12),

              _field(
                controller: _newPassword,
                hint: "New Password",
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 6,
                runSpacing: 8,
                children: [
                  _chip("6+ chars", _hasMinLength),
                  _chip("1 uppercase", _hasUppercase),
                  _chip("1 digit", _hasDigits),
                  _chip("1 special", _hasSpecial),
                ],
              ),

              const SizedBox(height: 20),

              _field(
                controller: _confirmPassword,
                hint: "Confirm Password",
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.button,
                    foregroundColor: context.colors.buttonText,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Update Password",
                    style: TextStyle(fontFamily: 'Satoshi'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: _obscure,
      style: TextStyle(
        color: context.colors.textPrimary,
        fontFamily: 'Satoshi',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: context.colors.textPrimary.withOpacity(0.5),
        ),

        filled: true,
        fillColor: context.colors.topNav,

        // ✅ UPDATED RADIUS = 60
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide(color: context.colors.inputFieldBorder),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide(color: context.colors.inputFieldBorder),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide(color: context.colors.heading),
        ),

        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: context.colors.textPrimary,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  Widget _chip(String text, bool ok) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.inputFieldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check : Icons.close,
            size: 12,
            color: ok ? Colors.green : context.colors.error,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Satoshi',
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }
}