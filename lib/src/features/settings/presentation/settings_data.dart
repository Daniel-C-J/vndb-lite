import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/core/network/network_helper.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/refresh_button.dart';
import 'package:vndb_lite/src/features/settings/application/settings_service.dart';
import 'package:vndb_lite/src/features/settings/presentation/components/settings_snackbar.dart';
import 'package:vndb_lite/src/features/settings/presentation/dialog/settings_dialog.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_data_state.dart';
import 'package:vndb_lite/src/features/sync/presentation/auth_screen_controller.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

class SettingsData extends ConsumerStatefulWidget {
  const SettingsData({super.key});

  @override
  ConsumerState<SettingsData> createState() => _SettingsDataState();
}

class _SettingsDataState extends ConsumerState<SettingsData> with SingleTickerProviderStateMixin {
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

  Future<void> _refreshApp({bool all = false, bool verbose = false}) async {
    await AppBarRefreshButton.tap(allMainScreen: all, verbose: verbose);
    if (mounted) setState(() {});
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _autoUpdateCheckSwitch() async {
    final autoUpdate = ref.read(settingsDataStateProvider).autoUpdate;
    ref.read(settingsDataStateProvider.notifier).autoUpdate = !autoUpdate;

    await _refreshApp();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _refreshVns() async {
    // TODO showDialog? Anything user friendly like the others below.
    if (ref.read(bottomProgressIndicatorProvider)) return;

    // Does not do any process whatsoever if there is no internet connection.
    final hasConnection = await ref.read(networkInfoProvider).isConnected;
    if (!hasConnection) {
      feedbackSnackBar(
        text: 'Refresh failed.',
        iconColor: Colors.red,
        icon: Icons.warning,
      );
      return;
    }

    ref.read(bottomProgressIndicatorProvider.notifier).show = true;
    feedbackSnackBar(text: 'Refreshing...', icon: Icons.refresh);

    try {
      // This will redownload all collected vn phase01 and phase02 data.
      await ref.read(settingsServiceProvider).refresh(
        onRefresh: (String title) {
          feedbackSnackBar(
            text: (title.length > 15) ? '${title.substring(0, 14)}... refreshed. ' : '$title refreshed. ',
          );
        },
      );

      await Future.delayed(const Duration(milliseconds: 2000));
      feedbackSnackBar(text: 'Refreshed.', icon: Icons.refresh);
      //
    } catch (e) {
      feedbackSnackBar(
        text: 'Refresh failed.',
        icon: Icons.error,
      );
      //
    } finally {
      // Using emergency ref in case the widget disposed.
      ref_.read(bottomProgressIndicatorProvider.notifier).show = false;
      await _refreshApp(all: true);
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _deleteVns() async {
    await showSettingsDialog(
      title: "You are about to delete all Visual Novels in your collection. Are you sure?",
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.05)),
        child: ShadowText(
          (ref.read(bottomProgressIndicatorProvider))
              ? 'Please wait until the current process is done.'
              : 'If you already once sucessfully synced with the cloud (VNDB), the next time you sync, '
                  'all VNs in your collection will finally be removed permanently.',
        ),
      ),
      yesOrNo: ref.read(bottomProgressIndicatorProvider) != true,
      yesButtonColor:
          (ref.read(bottomProgressIndicatorProvider)) ? null : const Color.fromARGB(180, 255, 20, 0),
      yesFunction: () async {
        // If turns out there's an ongoing process, then dont remove auth.
        if (ref.read(bottomProgressIndicatorProvider)) return;

        final auth = ref.read(authScreenControllerProvider.notifier);
        feedbackSnackBar(text: 'Removing VNs...');

        // If user already once successfully synchronized, then all of the current vns, the next
        // time user sync again, will all be removed in the cloud.
        if (auth.isUserSynced()) {
          ref.read(settingsServiceProvider).deleteAll(sync: true);
        } else {
          ref.read(settingsServiceProvider).deleteAll(sync: false);
        }

        await _refreshApp(all: true);
        feedbackSnackBar(text: ' All VNs have been removed. ');
      },
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _clearCache() async {
    await showSettingsDialog(
      title: "Do you want to reset all data back to default?",
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.05)),
        child: ShadowText(
          (ref.read(bottomProgressIndicatorProvider))
              ? 'Please wait until the current process is done.'
              : 'You would have to restart the app for the whole default configurations to take effect.',
        ),
      ),
      yesOrNo: ref.read(bottomProgressIndicatorProvider) != true,
      yesButtonColor:
          (ref.read(bottomProgressIndicatorProvider)) ? null : const Color.fromARGB(180, 255, 20, 0),
      yesFunction: () async {
        // If turns out there's an ongoing process, then dont remove auth.
        if (ref.read(bottomProgressIndicatorProvider)) return;

        feedbackSnackBar(text: 'Resetting data...');

        // To immediately update the UI.
        await ref.read(settingsServiceProvider).removeAuth();
        ref.invalidate(authScreenControllerProvider);

        // Back to default.
        await ref.read(settingsServiceProvider).clearCache();
        await _refreshApp(all: true, verbose: true);

        feedbackSnackBar(text: 'Welcome to the default back!', icon: Icons.waving_hand);
      },
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _removeAuth() async {
    await showSettingsDialog(
      title: "Revoke Authentication?",
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.05)),
        child: ShadowText(
          (ref.read(bottomProgressIndicatorProvider))
              ? 'Please wait until the current process is done.'
              : 'Your data will remain as is as the latest synchronization sucessfully initiated.',
        ),
      ),
      yesOrNo: ref.read(bottomProgressIndicatorProvider) != true,
      yesButtonColor:
          (ref.read(bottomProgressIndicatorProvider)) ? null : const Color.fromARGB(180, 255, 20, 0),
      yesFunction: () async {
        // If turns out there's an ongoing process, then dont remove auth.
        if (ref.read(bottomProgressIndicatorProvider)) return;

        await ref.read(settingsServiceProvider).removeAuth();
        ref.invalidate(authScreenControllerProvider);

        feedbackSnackBar(text: 'Authentication has been revoked.');
      },
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsDataStateProvider);
    final uId = ref.watch(authScreenControllerProvider);
    final userDidAuth = uId != null;

