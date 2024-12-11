import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

/// Leave gradientColor null if only using one plain color.
class CustomButton extends ConsumerWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    this.color,
    this.content,
    this.radius,
    this.size,
    this.gradientColor,
    this.icon,
    this.iconSize,
    this.tooltipMsg,
    this.useButtonShadow = true,
  });

  final String? tooltipMsg;
  final double? radius;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? size;
  final Color? color;
  final List<Color>? gradientColor;
  final IconData? icon;
  final Widget? content;
  final double? iconSize;
  final bool useButtonShadow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentWidget = Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        color: color ?? App.themeColor.primary,
        gradient: (gradientColor != null)
            ? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: gradientColor!,
              )
            : null,
        boxShadow: (useButtonShadow)
            ? const [
                BoxShadow(color: Color.fromARGB(130, 0, 0, 0), blurRadius: 3),
              ]
            : null,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(radius ?? 10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius ?? 10),
          onTap: onTap,
          child: Container(
            padding: size ?? EdgeInsets.all(responsiveUI.own(0.015)),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: App.themeColor.tertiary,
                    size: iconSize ?? responsiveUI.own(0.05),
                  ),
                if (content != null) content!,
              ],
            ),
          ),
        ),
      ),
    );

    if (tooltipMsg != null) {
      return Tooltip(
        message: tooltipMsg,
        child: contentWidget,
      );
    }

    return contentWidget;
  }
}
