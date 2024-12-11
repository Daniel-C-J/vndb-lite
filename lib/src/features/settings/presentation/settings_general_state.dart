import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/home/data/preview_sections_data.dart';
import 'package:vndb_lite/src/features/settings/domain/settings_general_conf.dart';

part 'settings_general_state.g.dart';

@riverpod
class SettingsGeneralState extends _$SettingsGeneralState {
  @override
  SettingsGeneralConf build() {
    return SettingsGeneralConf(
      showCoverCensor: _showCoverCensor,
      showChart: _showChart,
      maxPreviewItem: _maxPreviewItem,
      maxItemPerRowPortrait: _maxItemPerRowPortrait,
      maxItemPerRowLandscape: _maxItemPerRowLandscape,
      homeSectionsArrangement: _homeSectionsArrangement,
      collectionStatusTabArrangement: _collectionStatusTabArrangement,
    );
  }

  bool get _showCoverCensor {
    final sharedPref = ref.read(sharedPrefProvider);
    final bool? coverCensor = sharedPref.getBool(DBKeys.COVER_CENSOR_CONF);

    // Validate
    if (coverCensor != null) {
      return coverCensor;
    }

    return Default.COVER_CENSOR_CONF;
  }

  bool get _showChart {
    final sharedPref = ref.read(sharedPrefProvider);
    final bool? showChart = sharedPref.getBool(DBKeys.SHOW_CHART_CONF);

    // Validate
    if (showChart != null) {
      return showChart;
    }

    return Default.SHOW_CHART_CONF;
  }

  int get _maxPreviewItem {
    final sharedPref = ref.read(sharedPrefProvider);
    final int? maxPreview = sharedPref.getInt(DBKeys.MAX_PREVIEW_ITEMS_CONF);

    // Validate
    if (maxPreview != null && maxPreview >= 1) {
      return maxPreview;
    }

    return Default.MAX_PREVIEW_ITEMS_CONF;
  }

  int get _maxItemPerRowPortrait {
    final sharedPref = ref.read(sharedPrefProvider);
    final int? maxItem = sharedPref.getInt(DBKeys.MAX_ITEMS_PER_ROW_PORTRAIT_CONF);

    // Validate
    if (maxItem != null && maxItem >= 2) {
      return maxItem;
    }

    return Default.MAX_ITEM_PER_ROW_PORTRAIT_CONF;
  }

  int get _maxItemPerRowLandscape {
    final sharedPref = ref.read(sharedPrefProvider);
    final int? maxItem = sharedPref.getInt(DBKeys.MAX_ITEMS_PER_ROW_LANDSCAPE_CONF);

    // Validate
    if (maxItem != null && maxItem >= 4) {
      return maxItem;
    }

    return Default.MAX_ITEM_PER_ROW_LANDSCAPE_CONF;
  }

  List<String> get _homeSectionsArrangement {
    final sharedPref = ref.read(sharedPrefProvider);
    final List<String>? arrangement = sharedPref.getStringList(DBKeys.HOME_ARRANGEMENT);

    // Validate
    if (arrangement != null &&
        arrangement.isNotEmpty &&
        arrangement.length >= HomeSectionsCode.values.length) {
      return arrangement;
    }

    return Default.HOME_SECTION_ARRANGEMENT;
  }

  List<String> get _collectionStatusTabArrangement {
    final sharedPref = ref.read(sharedPrefProvider);
    final List<String>? arrangement = sharedPref.getStringList(DBKeys.COLLECTION_ARRANGEMENT);

    // Validate
    if (arrangement != null &&
        arrangement.isNotEmpty &&
        arrangement.length >= CollectionStatusCode.values.length) {
      return arrangement;
    }

    return Default.COLLECTION_STATUS_TAB_ARRANGEMENT;
  }

  set showChart(bool value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setBool(DBKeys.SHOW_CHART_CONF, value);
    sharedPref.reload();

    state = state.copyWith(showChart: value);
  }

  set showCoverCensor(bool value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setBool(DBKeys.COVER_CENSOR_CONF, value);
    sharedPref.reload();

    state = state.copyWith(showCoverCensor: value);
  }

  set maxPreviewItem(int value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setInt(DBKeys.MAX_PREVIEW_ITEMS_CONF, value);
    sharedPref.reload();

    state = state.copyWith(maxPreviewItem: value);
  }

  set maxItemPerRowPortrait(int value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setInt(DBKeys.MAX_ITEMS_PER_ROW_PORTRAIT_CONF, value);
    sharedPref.reload();

    state = state.copyWith(maxItemPerRowPortrait: value);
  }

  set maxItemPerRowLandscape(int value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setInt(DBKeys.MAX_ITEMS_PER_ROW_LANDSCAPE_CONF, value);
    sharedPref.reload();

    state = state.copyWith(maxItemPerRowLandscape: value);
  }

  set homeSectionsArrangement(List<String> value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setStringList(DBKeys.HOME_ARRANGEMENT, value);
    sharedPref.reload();

    state = state.copyWith(homeSectionsArrangement: value);
  }

  set collectionStatusTabArrangement(List<String> value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setStringList(DBKeys.COLLECTION_ARRANGEMENT, value);
    sharedPref.reload();

    state = state.copyWith(collectionStatusTabArrangement: value);
  }
}
