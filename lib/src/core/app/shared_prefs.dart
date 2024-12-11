import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
SharedPreferences sharedPref(Ref ref) {
  // allows for overriding with an awaited future in main.dart before application startup
  throw UnimplementedError();
}
