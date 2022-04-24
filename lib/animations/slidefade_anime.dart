import 'package:flutter/material.dart';

class SlideFadeContainer extends StatefulWidget {
  const SlideFadeContainer({
    Key? key,
    this.radius = 60,
    this.fullWidth = 150,
    this.color = Colors.amber,
    this.child,
  }) : super(key: key);
  final double radius;
  final MaterialColor color;
  final double fullWidth;
  final Widget? child;
  @override
  State<SlideFadeContainer> createState() => _SlideFadeContainerState(
        radius: radius,
        fullWidth: fullWidth,
        color: color,
      );
}

class _SlideFadeContainerState extends State<SlideFadeContainer>
    with SingleTickerProviderStateMixin {
  _SlideFadeContainerState({
    this.radius = 60,
    this.fullWidth = 150,
    this.color = Colors.amber,
    this.child,
  }) : super();
  final double radius;
  final MaterialColor color;
  final double fullWidth;
  final Widget? child;

  late AnimationController controller;
  late Animation<double> animation;
  late CurvedAnimation curvedAnimation;
  bool isCompleted = false;
  bool visible = false;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
        Tween<double>(begin: radius, end: fullWidth).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        IconButton(
          icon: Icon(Icons.search),
          splashRadius: 25,
          onPressed: () {
            if (isCompleted) {
              controller.reverse();
              isCompleted = false;
              visible = false;
            } else {
              controller.forward();
              isCompleted = true;
              visible = true;
            }
          },
        ),
        AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: color,
            ),
            width: animation.value,
            height: radius,
            child: child,
          ),
        ),
      ],
    );
  }
}
