// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CollectionStatus {
  const CollectionStatus({
    required this.status,
    required this.id,
    required this.color,
    required this.imagePath,
  });

  final String status;
  final int id;
  final Color color;
  final String? imagePath;

  CollectionStatus copyWith({
    String? status,
    int? id,
    Color? color,
    String? imagePath,
  }) {
    return CollectionStatus(
      status: status ?? this.status,
      id: id ?? this.id,
      color: color ?? this.color,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'CollectionStatus(status: $status, id: $id, color: $color, imagePath: $imagePath)';
  }

  @override
  bool operator ==(covariant CollectionStatus other) {
    if (identical(this, other)) return true;

    return other.status == status && other.id == id && other.color == color && other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return status.hashCode ^ id.hashCode ^ color.hashCode ^ imagePath.hashCode;
  }
}
