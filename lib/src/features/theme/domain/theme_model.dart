// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class VNDBLiteTheme {
  const VNDBLiteTheme({
    required this.themeName,
    required this.backgroundImgPath,
    required this.colorScheme,
  });

  final String themeName;
  final String backgroundImgPath;
  final ColorScheme colorScheme;

  @override
  bool operator ==(covariant VNDBLiteTheme other) {
    if (identical(this, other)) return true;

    return other.themeName == themeName &&
        other.backgroundImgPath == backgroundImgPath &&
        other.colorScheme == colorScheme;
  }

  @override
  int get hashCode => themeName.hashCode ^ backgroundImgPath.hashCode ^ colorScheme.hashCode;

  VNDBLiteTheme copyWith({
    String? themeName,
    String? backgroundImgPath,
    ColorScheme? colorScheme,
  }) {
    return VNDBLiteTheme(
      themeName: themeName ?? this.themeName,
      backgroundImgPath: backgroundImgPath ?? this.backgroundImgPath,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  @override
  String toString() =>
      'VNDBLiteTheme(themeName: $themeName, backgroundImgPath: $backgroundImgPath, colorScheme: $colorScheme)';
}
