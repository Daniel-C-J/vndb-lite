import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

// ignore: non_constant_identifier_names
GoRoute TransitionGoRoute({
  required String path,
  String? name,
  required Widget Function(BuildContext, GoRouterState) pageBuilder,
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      maintainState: false,
      transitionDuration: const Duration(milliseconds: 450),
      child: pageBuilder(context, state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurveTween(curve: Curves.ease).animate(animation),
          filterQuality: FilterQuality.none,
          child: FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
  );
}
