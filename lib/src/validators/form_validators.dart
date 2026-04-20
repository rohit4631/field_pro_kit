class FormValidators {
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  static String? email(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    if (!emailRegex.hasMatch(value)) {
      return message ?? 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 8) {
      return message ?? 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? passwordStrength(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final strongPasswordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    if (!strongPasswordRegex.hasMatch(value)) {
      return message ??
          'Password must contain uppercase, lowercase, number and special character';
    }
    return null;
  }

  static String? phone(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return message ?? 'Please enter a valid phone number';
    }
    return null;
  }

  static String? url(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w-]*)*\/?\??([^#\n\r]*)?#?([^\n\r]*)$',
    );
    if (!urlRegex.hasMatch(value)) {
      return message ?? 'Please enter a valid URL';
    }
    return null;
  }

  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
