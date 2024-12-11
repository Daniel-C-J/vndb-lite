import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';

class MultiSelectionIndicator extends ConsumerStatefulWidget {
  const MultiSelectionIndicator({super.key});

  @override
  ConsumerState<MultiSelectionIndicator> createState() => _MultiSelectionIndicatorState();
}

class _MultiSelectionIndicatorState extends ConsumerState<MultiSelectionIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    final isMultiSelection = ref.read(recordSelectedControllerProvider).isNotEmpty;

    _animationController = AnimationController(
      vsync: this,
      duration: (mounted && isMultiSelection) ? Duration(milliseconds: 0) : Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController.drive(CurveTween(curve: Curves.ease)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              App.themeColor.primary.withOpacity(0.2),
              App.themeColor.secondary.withOpacity(0.5),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 6,
            )
          ],
          border: GradientBoxBorder(
            gradient: RadialGradient(colors: [
              App.themeColor.secondary.withOpacity(0.9),
              App.themeColor.secondary.withOpacity(0.6),
              App.themeColor.tertiary.withOpacity(0.4)
            ]),
            width: 2.5,
          ),
        ),
      ),
    );
  }
}
