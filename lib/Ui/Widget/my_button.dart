import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Consts/consts.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    required this.text,
    this.icon,
  });

  // final FileController fileController;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        backgroundColor: backgroundColor ?? Consts.backgroundColor,
        foregroundColor: foregroundColor ?? const Color(0xFFfef7ff),
      ), // const Color(0xFFfef7ff)),
      child: (icon != null)
          ? Row(
              children: [
                Icon(icon),
                SizedBox(
                  width: 7.w,
                ),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}
