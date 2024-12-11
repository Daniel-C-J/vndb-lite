import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sort_.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';

class SortItemTile extends ConsumerWidget {
  const SortItemTile({
    super.key,
    required this.title,
    required this.sortCode,
    required this.onTap,
    this.customIconLeading,
    this.customTitleWidget,
  });

  final String title;
  final String sortCode;
  final IconData? customIconLeading;
  final void Function() onTap;
  final Widget? customTitleWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final SortData sort;

    if (App.isInSearchScreen) {
      sort = ref.watch(tempRemoteSortControllerProvider);
    } else {
      sort = ref.watch(localSortControllerProvider);
    }

    final isSelected = sort.sort == sortCode;
    final isReverse = sort.reverse == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsiveUI.own(0.045),
            vertical: responsiveUI.own(0.005),
          ),
          leading: Icon(
            customIconLeading ?? ((isSelected && isReverse) ? Icons.arrow_downward : Icons.arrow_upward),
            color: (isSelected)
                ? Color.alphaBlend(
                    Colors.black.withOpacity(0.2),
                    App.themeColor.secondary,
                  )
                : Colors.transparent,
            size: responsiveUI.own(0.05),
          ),
          title: Wrap(
            children: [
              ShadowText(title),
              customTitleWidget ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
