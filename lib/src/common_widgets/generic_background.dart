import 'package:flutter/material.dart';

class GenericBackground extends StatelessWidget {
  const GenericBackground({
    super.key,
    this.imagePath,
    this.useGradientOverlay = false,
    this.imageWidget,
  });

  final String? imagePath;
  final bool useGradientOverlay;
  final Widget? imageWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: const DecoratedBox(decoration: BoxDecoration(color: Colors.black)),
        ),
        if (imagePath == null && imageWidget != null) imageWidget!,
        if (imagePath != null && imageWidget == null)
          Image.asset(
            imagePath!,
            opacity: const AlwaysStoppedAnimation(0.8),
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          ),
        if (useGradientOverlay)
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color.fromARGB(70, 240, 230, 230), Color.fromARGB(150, 40, 40, 40)],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
