import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/settings/domain/settings_data_conf.dart';

part 'settings_data_state.g.dart';

@riverpod
class SettingsDataState extends _$SettingsDataState {
  @override
  SettingsDataConf build() {
    return SettingsDataConf(
      autoUpdate: _autoUpdate,
    );
  }

  // TODO Should talk to repo instead of directly?
  bool get _autoUpdate {
    final sharedPref = ref.read(sharedPrefProvider);
    final bool? value = sharedPref.getBool(DBKeys.AUTO_UPDATE_CHECK_CONF);

    // Validate
    if (value != null) {
      return value;
    }

    return Default.AUTO_UPDATE_CHECK_CONF;
  }

  set autoUpdate(bool value) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setBool(DBKeys.AUTO_UPDATE_CHECK_CONF, value);
    sharedPref.reload();

    state = state.copyWith(autoUpdate: value);
  }
}
