// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SettingsDataConf {
  SettingsDataConf({
    required this.autoUpdate,
  });

  final bool autoUpdate;

  SettingsDataConf copyWith({
    bool? autoUpdate,
  }) {
    return SettingsDataConf(
      autoUpdate: autoUpdate ?? this.autoUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'autoUpdate': autoUpdate,
    };
  }

  factory SettingsDataConf.fromMap(Map<String, dynamic> map) {
    return SettingsDataConf(
      autoUpdate: map['autoUpdate'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsDataConf.fromJson(String source) =>
      SettingsDataConf.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SettingsDataConf(autoUpdate: $autoUpdate)';

  @override
  bool operator ==(covariant SettingsDataConf other) {
    if (identical(this, other)) return true;

    return other.autoUpdate == autoUpdate;
  }

  @override
  int get hashCode => autoUpdate.hashCode;
}
