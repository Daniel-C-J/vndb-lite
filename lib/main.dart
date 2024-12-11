import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/app_init.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';

Future<void> main() async {
  // Ensuring widgets binding at startup.
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Summoning splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Awakening local database
  final sharedPreferences = await SharedPreferences.getInstance();

  // General app initialization and configurations
  await initializeApp();

  // Entry point
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}
