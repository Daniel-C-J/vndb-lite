// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/search/presentation/search_result_controller.dart';

part 'search_screen_controller.g.dart';

@Riverpod(keepAlive: true)
class SearchResultNotifier extends _$SearchResultNotifier {
  @override
  bool build() {
    return false;
  }

  void ring() {
    state = true;
  }

  void end() {
    state = false;
  }
}

@Riverpod(keepAlive: true)
class SearchScreenController extends _$SearchScreenController {
  @override
  List<Widget> build() {
    return [];
  }

  void add(Widget widget) {
    final tempState = state;
    tempState.add(widget);

    state = tempState;
  }

  void removeLast() {
    final tempState = state;
    tempState.removeLast();

    state = tempState;
  }

  void resetState() {
    state = <Widget>[];
  }

  /// By conf, that simply means to get both sort and filter configuration, and forge them together into
  /// a classified request data model.
  Future<void> searchWithCurrentConf({int pageResult = 1}) async {
    // Resetting values, by expecting a new query has been made.
    if (pageResult == 1) {
      ref.invalidate(searchResultControllerProvider);
      ref.invalidate(searchResultPageControllerProvider);
      resetState();
    }

    // Initiate search
    ref.read(searchResultNotifierProvider.notifier).ring();
  }

  // Yo quiero tacobell. Does not work.
  // ref.watch(remoteSearchVnProvider(requestData).future).when(
  //       data: (data) {},
  //       error: (err, st) {},
  //       loading: () {},
  //     );
}
