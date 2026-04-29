class PasswordValidators {
  static Map<String, bool> checkPasswordStrength(String password) {
    return {
      "min": password.length >= 6,
      "upper": password.contains(RegExp(r'[A-Z]')),
      "digit": password.contains(RegExp(r'[0-9]')),
      "special": password.contains(RegExp(r'[!@#\$&*~]')),
    };
  }

  static bool isPasswordValid(String password) {
    final results = checkPasswordStrength(password);
    return !results.values.contains(false);
  }
}