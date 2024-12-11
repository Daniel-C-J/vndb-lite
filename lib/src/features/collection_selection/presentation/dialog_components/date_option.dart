import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection_selection/domain/vn_selection.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/collection_selection_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/footer_button_state.dart';
import 'package:vndb_lite/src/util/button_states.dart';

class RecordDateOptions extends ConsumerStatefulWidget {
  const RecordDateOptions({super.key});

  @override
  ConsumerState<RecordDateOptions> createState() => _RecordDateOptionsState();
}

class _RecordDateOptionsState extends ConsumerState<RecordDateOptions> {
  final DateFormat _dtFormatter = DateFormat.yMd();

  bool _errorStartDate = false;
  bool _errorFinishDate = false;
  bool _selectingDateTimeNow = false;

  DateTime get _now => DateTime.now();

  // This to limit the first oldest date selection available to be selected either
  // for finished date, or started date.
  DateTime get _firstDate => DateTime(_now.year - 25, _now.month, _now.day);

  bool get _incorrectStartDate {
    final startDate = ref.read(vnSelectionControllerProvider).started;
    final finishDate = ref.read(vnSelectionControllerProvider).finished;
    return startDate != null && finishDate != null && startDate.isAfter(finishDate); // Incorrect
  }

  bool get _incorrectFinishDate {
    final startDate = ref.read(vnSelectionControllerProvider).started;
    final finishDate = ref.read(vnSelectionControllerProvider).finished;
    return finishDate != null && startDate != null && finishDate.isBefore(startDate); // Incorrect
  }

  set _canConfirm(bool value) {
    ref.read(vnConfirmButtonStateProvider.notifier).state =
        (value) ? ConfirmButtonState.normal : ConfirmButtonState.disabled;
  }

  Future<DateTime?> getDatePicker({DateTime? initialDate}) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? _now,
      firstDate: _firstDate,
      lastDate: _now,
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
  void _startDatePicker() async {
    final initialDate = ref.read(vnSelectionControllerProvider).started;
    ref.read(vnSelectionControllerProvider.notifier).copyWith(
          started: await getDatePicker(initialDate: initialDate),
        );

    setState(() {
      if (_incorrectStartDate) {
        _errorStartDate = true;
        _canConfirm = false;
        return;
      }

      _errorStartDate = false;
      _errorFinishDate = false;
      _canConfirm = true;
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _finishDatePicker() async {
    final initialDate = ref.read(vnSelectionControllerProvider).finished;
    ref.read(vnSelectionControllerProvider.notifier).copyWith(
          finished: await getDatePicker(initialDate: initialDate),
        );

    setState(() {
      if (_incorrectFinishDate) {
        _errorFinishDate = true;
        _canConfirm = false;
        return;
      }

      _errorStartDate = false;
      _errorFinishDate = false;
      _canConfirm = true;
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  // Argument isError happen, since both finish date and start date relied on this function, and both
  // sends the same DateTime type without any way to differ between the two, so from the caller, it must
  // provide the identifier for both start and finish date.
  String _dateOptionText(DateTime? selectedDate, bool isError) {
    final isMultiSelection = ref.read(vnSelectionControllerProvider.notifier).isMultiselection;

    if (selectedDate != null) {
      if (_errorFinishDate && isError) {
        return 'Finish date must be after the start date.';
      }

      if (_errorStartDate && isError) {
        return 'Start date must be before the finish date.';
      }

      return '  ${_dtFormatter.format(selectedDate)}';
      //
    } else {
      //
      if (isMultiSelection) return ' Mixed';
      return '';
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _tapNowDate(VnSelection selectionController) {
    _selectingDateTimeNow = !_selectingDateTimeNow;

    if (_selectingDateTimeNow) {
      _canConfirm = true;
      _errorStartDate = false;
      _errorFinishDate = false;
      ref.read(vnSelectionControllerProvider.notifier).copyWith(
            started: _now,
            finished: _now,
          );
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final selectionController = ref.watch(vnSelectionControllerProvider);
    final buttonState = ref.watch(vnConfirmButtonStateProvider);

    return IgnorePointer(
      ignoring: buttonState == ConfirmButtonState.inprogress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Now date
          InkWell(
            // behavior: HitTestBehavior.opaque,
            onTap: () {
              _tapNowDate(selectionController);
              setState(() {});
            },
            child: Opacity(
              opacity: (buttonState == ConfirmButtonState.inprogress) ? 0.6 : 1,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: responsiveUI.own(0.05),
                    height: responsiveUI.own(0.045),
                    child: Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        splashRadius: 2,
                        value: _selectingDateTimeNow,
                        checkColor: App.themeColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        fillColor: WidgetStatePropertyAll(App.themeColor.secondary),
                        onChanged: (value) {
                          _tapNowDate(selectionController);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: responsiveUI.own(0.01)),
                    child: Wrap(
                      children: [
                        ShadowText('Now ('),
                        ShadowText(
                          _dtFormatter.format(_now),
                          color: App.themeColor.secondary,
                        ),
                        ShadowText(')'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: responsiveUI.own(0.015)),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Started
          Opacity(
            opacity: (_selectingDateTimeNow || buttonState == ConfirmButtonState.inprogress) ? 0.6 : 1,
            child: GestureDetector(
              onTap: (_selectingDateTimeNow) ? () {} : _startDatePicker,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ShadowText('Start Date (Opt.) '),
                  Icon(
                    Icons.calendar_month,
                    size: responsiveUI.own(0.045),
                    color: App.themeColor.secondary,
                  ),
                  ShadowText(
                    _dateOptionText(selectionController.started, _errorStartDate),
                    color: (_errorStartDate) ? Colors.red : App.themeColor.secondary,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: responsiveUI.own(0.01)),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Finished
          Opacity(
            opacity: (_selectingDateTimeNow || buttonState == ConfirmButtonState.inprogress) ? 0.6 : 1,
            child: GestureDetector(
              onTap: (_selectingDateTimeNow) ? () {} : _finishDatePicker,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: [
                  ShadowText('Finish Date (Opt.) '),
                  Icon(
                    Icons.calendar_month,
                    size: responsiveUI.own(0.045),
                    color: App.themeColor.secondary,
                  ),
                  ShadowText(
                    _dateOptionText(selectionController.finished, _errorFinishDate),
                    color: (_errorFinishDate) ? Colors.red : App.themeColor.secondary,
                  ),
                ],
              ),
            ),
          ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        ],
      ),
    );
  }
}
