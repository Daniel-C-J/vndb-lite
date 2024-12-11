import 'package:flutter/material.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

class ListviewScrollItem extends StatefulWidget {
  const ListviewScrollItem({
    super.key,
    required this.initialItemController,
    required this.onSelectedItemChanged,
    required this.children,
  });

  final int initialItemController;
  final void Function(int) onSelectedItemChanged;
  final List<Widget> children;

  @override
  State<ListviewScrollItem> createState() => _ListviewScrollItemState();
}

class _ListviewScrollItemState extends State<ListviewScrollItem> {
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: widget.initialItemController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      squeeze: 0.8,
      diameterRatio: 30,
      overAndUnderCenterOpacity: 0.5,
      controller: _scrollController,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: widget.onSelectedItemChanged,
      itemExtent: responsiveUI.own(0.06),
      children: widget.children,
    );
  }
}
