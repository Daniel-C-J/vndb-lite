import 'package:flutter/services.dart';

/// This file contains some helper functions used for string validation.

abstract class StringValidator {
  bool isValid(String value);
}

class AuthTokenValidator implements StringValidator {
  const AuthTokenValidator();

  @override
  bool isValid(String value) {
    // If value is alphanumeric with hyphen (-) and length input is between 28 ~ 38 characters.
    if (RegExp(r"^[a-zA-Z0-9-]{28,38}\b$").hasMatch(value)) {
      return true;
    }

    return false;
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({required this.editingValidator});
  final StringValidator editingValidator;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = editingValidator.isValid(oldValue.text);
    final bool newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}
