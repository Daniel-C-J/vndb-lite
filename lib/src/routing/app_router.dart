import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/features/_base/presentation/maintab_layout.dart';
import 'package:vndb_lite/src/features/about/presentation/about_screen.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_screen.dart';
import 'package:vndb_lite/src/features/home/presentation/home_screen.dart';
import 'package:vndb_lite/src/features/others/presentation/others_screen.dart';
import 'package:vndb_lite/src/features/search/presentation/search_screen.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_screen.dart';
import 'package:vndb_lite/src/features/sync/presentation/auth_screen.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/vn_detail_screen.dart';
import 'package:vndb_lite/src/routing/not_found_screen.dart';
import 'package:vndb_lite/src/routing/transition_route.dart';

part 'app_router.g.dart';

enum AppRoute {
  home,
  search,
  collection,
  others,
  vnDetail,
  auth,
  settings,
  about,
  unknown,
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    navigatorKey: NavigationService.navigatorKey,
    redirect: (context, state) {
      // Placeholder
      return;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainTabLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: AppRoute.home.name),
            routes: [
              GoRoute(
                path: '/',
                name: AppRoute.home.name,
                builder: (context, state) {
                  // TODO use pageBuilder with NoTranstitionPage() instead?
                  return const HomeScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: AppRoute.search.name),
            routes: [
              GoRoute(
                path: '/search',
                name: AppRoute.search.name,
                builder: (context, state) {
                  return const SearchScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: AppRoute.collection.name),
            routes: [
              GoRoute(
                path: '/collection',
                name: AppRoute.collection.name,
                builder: (context, state) {
                  return const CollectionScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: AppRoute.others.name),
            routes: [
              GoRoute(
                path: '/others',
                name: AppRoute.others.name,
                builder: (context, state) {
                  return const OthersScreen();
                },
              ),
            ],
          ),
        ],
      ),
      TransitionGoRoute(
        path: '/:parent/details/:vnId',
        name: AppRoute.vnDetail.name,
        pageBuilder: (context, state) {
          final p1 = state.extra as VnDataPhase01;
          return VnDetailScreen(p1: p1);
        },
      ),
      TransitionGoRoute(
        path: '/auth',
        name: AppRoute.auth.name,
        pageBuilder: (context, state) {
          return const AuthenticationScreen();
        },
      ),
      TransitionGoRoute(
        path: '/settings',
        name: AppRoute.settings.name,
        pageBuilder: (context, state) {
          return const SettingsScreen();
        },
      ),
      TransitionGoRoute(
        path: '/about',
        name: AppRoute.about.name,
        pageBuilder: (context, state) {
          return const AboutScreen();
        },
      ),
    ],
    errorBuilder: (context, state) {
      // Placeholder
      return const NotFoundScreen();
    },
  );
}
