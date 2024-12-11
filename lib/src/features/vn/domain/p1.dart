// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:vndb_lite/src/features/vn/domain/others.dart';

class VnDataPhase {}

class VnDataPhase01 implements VnDataPhase {
  const VnDataPhase01({
    required this.id,
    required this.title,
    this.image,
    this.rating,
    this.votecount,
    this.olang,
    this.length,
    this.released,
    this.description,
  });

  final String id;
  final String title;
  final VnImage? image;
  final double? rating;
  final int? votecount;
  final String? olang;
  final int? length;
  final String? released;
  final String? description;

  VnDataPhase01 copyWith({
    String? id,
    String? title,
    VnImage? image,
    double? rating,
    int? votecount,
    String? olang,
    int? length,
    String? released,
    String? description,
  }) {
    return VnDataPhase01(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      votecount: votecount ?? this.votecount,
      olang: olang ?? this.olang,
      length: length ?? this.length,
      released: released ?? this.released,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image': image?.toMap(),
      'rating': rating,
      'votecount': votecount,
      'olang': olang,
      'length': length,
      'released': released,
      'description': description,
    };
  }

  factory VnDataPhase01.fromMap(Map<String, dynamic> data) {
    return VnDataPhase01(
      id: data['id'],
      title: data['title'],
      image: VnImage(
        url: (data['image']?['url']) ?? '',
        sexual: (data['image']?['sexual'] ?? 0).toDouble(),
        violence: (data['image']?['violence'] ?? 0).toDouble(),
      ),
      description: data['description'] ?? '--',
      length: data['length'] ?? 0,
      olang: data['olang'] ?? 'Unknown',
      rating: (data['rating'] ?? 0).toDouble(),
      released: data['released'] ?? 'Unknown',
      votecount: data['votecount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VnDataPhase01.fromJson(String source) =>
      VnDataPhase01.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VnDataPhase01(id: $id, title: $title, image: $image, rating: $rating, votecount: $votecount, olang: $olang, length: $length, released: $released, description: $description)';
  }

  @override
  bool operator ==(covariant VnDataPhase01 other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.image == image &&
        other.rating == rating &&
        other.votecount == votecount &&
        other.olang == olang &&
        other.length == length &&
        other.released == released &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        image.hashCode ^
        rating.hashCode ^
        votecount.hashCode ^
        olang.hashCode ^
        length.hashCode ^
        released.hashCode ^
        description.hashCode;
  }
}
