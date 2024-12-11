import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/refresh_button.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/home/data/preview_sections_data.dart';
import 'package:vndb_lite/src/features/settings/presentation/components/settings_item_per_row.dart';
import 'package:vndb_lite/src/features/settings/presentation/components/settings_listview_scroll_items.dart';
import 'package:vndb_lite/src/features/settings/presentation/dialog/settings_dialog.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';

class SettingsGeneral extends ConsumerStatefulWidget {
  const SettingsGeneral({super.key});

  @override
  ConsumerState<SettingsGeneral> createState() => _SettingsGeneralState();
}

class _SettingsGeneralState extends ConsumerState<SettingsGeneral> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();

    _offsetAnimation = _animationController
        .drive(CurveTween(curve: Curves.easeInOut))
        .drive(Tween<Offset>(begin: const Offset(0, -0.5), end: const Offset(0, 0)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _refreshApp() async {
    await AppBarRefreshButton.tap();
    if (mounted) setState(() {});
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _censorCoverSwitch() async {
    final showCoverCensor = ref.read(settingsGeneralStateProvider).showCoverCensor;
    ref.read(settingsGeneralStateProvider.notifier).showCoverCensor = !showCoverCensor;

    await _refreshApp();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _getDragAndDropItem({required String key, required String title}) {
    // Need to be given an exact length so it can be measured easily,
    // as the parent widget's constraints.
    return SizedBox(
      key: ValueKey<String>(key),
      height: responsiveUI.own(0.13),
      child: ListTile(
        dense: true,
        tileColor: App.themeColor.secondary.withOpacity(0.7),
        contentPadding: EdgeInsets.symmetric(
          horizontal: responsiveUI.own(0.045),
        ),
        trailing: Icon(
          Icons.format_list_bulleted,
          size: responsiveUI.own(0.05),
          color: App.themeColor.tertiary.withAlpha(180),
        ),
        title: ShadowText(title),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  String _getSectionTitle(String key) {
    return HOME_SCREEN_SECTIONS[key]!.title;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _arrangeHome() async {
    final homeArrangement = ref.read(settingsGeneralStateProvider).homeSectionsArrangement;

    await showSettingsDialog(
      title: 'Re-arrange Home Screen',
      yesOrNo: true,
      yesFunction: () async {
        ref.read(settingsGeneralStateProvider.notifier).homeSectionsArrangement = homeArrangement;
        await _refreshApp();
      },
      content: Container(
        width: double.maxFinite,
        height: homeArrangement.length * responsiveUI.own(0.13) + responsiveUI.own(0.035),
        padding: EdgeInsets.only(top: responsiveUI.own(0.03)),
        child: ReorderableListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, idx) {
            return _getDragAndDropItem(
              key: homeArrangement[idx],
              title: _getSectionTitle(homeArrangement[idx]),
            );
          },
          itemCount: homeArrangement.length,
          onReorder: (int oldItemIndex, int newItemIndex) {
            setState(() {
              var movedItem = homeArrangement.removeAt(oldItemIndex);
              homeArrangement.insert(newItemIndex, movedItem);
            });
          },
        ),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _arrangeCollectionTab() async {
    final collectionStatusArrangement = ref.read(settingsGeneralStateProvider).collectionStatusTabArrangement;

    await showSettingsDialog(
      title: 'Re-arrange Tab Collection',
      yesOrNo: true,
      yesFunction: () async {
        ref.read(settingsGeneralStateProvider.notifier).collectionStatusTabArrangement =
            collectionStatusArrangement;

        await ref.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
        await _refreshApp();
      },
      content: Container(
        width: double.maxFinite,
        height: collectionStatusArrangement.length * responsiveUI.own(0.13) + responsiveUI.own(0.035),
        padding: EdgeInsets.only(top: responsiveUI.own(0.03)),
        child: ReorderableListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, idx) {
            return _getDragAndDropItem(
              key: collectionStatusArrangement[idx],
              title: toBeginningOfSentenceCase<String>(collectionStatusArrangement[idx]),
            );
          },
          itemCount: collectionStatusArrangement.length,
          onReorder: (int oldItemIndex, int newItemIndex) {
            setState(() {
              var movedItem = collectionStatusArrangement.removeAt(oldItemIndex);
              collectionStatusArrangement.insert(newItemIndex, movedItem);
            });
          },
        ),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _previewItemCount() async {
    int maxPreviewItem = ref.read(settingsGeneralStateProvider).maxPreviewItem;

    await showSettingsDialog(
      title: 'Home VN item previews count',
      yesOrNo: true,
      yesFunction: () async {
        ref.read(settingsGeneralStateProvider.notifier).maxPreviewItem = maxPreviewItem;
        await _refreshApp();
      },
      content: Padding(
        padding: EdgeInsets.only(
          top: responsiveUI.own(0.02),
          left: responsiveUI.own(0.05),
          right: responsiveUI.own(0.05),
          bottom: responsiveUI.own(0.01),
        ),
        child: Container(
          width: responsiveUI.own(0.1),
          height: responsiveUI.own(0.25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Color.alphaBlend(
                App.themeColor.secondary.withOpacity(0.4),
                App.themeColor.tertiary.withOpacity(0.6),
              ),
              width: 1.5,
            ),
          ),
          child: ListviewScrollItem(
            // Minus one in the UI to align with the list index which starts at 0
            initialItemController: maxPreviewItem - 1,
            onSelectedItemChanged: (value) {
              // Plus one to ignore UI list index and focus with real length value.
              setState(() => maxPreviewItem = value + 1);
            },
            children: List.generate(30, (idx) {
              return ShadowText(
                // Index start at 0, but in the context 0 is not possible, so incrementing 1 (only affect visual).
                (idx + 1).toString(),
                fontSize: responsiveUI.own(0.04),
                color: Colors.white,
              );
            }),
          ),
        ),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _chartSwitch() async {
    final showChart = ref.read(settingsGeneralStateProvider).showChart;
    ref.read(settingsGeneralStateProvider.notifier).showChart = !showChart;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _vnItemsPerRow() async {
    int valueIdxPortrait = ref.read(settingsGeneralStateProvider).maxItemPerRowPortrait;
    int valueIdxLandscape = ref.read(settingsGeneralStateProvider).maxItemPerRowLandscape;

    await showSettingsDialog(
      title: 'VN item per row count',
      yesOrNo: true,
      yesFunction: () async {
        ref.read(settingsGeneralStateProvider.notifier).maxItemPerRowPortrait = valueIdxPortrait;
        ref.read(settingsGeneralStateProvider.notifier).maxItemPerRowLandscape = valueIdxLandscape;
        await _refreshApp();
      },
      content: SettingsItemPerRow(
        initialPortraitValue: valueIdxPortrait,
        initialLandscapeValue: valueIdxLandscape,
        onSelectedItemChangedPortrait: (value) {
          // Index start at 0, but in the context, 0 is not possible.
          // This time incrementing 2 as it starts from 2.
          setState(() => valueIdxPortrait = value + 2);
        },
        onSelectedItemChangedLandscape: (value) {
          // Index start at 0, but in the context 0 is not possible.
          // This time incrementing 2 as it starts from 4.
          setState(() => valueIdxLandscape = value + 4);
        },
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsGeneralStateProvider);

    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _animationController.drive(CurveTween(curve: Curves.easeInToLinear)),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(responsiveUI.own(0.04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Censor
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _censorCoverSwitch(),
                children: [
                  ShadowText('Activate censor for VN cover '),
                  ShadowText(
                    (settings.showCoverCensor) ? ' ON' : ' OFF',
                    fontWeight: FontWeight.bold,
                    color: (settings.showCoverCensor) ? Colors.green : Colors.red,
                    shadows: [
                      Shadow(
                        color: Color.alphaBlend(
                          Colors.black.withOpacity(0.5),
                          App.themeColor.primary,
                        ),
                        blurRadius: 5,
                      )
                    ],
                  ),
                ],
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Arrange Home
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _arrangeHome(),
                children: [
                  ShadowText('Arrange home screen previews'),
                ],
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Arrange Tab
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _arrangeCollectionTab(),
                children: [
                  ShadowText('Arrange collection status tabs'),
                ],
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Preview item count
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _previewItemCount(),
                children: [
                  ShadowText('Home VN item previews: '),
                  ShadowText(
                    // Because index starts at 0, and 0 is not valid
                    (settings.maxPreviewItem != 20) ? '${settings.maxPreviewItem}' : 'Default (20)',
                    color: App.themeColor.tertiary.withAlpha(180),
                  ),
                ],
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Show PieChart
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _chartSwitch(),
                children: [
                  ShadowText('Show VNDB stats chart '),
                  ShadowText(
                    (settings.showChart) ? ' YES' : ' NO',
                    fontWeight: FontWeight.bold,
                    color: (settings.showChart) ? Colors.green : Colors.red,
                    shadows: [
                      Shadow(
                        color: Color.alphaBlend(
                          Colors.black.withOpacity(0.5),
                          App.themeColor.primary,
                        ),
                        blurRadius: 5,
                      )
                    ],
                  ),
                ],
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Vn Items per row
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _vnItemsPerRow(),
                children: [
                  ShadowText('VN item per row: '),
                  ShadowText(
                    'Potrait: ${(settings.maxItemPerRowPortrait == 2) ? 'Default (2)' : settings.maxItemPerRowPortrait} | '
                    'Landscape: ${(settings.maxItemPerRowLandscape == 4) ? 'Default (4)' : settings.maxItemPerRowLandscape}',
                    color: App.themeColor.tertiary.withAlpha(180),
                  ),
                ],
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            ],
          ),
        ),
      ),
    );
  }
}
