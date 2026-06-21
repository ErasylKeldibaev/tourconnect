class FormValidators {
  static final RegExp _emailPattern = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
  );

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Enter your email';
    if (!_emailPattern.hasMatch(trimmed)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Enter your password';
    if (password.length < 6) return 'Use at least 6 characters';
    return null;
  }

  static String? passwordConfirmation(String? value, String original) {
    if (value == null || value.isEmpty) return 'Repeat your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }
}
