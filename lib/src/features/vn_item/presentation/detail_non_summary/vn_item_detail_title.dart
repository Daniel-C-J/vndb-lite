import 'package:flutter/material.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

class VnItemDetailTitle extends StatelessWidget {
  const VnItemDetailTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0),
              offset: Offset(0, 30),
              spreadRadius: 20,
              blurRadius: 35,
            ),
          ],
        ),
        child: Text(
          title,
          maxLines: 2,
          softWrap: true,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: styleText(
            fontSize: responsiveUI.normalSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
