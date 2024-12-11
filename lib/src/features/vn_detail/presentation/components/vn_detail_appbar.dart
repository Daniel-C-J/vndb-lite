import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/routing/app_router.dart';

class VnDetailAppbar extends ConsumerWidget {
  const VnDetailAppbar({super.key, required this.vnId});

  final String vnId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vnUrl = Uri.parse('https://vndb.org/$vnId');

    return SliverAppBar(
      snap: true,
      floating: true,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      toolbarHeight: responsiveUI.own(0.22),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: App.themeColor.tertiary,
        shadows: const [Shadow(color: Colors.black)],
      ),
      actions: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Back button
        Container(
          margin: EdgeInsets.only(left: responsiveUI.own(0.045)),
          child: Tooltip(
            message: 'Back',
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              // IconButton doesn't support longPress, so GestureDetector is used to provide the callback.
              onLongPress: () {
                final fullRoute = App.currentFullRoute;

                if (fullRoute.contains(AppRoute.search.name)) {
                  context.goNamed(AppRoute.search.name);
                  //
                } else if (fullRoute.contains(AppRoute.collection.name)) {
                  context.goNamed(AppRoute.collection.name);
                  //
                } else if (fullRoute.contains(AppRoute.home.name)) {
                  context.goNamed(AppRoute.home.name);
                  //
                } else {
                  context.goNamed(AppRoute.home.name);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: App.themeColor.primary.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: IconButton(
                  padding: EdgeInsets.all(responsiveUI.own(0.034)),
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: responsiveUI.standardIcon,
                    color: App.themeColor.tertiary,
                  ),
                ),
              ),
            ),
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        const Spacer(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Share button
        Container(
          margin: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.035)),
          decoration: BoxDecoration(
            color: App.themeColor.primary.withOpacity(0.75),
            borderRadius: BorderRadius.circular(60),
          ),
          child: IconButton(
            tooltip: 'Share',
            padding: EdgeInsets.all(responsiveUI.own(0.034)),
            onPressed: () => Share.share('$vnUrl'),
            icon: Icon(
              Icons.share,
              size: responsiveUI.standardIcon,
              color: App.themeColor.tertiary,
            ),
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Go to site button
        Container(
          margin: EdgeInsets.only(right: responsiveUI.own(0.035)),
          decoration: BoxDecoration(
            color: App.themeColor.primary.withOpacity(0.75),
            borderRadius: BorderRadius.circular(60),
          ),
          child: IconButton(
            tooltip: 'Go to site',
            padding: EdgeInsets.all(responsiveUI.own(0.034)),
            onPressed: () => launchUrl(vnUrl),
            icon: Icon(
              Icons.travel_explore,
              size: responsiveUI.standardIcon,
              color: App.themeColor.tertiary,
            ),
          ),
        )
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
