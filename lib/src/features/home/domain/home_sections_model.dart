// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';

class HomePreviewSection {
  const HomePreviewSection({
    required this.title,
    required this.id,
    this.labelCode,
    this.filter,
    required this.maxPreviewItem,
  });

  final String title;
  final String id;
  final String? labelCode;
  final FilterData? filter;
  final int maxPreviewItem;

  HomePreviewSection copyWith({
    String? title,
    String? id,
    String? labelCode,
    FilterData? filter,
    int? maxPreviewItem,
  }) {
    return HomePreviewSection(
      title: title ?? this.title,
      id: id ?? this.id,
      labelCode: labelCode ?? this.labelCode,
      filter: filter ?? this.filter,
      maxPreviewItem: maxPreviewItem ?? this.maxPreviewItem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'id': id,
      'labelCode': labelCode,
      'filter': filter?.toMap(),
      'maxPreviewItem': maxPreviewItem,
    };
  }

  factory HomePreviewSection.fromMap(Map<String, dynamic> map) {
    return HomePreviewSection(
      title: map['title'] as String,
      id: map['id'] as String,
      labelCode: map['labelCode'] != null ? map['labelCode'] as String : null,
      filter: map['filter'] != null ? FilterData.fromMap(map['filter'] as Map<String, dynamic>) : null,
      maxPreviewItem: map['maxPreviewItem'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomePreviewSection.fromJson(String source) =>
      HomePreviewSection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HomePreviewSection(title: $title, id: $id, labelCode: $labelCode, filter: $filter, maxPreviewItem: $maxPreviewItem)';
  }

  @override
  bool operator ==(covariant HomePreviewSection other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.id == id &&
        other.labelCode == labelCode &&
        other.filter == filter &&
        other.maxPreviewItem == maxPreviewItem;
  }

  @override
  int get hashCode {
    return title.hashCode ^ id.hashCode ^ labelCode.hashCode ^ filter.hashCode ^ maxPreviewItem.hashCode;
  }
}
