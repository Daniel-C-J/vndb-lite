// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class SettingsGeneralConf {
  const SettingsGeneralConf({
    required this.showCoverCensor,
    required this.showChart,
    required this.maxPreviewItem,
    required this.maxItemPerRowPortrait,
    required this.maxItemPerRowLandscape,
    required this.homeSectionsArrangement,
    required this.collectionStatusTabArrangement,
  });

  final bool showCoverCensor;
  final bool showChart;
  final int maxPreviewItem;
  final int maxItemPerRowPortrait;
  final int maxItemPerRowLandscape;
  final List<String> homeSectionsArrangement;
  final List<String> collectionStatusTabArrangement;

  SettingsGeneralConf copyWith({
    bool? showCoverCensor,
    bool? showChart,
    int? maxPreviewItem,
    int? maxItemPerRowPortrait,
    int? maxItemPerRowLandscape,
    List<String>? homeSectionsArrangement,
    List<String>? collectionStatusTabArrangement,
  }) {
    return SettingsGeneralConf(
      showCoverCensor: showCoverCensor ?? this.showCoverCensor,
      showChart: showChart ?? this.showChart,
      maxPreviewItem: maxPreviewItem ?? this.maxPreviewItem,
      maxItemPerRowPortrait: maxItemPerRowPortrait ?? this.maxItemPerRowPortrait,
      maxItemPerRowLandscape: maxItemPerRowLandscape ?? this.maxItemPerRowLandscape,
      homeSectionsArrangement: homeSectionsArrangement ?? this.homeSectionsArrangement,
      collectionStatusTabArrangement: collectionStatusTabArrangement ?? this.collectionStatusTabArrangement,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'showCoverCensor': showCoverCensor,
      'showChart': showChart,
      'maxPreviewItem': maxPreviewItem,
      'maxItemPerRowPortrait': maxItemPerRowPortrait,
      'maxItemPerRowLandscape': maxItemPerRowLandscape,
      'homeSectionsArrangement': homeSectionsArrangement,
      'collectionStatusTabArrangement': collectionStatusTabArrangement,
    };
  }

  factory SettingsGeneralConf.fromMap(Map<String, dynamic> map) {
    return SettingsGeneralConf(
      showCoverCensor: map['showCoverCensor'] as bool,
      showChart: map['showChart'] as bool,
      maxPreviewItem: map['maxPreviewItem'] as int,
      maxItemPerRowPortrait: map['maxItemPerRowPortrait'] as int,
      maxItemPerRowLandscape: map['maxItemPerRowLandscape'] as int,
      homeSectionsArrangement: List<String>.from((map['homeSectionsArrangement'] as List<String>)),
      collectionStatusTabArrangement:
          List<String>.from((map['collectionStatusTabArrangement'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsGeneralConf.fromJson(String source) =>
      SettingsGeneralConf.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SettingsGeneralConf(showCoverCensor: $showCoverCensor, showChart: $showChart, maxPreviewItem: $maxPreviewItem, maxItemPerRowPortrait: $maxItemPerRowPortrait, maxItemPerRowLandscape: $maxItemPerRowLandscape, homeSectionsArrangement: $homeSectionsArrangement, collectionStatusTabArrangement: $collectionStatusTabArrangement)';
  }

  @override
  bool operator ==(covariant SettingsGeneralConf other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.showCoverCensor == showCoverCensor &&
        other.showChart == showChart &&
        other.maxPreviewItem == maxPreviewItem &&
        other.maxItemPerRowPortrait == maxItemPerRowPortrait &&
        other.maxItemPerRowLandscape == maxItemPerRowLandscape &&
        listEquals(other.homeSectionsArrangement, homeSectionsArrangement) &&
        listEquals(other.collectionStatusTabArrangement, collectionStatusTabArrangement);
  }

  @override
  int get hashCode {
    return showCoverCensor.hashCode ^
        showChart.hashCode ^
        maxPreviewItem.hashCode ^
        maxItemPerRowPortrait.hashCode ^
        maxItemPerRowLandscape.hashCode ^
        homeSectionsArrangement.hashCode ^
        collectionStatusTabArrangement.hashCode;
  }
}
