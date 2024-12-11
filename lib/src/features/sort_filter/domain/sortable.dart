// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Sortable {
  const Sortable({
    required this.title,
    this.icon,
  });

  final String title;
  final IconData? icon;

  Sortable copyWith({
    String? title,
    IconData? icon,
  }) {
    return Sortable(
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'icon': icon?.codePoint,
    };
  }

  factory Sortable.fromMap(Map<String, dynamic> map) {
    return Sortable(
      title: map['title'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Sortable.fromJson(String source) => Sortable.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Sortable(title: $title, icon: $icon)';

  @override
  bool operator ==(covariant Sortable other) {
    if (identical(this, other)) return true;

    return other.title == title && other.icon == icon;
  }

  @override
  int get hashCode => title.hashCode ^ icon.hashCode;
}
