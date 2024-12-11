import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/platform_code_data.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';

class GeneratePlatformOptions extends ConsumerWidget {
  const GeneratePlatformOptions({
    super.key,
    required this.func,
    required this.platformCode,
    required this.platformName,
  });

  final void Function() func;
  final String platformCode;
  final String platformName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imagePath = "assets/images/os_image/$platformCode.png";
    late final List selectedPlatforms;

    if (App.isInSearchScreen) {
      selectedPlatforms = ref.watch(tempRemoteFilterControllerProvider).platform;
    } else {
      selectedPlatforms = ref.watch(localFilterControllerProvider).platform;
    }

    final bool isSelected = selectedPlatforms.contains(platformCode);

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
          Padding(
            padding: EdgeInsets.only(
              right: responsiveUI.own(0.015),
              bottom: responsiveUI.own(0.005),
              top: responsiveUI.own(0.005),
            ),
            child: Image.asset(
              imagePath,
              color: (isPlatformIconPlain(platformCode)) ? App.themeColor.tertiary : null,
              height: responsiveUI.own(0.05),
              width: responsiveUI.own(0.05),
            ),
          ),
          ShadowText(platformName),
        ],
      ),
    );
  }
}
