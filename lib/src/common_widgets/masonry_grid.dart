import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MasonryGrid extends StatefulWidget {
  const MasonryGrid({
    super.key,
    this.column = 1,
    required this.children,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.staggered = false,
  });

  final int column;
  final List<Widget> children;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final CrossAxisAlignment crossAxisAlignment;
  final bool staggered;

  @override
  State<MasonryGrid> createState() => _MasonryGridState();
}

class _MasonryGridState extends State<MasonryGrid> {
  int renderId = 0;
  late List<List<Widget>> columnItem;
  late List<GlobalKey> columnKey;

  @override
  void initState() {
    assert(widget.column >= 1, 'column should be at least 1.');
    assert(widget.mainAxisSpacing >= 0, 'mainAxisSpacing should be positive.');
    assert(widget.crossAxisSpacing >= 0, 'crossAxisSpacing should be positive.');

    columnItem = List.generate(widget.column, (i) => []);
    columnKey = List.generate(widget.column, (i) => GlobalKey());
    super.initState();
  }

  @override
  void didUpdateWidget(prev) {
    if (!listEquals(prev.children, widget.children) ||
        prev.column != widget.column ||
        prev.mainAxisSpacing != widget.mainAxisSpacing ||
        prev.crossAxisSpacing != widget.crossAxisSpacing ||
        prev.crossAxisAlignment != widget.crossAxisAlignment ||
        prev.staggered != widget.staggered) {
      setState(() {
        renderId = 0;
        columnItem = List.generate(widget.column, (i) => []);
        columnKey = List.generate(widget.column, (i) => GlobalKey());
      });
    }

    super.didUpdateWidget(prev);
  }

  int getSmallestColumnId() {
    var smallestColumnId = 0;

    try {
      final renderColumn = List<RenderBox?>.generate(
          columnKey.length, (i) => columnKey[i].currentContext?.findRenderObject() as RenderBox?);
      final columnHeight = List<double>.generate(renderColumn.length, (i) => renderColumn[i]!.size.height);

      columnHeight.asMap().forEach((i, item) {
        if (columnHeight[i] < columnHeight[smallestColumnId]) {
          smallestColumnId = i;
        }
      });
    } catch (err) {
      // TODO: handle err.
    }

    return smallestColumnId;
  }

  void renderItemStaggered() {
    var columnId = getSmallestColumnId();
    columnItem[columnId].add(
      Padding(
        padding: EdgeInsets.only(bottom: widget.mainAxisSpacing),
        child: widget.children[renderId],
      ),
    );

    if (mounted) {
      setState(() {
        renderId = renderId + 1;
      });
    }
  }

  void renderItemInOrder() {
    for (var i = renderId; i < widget.children.length; i++) {
      columnItem[i % widget.column].add(
        Padding(
          padding: EdgeInsets.only(bottom: widget.mainAxisSpacing),
          child: widget.children[i],
        ),
      );
    }

    if (mounted) {
      setState(() {
        renderId = widget.children.length;
      });
    }
  }

  void renderChildren() {
    if (!widget.staggered && renderId < widget.children.length) {
      renderItemInOrder();
    } else if (widget.staggered && renderId < widget.children.length) {
      Future.microtask(() => renderItemStaggered());
    }
  }

  @override
  Widget build(BuildContext context) {
    renderChildren();

    final column = widget.crossAxisSpacing == 0
        ? List.generate(
            widget.column,
            (i) => Expanded(
                  child: Column(
                    key: columnKey[i],
                    crossAxisAlignment: widget.crossAxisAlignment,
                    children: columnItem[i],
                  ),
                ))
        : List.generate(
            widget.column + (widget.column - 1),
            (i) => i.isEven
                ? Expanded(
                    child: Column(
                      key: columnKey[(i / 2).floor()],
                      crossAxisAlignment: widget.crossAxisAlignment,
                      children: columnItem[(i / 2).floor()],
                    ),
                  )
                : SizedBox(
                    width: widget.crossAxisSpacing,
                  ),
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: column,
    );
  }
}
