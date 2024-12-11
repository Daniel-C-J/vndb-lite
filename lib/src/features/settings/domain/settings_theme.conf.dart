// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SettingsThemeConf {
  const SettingsThemeConf({
    required this.appTheme,
    required this.fontSize,
  });

  final String appTheme;
  final double fontSize;

  SettingsThemeConf copyWith({
    String? appTheme,
    double? fontSize,
  }) {
    return SettingsThemeConf(
      appTheme: appTheme ?? this.appTheme,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appTheme': appTheme,
      'fontSize': fontSize,
    };
  }

  factory SettingsThemeConf.fromMap(Map<String, dynamic> map) {
    return SettingsThemeConf(
      appTheme: map['appTheme'] as String,
      fontSize: map['fontSize'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsThemeConf.fromJson(String source) =>
      SettingsThemeConf.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SettingsThemeConf(appTheme: $appTheme, fontSize: $fontSize)';

  @override
  bool operator ==(covariant SettingsThemeConf other) {
    if (identical(this, other)) return true;

    return other.appTheme == appTheme && other.fontSize == fontSize;
  }

  @override
  int get hashCode => appTheme.hashCode ^ fontSize.hashCode;
}
