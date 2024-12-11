import 'package:flutter/material.dart';

class TransitionListContent extends StatefulWidget {
  const TransitionListContent({super.key, required this.contentList});

  final List<Widget> contentList;

  @override
  State<TransitionListContent> createState() => _TransitionListContentState();
}

class _TransitionListContentState extends State<TransitionListContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..forward();

    _offsetAnimation = _animationController
        .drive(CurveTween(curve: Curves.easeInOut))
        .drive(Tween<Offset>(begin: const Offset(0, -0.25), end: const Offset(0, 0)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _animationController.drive(CurveTween(curve: Curves.easeInToLinear)),
        child: Wrap(children: widget.contentList),
      ),
    );
  }
}
