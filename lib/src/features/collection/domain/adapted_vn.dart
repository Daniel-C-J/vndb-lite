// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:collection/collection.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

class AdaptedVnData {
  const AdaptedVnData({
    required this.id,
    required this.status,
    required this.p1,
    required this.title,
    required this.started,
    required this.added,
    required this.length_minutes,
    required this.vote,
    required this.aliases,
    required this.devs,
    required this.devstatus,
    required this.languages,
    required this.minage,
    required this.tags,
    required this.platforms,
  });

  final String id;
  final String status;
  final VnDataPhase01 p1;

  // Sort
  final String title;
  final String started;
  final String added;
  final int length_minutes;
  // final int rating; // Covered in P1
  // final String released; // Covered in P1
  // final int votecount; // Covered in P1
  final int vote;

  // Filter
  final List<String> aliases;
  final List<String> devs;
  final int devstatus;
  final List<String> languages;
  // final String olang; // P1
  final List<int> minage;
  final List<String> tags;
  final List<String> platforms;

  AdaptedVnData copyWith({
    String? id,
    String? status,
    VnDataPhase01? p1,
    String? title,
    String? started,
    String? added,
    int? length_minutes,
    int? vote,
    List<String>? aliases,
    List<String>? devs,
    int? devstatus,
    List<String>? languages,
    List<int>? minage,
    List<String>? tags,
    List<String>? platforms,
  }) {
    return AdaptedVnData(
      id: id ?? this.id,
      status: status ?? this.status,
      p1: p1 ?? this.p1,
      title: title ?? this.title,
      started: started ?? this.started,
      added: added ?? this.added,
      length_minutes: length_minutes ?? this.length_minutes,
      vote: vote ?? this.vote,
      aliases: aliases ?? this.aliases,
      devs: devs ?? this.devs,
      devstatus: devstatus ?? this.devstatus,
      languages: languages ?? this.languages,
      minage: minage ?? this.minage,
      tags: tags ?? this.tags,
      platforms: platforms ?? this.platforms,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      ...p1.toMap(), // Do not change.
      'title': title,
      'started': started,
      'added': added,
      'length_minutes': length_minutes,
      'vote': vote,
      'aliases': aliases,
      'devs': devs,
      'devstatus': devstatus,
      'languages': languages,
      'minage': minage,
      'tags': tags,
      'platforms': platforms,
    };
  }

  @override
  String toString() {
    return 'AdaptedVnData(id: $id, status: $status, p1: $p1, title: $title, started: $started, added: $added, length_minutes: $length_minutes, vote: $vote, aliases: $aliases, devs: $devs, devstatus: $devstatus, languages: $languages, minage: $minage, tags: $tags, platforms: $platforms)';
  }

  @override
  bool operator ==(covariant AdaptedVnData other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.status == status &&
        other.p1 == p1 &&
        other.title == title &&
        other.started == started &&
        other.added == added &&
        other.length_minutes == length_minutes &&
        other.vote == vote &&
        listEquals(other.aliases, aliases) &&
        listEquals(other.devs, devs) &&
        other.devstatus == devstatus &&
        listEquals(other.languages, languages) &&
        listEquals(other.minage, minage) &&
        listEquals(other.tags, tags) &&
        listEquals(other.platforms, platforms);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        p1.hashCode ^
        title.hashCode ^
        started.hashCode ^
        added.hashCode ^
        length_minutes.hashCode ^
        vote.hashCode ^
        aliases.hashCode ^
        devs.hashCode ^
        devstatus.hashCode ^
        languages.hashCode ^
        minage.hashCode ^
        tags.hashCode ^
        platforms.hashCode;
  }
}
