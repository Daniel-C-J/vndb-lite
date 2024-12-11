import 'package:flutter/material.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

class GenericErrorImage extends StatelessWidget {
  const GenericErrorImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: responsiveUI.own(0.02),
        bottom: responsiveUI.own(0.11),
      ),
      margin: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.05)),
      alignment: Alignment.center,
      child: SizedBox(
        width: responsiveUI.own(0.22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              color: Color.fromARGB(255, 200, 50, 35),
              shadows: [Shadow(color: Colors.black, blurRadius: 5)],
            ),
            Text(
              'Error Image',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsiveUI.normalSize,
                color: Colors.red,
                shadows: const [Shadow(color: Colors.black, blurRadius: 5)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
