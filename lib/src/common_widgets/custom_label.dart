import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

class CustomLabel extends ConsumerWidget {
  const CustomLabel({
    super.key,
    this.onTap,
    required this.useBorder,
    required this.children,
    this.padding,
    this.borderColor,
    this.highlightColor,
    this.borderRadius = 8,
    this.bgColor,
    this.shadowColor,
    this.isSelected = true,
  });

  final bool useBorder;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? highlightColor;
  final Color? borderColor;
  final Color? bgColor;
  final List<BoxShadow>? shadowColor;
  final List<Widget> children;
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: (isSelected) ? bgColor ?? App.themeColor.primary : Colors.transparent,
          border: (useBorder)
              ? Border.all(
                  width: 2,
                  color: (isSelected)
                      ? borderColor ?? App.themeColor.secondary.withOpacity(0.6)
                      : borderColor ?? App.themeColor.primary,
                )
              : null,
          boxShadow: (isSelected)
              ? shadowColor ??
                  const [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      color: Color.fromARGB(90, 0, 0, 0),
                    )
                  ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius - 2), // Minus the parent's border width
            splashColor: highlightColor,
            highlightColor: highlightColor,
            onTap: onTap ?? () {},
            child: Container(
              padding: padding ??
                  EdgeInsets.symmetric(
                    vertical: responsiveUI.own(0.01),
                    horizontal: responsiveUI.own(0.025),
                  ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
