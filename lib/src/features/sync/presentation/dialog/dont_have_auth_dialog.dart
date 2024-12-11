import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/util/widget_zoom/widget_zoom.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class DontHaveAuthTokenDialog extends ConsumerWidget {
  const DontHaveAuthTokenDialog({super.key});

  static const String registerUrl = "https://vndb.org/u/register";
  static const String guidePartialPath = "assets/images/tutorial/tutorial";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// X button
        Container(
          alignment: Alignment.topCenter,
          child: InkWell(
            borderRadius: BorderRadius.circular(36),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Transform.scale(
              scale: 0.8,
              child: Icon(
                Icons.remove_circle_outline,
                color: App.themeColor.tertiary,
              ),
            ),
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Text informational
        ShadowText(
          "Unfortunately, this app does not have a feature of in-app login nor VNDB account creation yet. "
          "If you wish for your VNs to be stored in the cloud (VNDB.org), then: \n\n"
          ""
          "1) If you don't have an account yet, click the create a new account button.",
          align: TextAlign.center,
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Create account button
        Padding(
          padding: EdgeInsets.symmetric(vertical: responsiveUI.own(0.03)),
          child: CustomDialogButton(
            text: "Create account",
            textColor: App.themeColor.primary,
            textShadow: const [
              Shadow(color: Color.fromARGB(120, 0, 0, 0), blurRadius: 1),
            ],
            color: App.themeColor.tertiary,
            padding: EdgeInsets.symmetric(
              horizontal: responsiveUI.own(0.035),
              vertical: responsiveUI.own(0.02),
            ),
            onPressed: () => launchUrlString(registerUrl),
          ),
        ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// next step text
        ShadowText(
          "2) If you already have an account, please follow the instructions below to get your "
          "authentication token after you've login in the website.",
          align: TextAlign.center,
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tutorial image
        Container(
          padding: EdgeInsets.symmetric(vertical: responsiveUI.own(0.03)),
          height: responsiveUI.own(0.4),
          width: responsiveUI.own(1),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Swiper(
              loop: false,
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  size: 8,
                  activeColor: App.themeColor.secondary,
                  color: const Color.fromARGB(140, 160, 160, 160),
                ),
              ),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: WidgetZoom(
                    heroAnimationTag: 'guide',
                    zoomWidget: Image.asset(
                      '$guidePartialPath${index + 1}.png',
                    ),
                  ),
                );
              },
            ),
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Bottom text
        ShadowText(
          "Thank you for your understanding ^^",
          align: TextAlign.center,
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
