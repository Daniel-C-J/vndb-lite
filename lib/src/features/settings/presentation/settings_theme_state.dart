import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/settings/domain/settings_theme.conf.dart';
import 'package:vndb_lite/src/features/theme/data/theme_data.dart';

part 'settings_theme_state.g.dart';

@riverpod
class SettingsThemeState extends _$SettingsThemeState {
  @override
  SettingsThemeConf build() {
    return SettingsThemeConf(
      appTheme: _appTheme,
      fontSize: _fontSize,
    );
  }

  // TODO Should talk to repo instead of directly?
  String get _appTheme {
    final sharedPref = ref.read(sharedPrefProvider);
    final String? theme = sharedPref.getString(DBKeys.THEME_CONF);

    // Validate
    if (theme != null && THEME_DATA.keys.contains(theme)) {
      return theme;
    }

    return Default.THEME_CONF;
  }

  double get _fontSize {
    final sharedPref = ref.read(sharedPrefProvider);
    final double? fontSize = sharedPref.getDouble(DBKeys.CUSTOM_FONT_SIZE_CONF);

    // Validate
    if (fontSize != null) {
      return fontSize;
    }

    return Default.CUSTOM_FONT_SIZE_CONF;
  }

  set appTheme(String value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setString(DBKeys.THEME_CONF, value);
    sharedPref.reload();

    state = state.copyWith(appTheme: value);
  }

  set fontSize(double value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setDouble(DBKeys.CUSTOM_FONT_SIZE_CONF, value);
    sharedPref.reload();

    state = state.copyWith(fontSize: value);
  }
}
