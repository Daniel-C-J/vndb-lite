// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

class VnDataPhase02 implements VnDataPhase {
  const VnDataPhase02({
    required this.id,
    this.developers,
    this.devstatus,
    this.length_minutes,
    this.aliases,
    this.minage,
    this.tags,
    this.screenshots,
    this.languages,
    this.mtl,
    this.platforms,
  });

  final String id;
  final List<String>? developers;
  final int? devstatus;
  final int? length_minutes;
  final List<String>? aliases;
  final List<int>? minage;
  final List<VnTag>? tags;
  final List<VnImage>? screenshots;
  final List<String>? languages;
  final List<String>? mtl;
  final List<String>? platforms;

  VnDataPhase02 copyWith({
    String? id,
    List<String>? developers,
    int? devstatus,
    int? length_minutes,
    List<String>? aliases,
    List<int>? minage,
    List<VnTag>? tags,
    List<VnImage>? screenshots,
    List<String>? languages,
    List<String>? mtl,
    List<String>? platforms,
  }) {
    return VnDataPhase02(
      id: id ?? this.id,
      developers: developers ?? this.developers,
      devstatus: devstatus ?? this.devstatus,
      length_minutes: length_minutes ?? this.length_minutes,
      aliases: aliases ?? this.aliases,
      minage: minage ?? this.minage,
      tags: tags ?? this.tags,
      screenshots: screenshots ?? this.screenshots,
      languages: languages ?? this.languages,
      mtl: mtl ?? this.mtl,
      platforms: platforms ?? this.platforms,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'developers': developers,
      'devstatus': devstatus,
      'length_minutes': length_minutes,
      'aliases': aliases,
      'minage': minage,
      'tags': tags?.map((x) => x.toMap()).toList(),
      'screenshots': screenshots?.map((x) => x.toMap()).toList(),
      'languages': languages,
      'mtl': mtl,
      'platforms': platforms,
    };
  }

  factory VnDataPhase02.fromMap(Map<String, dynamic> data) {
    return VnDataPhase02(
      id: data['id'],
      //
      aliases: (data['aliases'] != null) ? [for (String val in data['aliases']) val] : ['--'],
      //
      developers: (data['developers'] != null)
          ? [
              for (var val in data['developers'])
                // If data is raw
                if (val is Map)
                  (val['name'] ?? "")

                // If data is already formatted
                else if (val is String?)
                  (val ?? "")
            ]
          : [],
      mtl: (data['mtl'] != null) ? [for (String val in data['mtl']) val] : [],
      //
      minage: (data['minage'] != null) ? [for (int val in data['minage']) val] : [],
      //
      devstatus: data['devstatus'] ?? -1,
      //
      languages: (data['languages'] != null) ? [for (String val in data['languages']) val] : [],
      //
      length_minutes: data['length_minutes'] ?? 0,
      //
      platforms: (data['platforms'] != null) ? [for (String val in data['platforms']) val] : [],
      //
      screenshots: (data['screenshots'] != null)
          ? (!data['screenshots'].toString().contains('t.vndb.org'))
              // If data is raw
              ? [
                  for (Map<String, dynamic> screenshot in data['screenshots'])
                    VnImage(
                      url: _getScreenshotUrl(screenshot),
                      sexual: screenshot['sexual'].toDouble(),
                      violence: screenshot['violence'].toDouble(),
                    )
                ]
              // If data is already formatted
              : [for (Map<String, dynamic> screenshot in data['screenshots']) VnImage.fromMap(screenshot)]
          : [],
      //
      tags: (data['tags'] != null)
          ? [
              for (Map<String, dynamic> tag in data['tags'])
                VnTag(
                  id: tag['id'],
                  name: tag['name'] ?? "???",
                  rating: (tag['rating'] ?? 0).toDouble(),
                  spoiler: (tag['spoiler'] ?? 0).toDouble(),
                )
            ]
          : [],
    );
  }

  static String _getScreenshotUrl(Map<String, dynamic> screenshot) {
    final String screenshotId = screenshot['id'];
    final String pathCode = screenshotId.substring(screenshotId.length - 2);
    final String screenshotCode = screenshotId.substring(2, screenshotId.length);
    return 'https://t.vndb.org/sf/$pathCode/$screenshotCode.jpg';
  }

  static Map<String, dynamic> processAdditionalP2(List secondData) {
    final List<int> minage = [];
    List<String> langCodes = [];
    List langMTL = [];
    List ages = [];

    for (Map<String, dynamic> segment in secondData) {
      if (segment['languages']?[0] != null) {
        langMTL.add(segment['languages'][0]);
      }

      if (segment['minage'] != null && segment['minage'] is int) {
        minage.add(segment['minage']);
      }
    }

    if (langMTL.isNotEmpty && minage.isNotEmpty) {
      // Extract only those language code with mtl value of true
      langMTL = langMTL.where((mtl) {
        if (mtl['mtl'] == null) return false;
        return mtl['mtl'] == true;
      }).toList();

      // Only interestes in the language code
      langCodes = [
        for (Map<String, dynamic> entry in langMTL)
          if (entry['lang'] != null && entry['lang'] is String) entry['lang']
      ];

      // Remove duplication
      langCodes = langCodes.toSet().toList();

      ages = [minage.reduce(min), minage.reduce(max)];
      ages = ages.toSet().toList();
    }

    return {'mtl': langCodes, 'minage': ages};
  }

  String toJson() => json.encode(toMap());

  factory VnDataPhase02.fromJson(String source) =>
      VnDataPhase02.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VnDataPhase02(id: $id, developers: $developers, devstatus: $devstatus, length_minutes: $length_minutes, aliases: $aliases, minage: $minage, tags: $tags, screenshots: $screenshots, languages: $languages, mtl: $mtl, platforms: $platforms)';
  }

  @override
  bool operator ==(covariant VnDataPhase02 other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        listEquals(other.developers, developers) &&
        other.devstatus == devstatus &&
        other.length_minutes == length_minutes &&
        listEquals(other.aliases, aliases) &&
        listEquals(other.minage, minage) &&
        listEquals(other.tags, tags) &&
        listEquals(other.screenshots, screenshots) &&
        listEquals(other.languages, languages) &&
        listEquals(other.mtl, mtl) &&
        listEquals(other.platforms, platforms);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        developers.hashCode ^
        devstatus.hashCode ^
        length_minutes.hashCode ^
        aliases.hashCode ^
        minage.hashCode ^
        tags.hashCode ^
        screenshots.hashCode ^
        languages.hashCode ^
        mtl.hashCode ^
        platforms.hashCode;
  }
}
