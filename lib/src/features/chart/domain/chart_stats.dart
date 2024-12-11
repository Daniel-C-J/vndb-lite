// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';

class ChartStats {
  const ChartStats({
    required this.title,
    required this.data,
    required this.color,
    required this.titlePosition,
  });

  final String title;
  final int data;
  final Color color;
  final double titlePosition;

  ChartStats copyWith({
    String? title,
    int? data,
    Color? color,
    double? titlePosition,
  }) {
    return ChartStats(
      title: title ?? this.title,
      data: data ?? this.data,
      color: color ?? this.color,
      titlePosition: titlePosition ?? this.titlePosition,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'data': data,
      'color': color.value,
      'titlePosition': titlePosition,
    };
  }

  factory ChartStats.fromMap(Map<String, dynamic> map) {
    return ChartStats(
      title: map['title'] as String,
      data: map['data'] as int,
      color: Color(map['color'] as int),
      titlePosition: map['titlePosition'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChartStats.fromJson(String source) =>
      ChartStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChartStats(title: $title, data: $data, color: $color, titlePosition: $titlePosition)';
  }

  @override
  bool operator ==(covariant ChartStats other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.data == data &&
        other.color == color &&
        other.titlePosition == titlePosition;
  }

  @override
  int get hashCode {
    return title.hashCode ^ data.hashCode ^ color.hashCode ^ titlePosition.hashCode;
  }
}
