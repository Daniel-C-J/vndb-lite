import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/devstatus_data.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';

class GenerateDevRecordStatusOptions extends ConsumerWidget {
  const GenerateDevRecordStatusOptions({
    super.key,
    required this.func,
    required this.status,
  });

  final int status;
  final void Function() func;

// ----------------------------------------No InitState?-------------------------------------
// ⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣟⢯⡟⣽⢫⣏⠿⣹⢟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⡟⣿⢽⣫⢟⡽⣝⢯⣻⢽⡿⣿⣿⣿⣿⣿⣿⣿⣿
// ⠀⠀⠀⣰⣿⣿⣿⣿⢿⡽⣫⢯⡻⣵⢫⡞⣝⢧⣟⡾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⡼⣯⣟⡾⣯⣟⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿
// ⠀⢀⠰⣿⣿⣻⡽⣞⣯⢷⣫⢷⡹⣎⠷⠉⠈⢞⡨⢹⠩⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⢿⣻⣟⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
// ⠀⢠⢘⣿⣳⢯⠿⣽⠚⠯⢃⠉⠁⠈⠀⠀⠀⢘⡴⠘⡄⠙⠿⣿⣿⣿⣿⣿⣿⣟⣿⡿⣿⢯⣿⡾⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
// ⠀⠀⠉⠐⠉⢊⠡⠈⠈⠐⠀⠀⠀⠀⠀⠀⣰⢫⣞⡄⣭⠀⠀⠙⢿⢿⣿⣿⣿⡿⣯⣟⣿⣻⣷⢿⡿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢠⣬⢳⣻⢮⡽⣚⣧⣀⠀⠀⠈⠛⠫⢷⠿⢿⡽⣳⢯⡿⣟⡿⣷⢿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
// ⠀⠀⠀⠀⠀⠀⠀⢀⡀⣤⡐⢦⢮⡭⣷⢞⣯⡽⣯⣳⠽⣞⡭⣷⣄⠀⠀⠀⠁⠈⠠⠉⠍⠋⠑⠉⠚⠡⠋⠌⠉⠟⡽⣻⠷⣯⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿
// ⠀⠀⠀⠀⠀⠀⣒⢧⣛⢶⡹⣏⣞⡳⣽⣚⢧⣟⡷⢯⣻⣝⢶⡳⢯⡷⣆⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⡯⣾⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⡿
// ⠀⠀⠀⠀⠀⠀⠸⡸⢻⡜⣧⢻⡜⣧⢇⡿⣜⢧⢿⣟⢧⣼⠟⣻⢇⡿⣼⢻⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠻⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢧⣿⣿⣿⡿⠃
// ⠀⠀⠀⠀⠀⠀⠀⠈⠋⣽⠸⣣⢟⡼⡹⢶⡹⣎⢷⡺⣏⣾⣟⡥⢫⡞⣵⢻⡞⣽⣛⢶⡲⣤⢤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡟⣿⣿⣿⣿⣿⣿⣿⣿⡿⣧⢿⣼⡿⠋⠀⢀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢽⡶⠩⠉⠎⠱⡙⢎⡳⠭⣿⢾⡝⣧⢹⣎⠷⣹⢶⡹⣎⢷⡹⣎⡳⣜⢯⡳⢖⣄⡀⠀⠀⠀⠀⠀⠀⢁⣻⣿⣿⣿⣿⣿⣿⣿⢳⡽⡻⠋⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⢀⠀⠀⠉⠀⠘⡱⢸⡿⣜⠶⣹⢬⢫⠵⣪⠕⡎⢧⡹⢜⡱⢭⣚⣭⢻⣬⢳⣣⠖⣤⠀⠀⠀⠀⣽⣿⣿⣿⣿⣿⣟⠶⠋⠁⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠃⠀⠀⠀⠀⠈⢻⣽⢎⡳⡱⢎⠧⠙⠔⡉⠜⠠⢃⠊⢌⠣⠘⠦⣛⡬⡗⣧⢻⡜⢯⡖⡀⠀⢺⣿⣿⣿⣿⣿⡍⠁⠀⢀⣀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡟⠃⠀⠀⢠⣦⠀⢘⡿⣎⠵⣉⠆⡰⠀⠁⠀⠀⠀⠀⠀⠀⠀⠈⠐⠠⠱⡹⣜⢣⢟⣣⠟⡵⡰⢸⣿⣽⣿⣿⠟⠀⢠⣴⠿⠛⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⣿⠇⠀⠀⠀⠀⠀⠀⢨⢿⡜⡣⣍⠠⠀⠀⠀⣠⣶⠟⠂⠀⠀⠀⠀⠀⠀⠀⠑⠨⡓⢮⡱⢋⡖⡅⣿⣿⣿⠋⠁⠀⠰⠈⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⠀⠙⠳⠄⠀⠀⠀⠀⠀⣸⡯⠄⠱⢪⠔⡀⠀⢰⣿⡿⠂⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⡙⢦⠱⣉⢦⣇⣿⣿⠃⠀⠀⡴⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣿⣃⠐⠠⠀⠀⠀⠀⢀⣰⣿⡥⢉⢰⠀⠆⠀⠀⣿⣿⡗⠀⠀⠀⠘⠋⠀⠀⠀⣲⠀⠀⣸⣯⣷⣿⣾⣿⣿⡋⠀⠠⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣯⡵⣔⢦⣴⣒⣖⣿⣿⡿⠓⣈⢰⠈⠠⠄⠀⠸⣟⣿⡀⠀⢀⠀⠀⠀⠀⣰⡿⠇⢀⣾⣿⣿⣿⣿⣿⢃⠧⡌⠓⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⣿⡟⣹⣿⣿⣿⣿⣿⠋⡄⢑⣂⢃⠀⠃⡈⠀⠀⡈⠙⠳⠤⠀⠁⠀⠀⠐⢉⠀⣠⣿⣿⣿⣿⣿⣿⣷⠎⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠰⣽⡺⢝⣫⣿⣿⡿⣇⠫⢀⠲⡈⣌⣀⠀⢀⠀⡀⠀⠂⠤⠀⡄⠄⠢⠄⠋⢜⣹⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠠⡇⣁⣾⣿⣿⣿⣛⢦⠳⣄⠳⡱⢎⣤⠊⢮⡱⣜⠲⡤⢤⣈⠤⣄⠖⣶⢾⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣺⣿⣿⣿⣿⣯⣝⢮⣳⣎⡳⣭⣓⢦⡳⣨⢳⣎⢿⡹⢶⡩⢟⣜⠻⣎⠿⣹⢟⡿⣿⣿⣿⡏⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⣼⣿⣿⣿⣿⣿⣾⣿⣿⣷⣿⣿⣷⣽⣲⡽⢥⣓⠮⣇⡻⢲⣍⠳⢎⡙⠆⣏⢧⢛⡼⢃⣇⡞⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠐⢀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣷⠊⡕⣣⢝⡣⢎⡝⢬⠁⠖⣘⡺⡼⢾⣟⡝⠀⢿⣦⠀⠁⢀⠐⡈⠄⠠⠀⠀⠀⠀⠀⢰⠇⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠃⢲⢡⡎⢱⠋⡜⣦⠑⠂⠑⡟⢳⣮⡝⠁⠀⢠⠉⠉⠒⡄⠒⢠⠈⠐⠀⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⡘⢤⠣⡜⡣⣝⡱⢎⣝⣺⣽⢏⣾⣿⠃⠀⠀⠈⠁⠀⠀⠑⠠⠂⠌⡐⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⢀⢖⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣡⢎⡱⢢⠱⡘⡵⢪⡕⣫⣞⣷⣿⣾⣷⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠄⠀⠈⠀⠁⠂⠐⡀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠠⠽⡿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣽⣶⣾⢵⣮⡕⠃⡥⢓⡜⣣⢎⣷⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⡐⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠈⡷⡝⢿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣭⣾⣿⣿⣿⣿⣿⣶⣷⡅⠲⢡⢚⡥⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁
// ⠀⠀⠀⠀⠀⠀⠀⠀⠐⠈⣊⢛⢪⡿⠟⠛⢋⠵⢷⠿⣿⣿⣿⡿⣿⣿⣿⣿⣷⡞⡣⢈⢲⡹⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠰⠀⠊⢀⢀⢀⡀⣆⣊⣵⣭⣄⣁⠉⠻⢿⣽⣆⠠⠘⣽⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡱⠀⠀⠀⠀⠀⠤⢐⠚⠽⠿⢻⣿⢷⣶⡀⠻⣷⠀⠡⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠜⠡⠀⠀⠀⠀⠀⠌⠢⠉⠴⠉⠖⠲⠭⠿⠷⠆⠌⠲⠽⠿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final List selectedDevStatus;

    if (App.isInSearchScreen) {
      selectedDevStatus = ref.watch(tempRemoteFilterControllerProvider).devstatus;
    } else {
      selectedDevStatus = ref.watch(localFilterControllerProvider).devstatus;
    }

    final bool isSelected = selectedDevStatus.contains(status);

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
          Icon(
            Icons.circle,
            color: DEVELOPMENT_STATUS[status]!.color,
            size: responsiveUI.own(0.027),
          ),
          ShadowText('  ${DEVELOPMENT_STATUS[status]!.title}'),
        ],
      ),
    );
  }
}
