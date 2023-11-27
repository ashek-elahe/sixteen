import 'package:flutter/material.dart';

class AnimatedZoomWidget extends StatelessWidget {
  final bool isZoomIn;
  final Size size;
  final Widget child;
  const AnimatedZoomWidget({Key? key, required this.isZoomIn, required this.size, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(seconds: 1);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin:  isZoomIn ? 0 : 1, end: isZoomIn ? 1 : 0),
      duration: duration,
      builder: (context, value, child) {
        return SizedBox(
          height: size.height * value, width: size.width * value,
          child: child!,
        );
      },
      child: child,
    );
  }
}