import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/others/data/others_option_data.dart';
import 'package:vndb_lite/src/features/others/domain/others_option.dart';

class OthersScreen extends ConsumerWidget {
  const OthersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (OthersScreenOption otherOption in OTHERS_SCREEN_OPTIONS.values)

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          ListTile(
            onTap: () {
              if (otherOption.routeName == OthersOptionCode.bug.name) {
                launchUrlString("https://github.com/Daniel-C-J/vndb-lite/issues/new");
                return;
              }

              context.pushNamed(otherOption.routeName);
            },
            leading: Icon(
              otherOption.leading,
              color: App.themeColor.secondary,
              size: responsiveUI.own(0.06),
              shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
            ),
            title: ShadowText(otherOption.title),
            subtitle: (otherOption.subtitle != null)
                ? ShadowText(
                    otherOption.subtitle!,
                    fontSize: responsiveUI.own(0.03),
                    color: App.themeColor.tertiary.withAlpha(180),
                  )
                : null,
            tileColor: App.themeColor.primary.withAlpha(50),
            dense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsiveUI.own(0.045),
              vertical: responsiveUI.own(0.005),
            ),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
