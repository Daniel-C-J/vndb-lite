// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/home/data/preview_sections_data.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sort_.dart';
import 'package:vndb_lite/src/features/theme/data/theme_data.dart';

class Default {
  static const String BASE_URL = 'https://api.vndb.org';
  static const bool AUTO_UPDATE_CHECK_CONF = true;
  static final String THEME_CONF = ThemeCode.angel.name;
  static const bool SHOW_CHART_CONF = true;
  static const bool COVER_CENSOR_CONF = true;
  static const double FONT_SIZE_CONF = 0.035;
  static const double CUSTOM_FONT_SIZE_CONF = 0.0;
  static const int MAX_PREVIEW_ITEMS_CONF = 20;
  static const int MAX_ITEM_PER_ROW_PORTRAIT_CONF = 2;
  static const int MAX_ITEM_PER_ROW_LANDSCAPE_CONF = 4;
  static final List<String> HOME_SECTION_ARRANGEMENT = HOME_SCREEN_SECTIONS.keys.toList();
  static final List<String> COLLECTION_STATUS_TAB_ARRANGEMENT = COLLECTION_STATUS_DATA.keys.toList();
  static const int MAX_VN_SEARCH_RESULT = 24;
  static final FilterData LOCAL_FILTER_CONF = FilterData(
    search: "",
    minage: 0,
    lang: [],
    devstatus: [],
    olang: [],
    platform: [],
  );
  static final SortData LOCAL_SORT_CONF = SortData(
    sort: SortableCode.title.name,
    reverse: false,
  );
  static final FilterData REMOTE_FILTER_CONF = FilterData(
    search: "",
    andOr: "and",
    lang: [],
    devstatus: [],
    olang: [],
    platform: [],
    dev: [],
    tag: [],
  );
  static final SortData REMOTE_SORT_CONF = SortData(
    sort: SortableCode.searchrank.name,
    reverse: true,
  );
}
