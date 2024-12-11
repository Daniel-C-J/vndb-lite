// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Developer {
  Developer({
    required this.id,
    required this.name,
  });
  final String id;
  final String name;

  Developer copyWith({
    String? id,
    String? name,
  }) {
    return Developer(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Developer.fromMap(Map<String, dynamic> map) {
    return Developer(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Developer.fromJson(String source) => Developer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Developers(id: $id, name: $name)';

  @override
  bool operator ==(covariant Developer other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