    print(uId);

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
//
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _autoUpdateCheckSwitch(),
                children: [
                  ShadowText('Automatically check update at start '),
                  ShadowText(
                    (settings.autoUpdate) ? ' ON' : ' OFF',
                    fontWeight: FontWeight.bold,
                    color: (settings.autoUpdate) ? Colors.green : Colors.red,
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
// Refresh VNs
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                highlightColor: const Color.fromARGB(180, 240, 210, 50),
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: _refreshVns,
                children: [
                  ShadowText('Refresh all Visual Novel in collection'),
                ],
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Delete VNs
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                highlightColor: const Color.fromARGB(180, 240, 70, 50),
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: _deleteVns,
                children: [
                  ShadowText('Remove all Visual Novel in collection'),
                ],
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Clear caches
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                highlightColor: const Color.fromARGB(180, 240, 70, 50),
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: _clearCache,
                children: [
                  ShadowText('Reset all data'),
                ],
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Revoke Authentication
              if (userDidAuth) SizedBox(height: responsiveUI.own(0.03)),
              if (userDidAuth)
                CustomLabel(
                  useBorder: true,
                  borderRadius: 12,
                  isSelected: false,
                  borderColor: App.themeColor.secondary,
                  highlightColor: const Color.fromARGB(180, 240, 210, 50),
                  padding: EdgeInsets.all(responsiveUI.own(0.02)),
                  onTap: _removeAuth,
                  children: [
                    ShadowText('Revoke authentication (Logout)'),
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
