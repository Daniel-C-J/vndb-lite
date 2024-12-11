import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

class CustomDialogButton extends StatelessWidget {
  const CustomDialogButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.textColor,
    this.textShadow,
    this.padding,
    this.leading,
    this.additionalWidget,
    this.forceShadow,
  });

  final String text;
  final Color color;
  final Color? textColor;
  final List<Shadow>? textShadow;
  final Widget? leading;
  final void Function() onPressed;
  final EdgeInsetsGeometry? padding;
  final Widget? additionalWidget;
  final bool? forceShadow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(responsiveUI.own(0.01)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: color,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onPressed,
            child: Container(
              padding: padding ??
                  EdgeInsets.symmetric(
                    vertical: responsiveUI.own(0.025),
                    horizontal: responsiveUI.own(0.04),
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leading ?? const SizedBox.shrink(),
                  additionalWidget ??
                      ShadowText(
                        text,
                        color: textColor,
                        fontSize: responsiveUI.normalSize,
                        shadows: (textColor == Colors.white || textColor == null) ? textShadow : [],
                        forceShadow: textColor == App.themeColor.tertiary,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
