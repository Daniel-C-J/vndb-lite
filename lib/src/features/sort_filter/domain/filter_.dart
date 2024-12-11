// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_comparison
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/developers.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';

class FilterData {
  FilterData({
    this.search = "",
    this.andOr = "and",
    this.lang = const [],
    this.devstatus = const [],
    this.olang = const [],
    this.platform = const [],
    this.tag = const [],
    this.dev = const [],
    this.minage = 0, // Include both explicit and safe content
  });

  final String search;
  final String andOr;
  final List<String> lang;
  final List<int> devstatus;
  final List<String> olang;
  final List<String> platform;
  final List<VnTag> tag;
  final List<Developer> dev;
  final int? minage; // This is special for collection/local filter only.

  List<dynamic> toList() {
    return [
      andOr,
      //
      ["search", "=", search],
      //
      if (lang != null && lang.isNotEmpty) ...[
        for (String val in lang) ["lang", "=", val]
      ],
      //
      if (devstatus != null && devstatus.isNotEmpty) ...[
        for (int val in devstatus) ["devstatus", "=", val]
      ],
      //
      if (olang != null && olang.isNotEmpty) ...[
        for (String val in olang) ["olang", "=", val]
      ],
      //
      if (platform != null && platform.isNotEmpty) ...[
        for (String val in platform) ["platform", "=", val]
      ],
      //
      if (tag != null && tag.isNotEmpty) ...[
        for (VnTag val in tag) ["tag", "=", val.id]
      ],
      //
      if (dev != null && dev.isNotEmpty) ...[
        for (Developer val in dev)
          [
            "developer",
            "=",
            ["id", "=", val.id],
          ]
      ],
      //
    ];
  }

  FilterData copyWith({
    String? search,
    String? andOr,
    List<String>? lang,
    List<int>? devstatus,
    List<String>? olang,
    List<String>? platform,
    List<VnTag>? tag,
    List<Developer>? dev,
    int? minage,
  }) {
    return FilterData(
      search: search ?? this.search,
      andOr: andOr ?? this.andOr,
      lang: lang ?? this.lang,
      devstatus: devstatus ?? this.devstatus,
      olang: olang ?? this.olang,
      platform: platform ?? this.platform,
      tag: tag ?? this.tag,
      dev: dev ?? this.dev,
      minage: minage ?? this.minage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'search': search,
      'andOr': andOr,
      'lang': lang,
      'devstatus': devstatus,
      'olang': olang,
      'platform': platform,
      'tag': tag.map((x) => x.toMap()).toList(),
      'dev': dev.map((x) => x.toMap()).toList(),
      'minage': minage,
    };
  }

  factory FilterData.fromMap(Map<String, dynamic> map) {
    return FilterData(
      search: map['search'] as String,
      andOr: map['andOr'] as String,
      lang: (map['lang'] != null) ? [for (String val in map['lang']) val] : [],
      devstatus: (map['devstatus'] != null) ? [for (int val in map['devstatus']) val] : [],
      olang: (map['olang'] != null) ? [for (String val in map['olang']) val] : [],
      platform: (map['platform'] != null) ? [for (String val in map['platform']) val] : [],
      tag: List<VnTag>.from(
        map['tag'].map<VnTag>(
          (x) => VnTag.fromMap(x as Map<String, dynamic>),
        ),
      ),
      dev: List<Developer>.from(
        map['dev'].map<Developer>(
          (x) => Developer.fromMap(x as Map<String, dynamic>),
        ),
      ),
      minage: map['minage'] != null ? map['minage'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterData.fromJson(String source) =>
      FilterData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FilterData(search: $search, andOr: $andOr, lang: $lang, devstatus: $devstatus, olang: $olang, platform: $platform, tag: $tag, dev: $dev, minage: $minage)';
  }

  @override
  bool operator ==(covariant FilterData other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.search == search &&
        other.andOr == andOr &&
        listEquals(other.lang, lang) &&
        listEquals(other.devstatus, devstatus) &&
        listEquals(other.olang, olang) &&
        listEquals(other.platform, platform) &&
        listEquals(other.tag, tag) &&
        listEquals(other.dev, dev) &&
        other.minage == minage;
  }

  @override
  int get hashCode {
    return search.hashCode ^
        andOr.hashCode ^
        lang.hashCode ^
        devstatus.hashCode ^
        olang.hashCode ^
        platform.hashCode ^
        tag.hashCode ^
        dev.hashCode ^
        minage.hashCode;
  }
}
