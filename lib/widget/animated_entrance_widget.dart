import 'package:flutter/material.dart';

enum Entrance{left, right, top, bottom}

class AnimatedEntranceWidget extends StatelessWidget {
  final Entrance entrance;
  final Widget child;
  const AnimatedEntranceWidget({Key? key, required this.entrance, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(seconds: 1);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: (entrance == Entrance.top || entrance == Entrance.bottom) ? 0.5 : 0, end: 1),
      duration: duration,
      builder: (context, value, child) {
        return Transform(
          transform: Matrix4.translationValues(
            (entrance == Entrance.left ? (value - 1) : entrance == Entrance.right ? (1 - value) : 0) * MediaQuery.of(context).size.width,
            (entrance == Entrance.top ? (value - 1) : entrance == Entrance.bottom ? (1 - value) : 0) * MediaQuery.of(context).size.height, 0,
          ),
          child: child!,
        );
      },
      child: child,
    );
  }
}
