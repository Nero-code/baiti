import 'package:flutter/material.dart';

class SlideContainer extends StatefulWidget {
  const SlideContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<SlideContainer> createState() => _SlideContainerState();
}

class _SlideContainerState extends State<SlideContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation curvedAnimation;
  late final Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = Tween<double>(begin: 0, end: 0).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
