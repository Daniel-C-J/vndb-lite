import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/others/languages.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/util/language_code_formatting.dart';

class GenerateFlagOptions extends ConsumerWidget {
  const GenerateFlagOptions({
    super.key,
    required this.func,
    required this.languageCode,
    required this.identifier,
  });

  final String identifier;
  final String languageCode;
  final void Function() func;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final List selectedLanguages;

    if (App.isInSearchScreen) {
      if (identifier == 'availLang') {
        selectedLanguages = ref.watch(tempRemoteFilterControllerProvider).lang;
      } else {
        selectedLanguages = ref.watch(tempRemoteFilterControllerProvider).olang;
      }
      //
    } else {
      //
      if (identifier == 'availLang') {
        selectedLanguages = ref.watch(localFilterControllerProvider).lang;
      } else {
        selectedLanguages = ref.watch(localFilterControllerProvider).olang;
      }
    }

    final isSelected = selectedLanguages.contains(languageCode);

    return Container(
      margin: EdgeInsets.only(
        top: responsiveUI.own(0.025),
        right: responsiveUI.own(0.02),
      ),
      child: CustomLabel(
        useBorder: true,
        borderRadius: 10,
        isSelected: isSelected,
        onTap: () {
          func();
        },
        children: [
          Flag.fromString(
            formatLanguageCode(languageCode: languageCode),
            height: responsiveUI.own(0.038),
            width: responsiveUI.own(0.055),
            fit: BoxFit.fill,
            borderRadius: 3,
          ),
          ShadowText(
            '  ${LanguageLocal.getDisplayLanguage(languageCode)!['name']}',
          ),
        ],
      ),
    );
  }
}
