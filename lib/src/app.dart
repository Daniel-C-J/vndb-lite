import 'package:go_router/go_router.dart';
import 'package:vndb_lite/src/constants/app_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme_state.dart';
import 'package:vndb_lite/src/features/theme/data/theme_data.dart';
import 'package:vndb_lite/src/routing/app_router.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

class App extends ConsumerWidget {
  const App({super.key});

// This is useful when facing with deep nested vndetail stack.
  static String currentRootRoute = "/";

  static String get currentRoute {
    final routeName = GoRouter.maybeOf(NavigationService.currentContext)?.state?.name;
    if (routeName != null) return routeName;

    // Default
    return AppRoute.home.name;
  }

  static String get currentFullRoute {
    final fullRoute = GoRouter.maybeOf(NavigationService.currentContext)?.state?.matchedLocation;
    if (fullRoute != null) return fullRoute;

    // Default
    return "/";
  }

  static bool get isInMainTab =>
      isInHomeScreen || isInSearchScreen || isInCollectionScreen || isInOthersScreen;
  static bool get isInHomeScreen => currentRoute.contains(AppRoute.home.name);
  static bool get isInSearchScreen => currentRoute.contains(AppRoute.search.name);
  static bool get isInCollectionScreen => currentRoute.contains(AppRoute.collection.name);
  static bool get isInOthersScreen => currentRoute.contains(AppRoute.others.name);
  static bool get isInVnDetailScreen => currentRoute.contains(AppRoute.vnDetail.name);

  static late ColorScheme themeColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeCode = ref.watch(settingsThemeStateProvider).appTheme;

    // Assigning a global theme reader.
    themeColor = THEME_DATA[themeCode]!.colorScheme;

    // Assigning an emergency global state reader.
    ref_ = ref;

    // Force removal of splash screen.
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'App',
      routerConfig: goRouter,
      title: AppInfo.TITLE,
      onGenerateTitle: (_) => AppInfo.TITLE,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: themeColor,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: themeColor.secondary.withOpacity(0.85),
        ),
      ).copyWith(
        textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
      ),
    );
  }
}
