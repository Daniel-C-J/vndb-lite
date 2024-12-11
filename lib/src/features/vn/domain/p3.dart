// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

class VnDataPhase03 implements VnDataPhase {
  const VnDataPhase03({
    required this.id,
    this.extlinks,
    this.relations,
  });

  final String id;
  final List<String>? extlinks;
  final List<VnRelation>? relations;

  VnDataPhase03 copyWith({
    String? id,
    List<String>? extlinks,
    List<VnRelation>? relations,
  }) {
    return VnDataPhase03(
      id: id ?? this.id,
      extlinks: extlinks ?? this.extlinks,
      relations: relations ?? this.relations,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'extlinks': extlinks,
      'relations': relations?.map((x) => x.toMap()).toList(),
    };
  }

  factory VnDataPhase03.fromMap(Map<String, dynamic> data) {
    final List<String> tempExtlinks = [];
    final List<VnRelation> relations = [];

    for (var extlink in data['extlinks']) {
      // If data is raw
      if (extlink is Map) {
        tempExtlinks.add(extlink['url']);
        continue;
      }

      // If data already processed
      tempExtlinks.add(extlink);
    }

    for (Map<String, dynamic> relation in (data['relations'] ?? [])) {
      relations.add(VnRelation(
        id: relation['id'],
        relation_official: relation['relation_official'] ?? false,
        relation: relation['relation'],
      ));
    }

    return VnDataPhase03(
      id: data['id'],
      extlinks: tempExtlinks,
      relations: relations,
    );
  }

  factory VnDataPhase03.fromJson(String source) =>
      VnDataPhase03.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'VnDataPhase03(id: $id, extlinks: $extlinks, relations: $relations)';

  @override
  bool operator ==(covariant VnDataPhase03 other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id && listEquals(other.extlinks, extlinks) && listEquals(other.relations, relations);
  }

  @override
  int get hashCode => id.hashCode ^ extlinks.hashCode ^ relations.hashCode;
}
