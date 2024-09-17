import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedNumber extends StatelessWidget {
  final int targetNumber;
  final Duration duration;

  const AnimatedNumber({
    Key? key,
    required this.targetNumber,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetNumber),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          '$value',
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
