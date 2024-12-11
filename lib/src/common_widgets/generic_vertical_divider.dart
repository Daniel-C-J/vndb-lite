import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';

class GenericDivider extends StatelessWidget {
  const GenericDivider({
    super.key,
    this.width = 1,
    this.height = double.infinity,
    this.color,
  });

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (color ?? App.themeColor.tertiary).withOpacity(0.1),
        boxShadow: [
          BoxShadow(color: (color ?? App.themeColor.tertiary).withOpacity(0.8), blurRadius: 5),
        ],
      ),
    );
  }
}
