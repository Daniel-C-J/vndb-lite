// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class MenuSections {
  const MenuSections({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  MenuSections copyWith({
    String? title,
    IconData? icon,
  }) {
    return MenuSections(
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'icon': icon.codePoint,
    };
  }

  factory MenuSections.fromMap(Map<String, dynamic> map) {
    return MenuSections(
      title: map['title'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuSections.fromJson(String source) =>
      MenuSections.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MenuSections(title: $title, icon: $icon)';

  @override
  bool operator ==(covariant MenuSections other) {
    if (identical(this, other)) return true;

    return other.title == title && other.icon == icon;
  }

  @override
  int get hashCode => title.hashCode ^ icon.hashCode;
}
