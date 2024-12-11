// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class VnImage {
  const VnImage({
    this.url,
    this.sexual,
    this.violence,
  });

  final String? url;
  final double? sexual;
  final double? violence;

  VnImage copyWith({
    String? url,
    double? sexual,
    double? violence,
  }) {
    return VnImage(
      url: url ?? this.url,
      sexual: sexual ?? this.sexual,
      violence: violence ?? this.violence,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'sexual': sexual,
      'violence': violence,
    };
  }

  factory VnImage.fromMap(Map<String, dynamic> map) {
    return VnImage(
      url: map['url'] != null ? map['url'] as String : null,
      sexual: map['sexual'] != null ? map['sexual'] as double : null,
      violence: map['violence'] != null ? map['violence'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VnImage.fromJson(String source) => VnImage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VnImage(url: $url, sexual: $sexual, violence: $violence)';

  @override
  bool operator ==(covariant VnImage other) {
    if (identical(this, other)) return true;

    return other.url == url && other.sexual == sexual && other.violence == violence;
  }

  @override
  int get hashCode => url.hashCode ^ sexual.hashCode ^ violence.hashCode;
}

class VnTag {
  const VnTag({
    this.name,
    this.id,
    this.rating,
    this.spoiler,
  });

  final String? name;
  final String? id;
  final double? rating;
  final double? spoiler;

  VnTag copyWith({
    String? name,
    String? id,
    double? rating,
    double? spoiler,
  }) {
    return VnTag(
      name: name ?? this.name,
      id: id ?? this.id,
      rating: rating ?? this.rating,
      spoiler: spoiler ?? this.spoiler,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'rating': rating,
      'spoiler': spoiler,
    };
  }

  factory VnTag.fromMap(Map<String, dynamic> map) {
    return VnTag(
      name: map['name'] != null ? map['name'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      spoiler: map['spoiler'] != null ? map['spoiler'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VnTag.fromJson(String source) => VnTag.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VnTag(name: $name, id: $id, rating: $rating, spoiler: $spoiler)';
  }

  @override
  bool operator ==(covariant VnTag other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id && other.rating == rating && other.spoiler == spoiler;
  }

  @override
  int get hashCode {
    return name.hashCode ^ id.hashCode ^ rating.hashCode ^ spoiler.hashCode;
  }
}

class VnRelation {
  const VnRelation({
    this.relation_official,
    this.relation,
    this.id,
  });

  final bool? relation_official;
  final String? relation;
  final String? id;

  VnRelation copyWith({
    bool? relation_official,
    String? relation,
    String? id,
  }) {
    return VnRelation(
      relation_official: relation_official ?? this.relation_official,
      relation: relation ?? this.relation,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'relation_official': relation_official,
      'relation': relation,
      'id': id,
    };
  }

  factory VnRelation.fromMap(Map<String, dynamic> map) {
    return VnRelation(
      relation_official: map['relation_official'] != null ? map['relation_official'] as bool : null,
      relation: map['relation'] != null ? map['relation'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VnRelation.fromJson(String source) =>
      VnRelation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VnRelation(relation_official: $relation_official, relation: $relation, id: $id)';

  @override
  bool operator ==(covariant VnRelation other) {
    if (identical(this, other)) return true;

    return other.relation_official == relation_official && other.relation == relation && other.id == id;
  }

  @override
  int get hashCode => relation_official.hashCode ^ relation.hashCode ^ id.hashCode;
}
