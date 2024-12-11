import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vndb_lite/src/common_widgets/custom_button.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_background.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/constants/app_info.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme_state.dart';
import 'package:vndb_lite/src/features/theme/data/theme_data.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const List<String> oreNoPassion = ["Mobile Development", "Cybersecurity", "Literature"];

  // TODO model class...?
  // Hope someone's contacting me for either a job offer or a donation :-)
  static final Map<String, dynamic> contacts = {
    "email": {
      "urlDomain": "mailto:",
      "id": [
        // "daniel_cj@mail2tor.com", // Alternate
        "dani3lcj@proton.me",
      ],
      "icon": Icon(
        Icons.email,
        size: responsiveUI.own(0.05),
        color: App.themeColor.tertiary,
      )
    },
    "github": {
      "urlDomain": "https://github.com/",
      "id": [
        "Daniel-C-J",
      ],
      "icon": Image.asset(
        'assets/images/contact/github.png',
        fit: BoxFit.cover,
        width: responsiveUI.own(0.05),
        color: App.themeColor.tertiary,
      ),
    },
    "ko-fi": {
      "urlDomain": "https://ko-fi.com/",
      "id": [
        "danielcj",
      ],
      "icon": Image.asset(
        'assets/images/contact/ko-fi.webp',
        fit: BoxFit.cover,
        width: responsiveUI.own(0.05),
      ),
    }
  };

  String get _passions {
    String passion = oreNoPassion.getRange(0, oreNoPassion.length - 1).join(", ");
    return "$passion, and ${oreNoPassion.last}";
  }

  String _getUrlDomain(contactType, id) {
    return "${contacts[contactType]["urlDomain"]}$id".trim();
  }

  Widget _getContactWidget({required String urlLink, required List<Widget> contents}) {
    return Padding(
      padding: EdgeInsets.all(responsiveUI.own(0.02)),
      child: Tooltip(
        message: urlLink,
        child: CustomLabel(
          useBorder: false,
          padding: EdgeInsets.symmetric(
            horizontal: responsiveUI.own(0.03),
            vertical: responsiveUI.own(0.02),
          ),
          onTap: () {
            final url = urlLink.trim();
            launchUrlString(url);
          },
          children: contents,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeCode = ref.watch(settingsThemeStateProvider).appTheme;
    final theme = THEME_DATA[themeCode]!;

    return Stack(
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        GenericBackground(
          imagePath: theme.backgroundImgPath,
          useGradientOverlay: true,
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        Scaffold(
          backgroundColor: App.themeColor.primary.withOpacity(0.3),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  right: measureSafeAreaOf(responsiveUI.own(0.05)),
                  left: measureSafeAreaOf(responsiveUI.own(0.05)),
                  bottom: responsiveUI.own(0.2),
                ),
                child: Column(
                  children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// App icon
                    Tooltip(
                      message: 'Christiane Friedrich from Majikoi Series ♥',
                      margin: EdgeInsets.only(top: responsiveUI.own(0.12)),
                      preferBelow: true,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: responsiveUI.own(0.3),
                          bottom: responsiveUI.own(0.02),
                        ),
                        width: responsiveUI.own(0.25),
                        height: responsiveUI.own(0.25),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: App.themeColor.secondary.withOpacity(0.4),
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Image.asset(
                          'assets/images/icon/app_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
                    ShadowText(
                      AppInfo.TITLE,
                      fontSize: responsiveUI.own(0.05),
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                    ),
                    ShadowText(
                      'ver ${AppInfo.CURRENT_VERSION}',
                      align: TextAlign.center,
                    ),
                    ShadowText(
                      AppInfo.DESCRIPTION,
                      align: TextAlign.center,
                    ),
                    Divider(
                      indent: responsiveUI.own(0.1),
                      endIndent: responsiveUI.own(0.1),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: responsiveUI.own(0.02)),
                      child: ShadowText(
                        'About',
                        fontSize: responsiveUI.catgTitle,
                      ),
                    ),
                    ShadowText(
                      "Hi there, Daniel CJ here. I am the developer of this app, ${AppInfo.TITLE}. "
                      "I have passions in $_passions. "
                      "\n\n"
                      "This is the first Flutter app I've ever developed. "
                      "It took me about 8 ~ 9 weeks to finish the first version of this app. "
                      "At first it was just a sudden idea popped in my head out of nowhere, but ended up "
                      "as what you are using now. I am certainly grateful for this wonderful experience "
                      "of developing a mobile app using Flutter, and looking to develop more!"
                      "\n\n"
                      "Also, I am currently open for mobile developing-related jobs (remotely global)! "
                      "If you're interested, and would like to create similar apps as this one with even "
                      "more cool features, don't hesitate to contact me!",
                      align: TextAlign.center,
                    ),
                    Divider(
                      indent: responsiveUI.own(0.1),
                      endIndent: responsiveUI.own(0.1),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: responsiveUI.own(0.02),
                        bottom: responsiveUI.own(0.02),
                      ),
                      child: ShadowText(
                        'Contact',
                        fontSize: responsiveUI.catgTitle,
                      ),
                    ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Contact
                    ShadowText(
                      'Project? Job offer? ... Or generous enough to donate me :)? '
                      'Here are ways to reach me:',
                      align: TextAlign.center,
                    ),
                    SizedBox(height: responsiveUI.own(0.02)),
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        //
                        for (String contactType in contacts.keys)
                          //
                          for (String url in contacts[contactType]["id"])
                            _getContactWidget(
                              urlLink: _getUrlDomain(contactType, url),
                              contents: [
                                contacts[contactType]["icon"],
                                ShadowText('  $url'),
                              ],
                            )
                      ],
                    )
                  ],
                ),
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Back button
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveUI.own(0.05),
                  vertical: responsiveUI.own(0.11),
                ),
                child: CustomButton(
                  content: ShadowText('Back'),
                  icon: Icons.arrow_back_ios,
                  iconSize: responsiveUI.own(0.04),
                  onTap: Navigator.of(context).pop,
                  size: EdgeInsets.symmetric(
                    vertical: responsiveUI.own(0.02),
                    horizontal: responsiveUI.own(0.035),
                  ),
                  gradientColor: [
                    App.themeColor.primary.withOpacity(0.85),
                    App.themeColor.secondary.withOpacity(0.65),
                  ],
                ),
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            ],
          ),
        ),
      ],
    );
  }
}
