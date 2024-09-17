import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Consts/consts.dart';

// ignore: must_be_immutable
class MyTextFormField extends StatelessWidget {
  MyTextFormField({
    super.key,
    required this.labelText,
    this.obscureText,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.fontSize,
    this.inputFormatters,
    this.onTap,
    this.readOnly,
    this.lableColor,
  });
  final String labelText;
  final TextInputType? keyboardType;
  final String hintText;
  final bool? readOnly;
  final Color? lableColor;
  String? Function(String?)? validator;
  final TextEditingController controller;

  bool? obscureText;
  double? fontSize;
  final List<TextInputFormatter>? inputFormatters;
  Future Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            labelText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color:
                    (lableColor == null) ? Consts.backgroundColor : lableColor,
                fontSize: 22.sp),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            readOnly: readOnly ?? false,
            onTap: onTap,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType ?? TextInputType.text,
            validator: validator,
            controller: controller,
            obscureText: obscureText ?? false,
            style: TextStyle(
                fontSize: fontSize ?? 20.sp,
                color: lableColor ?? Consts.backgroundColor),
            decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.red, // Change the color of the error message
                  fontSize: 18.sp, // Change the font size of the error message
                  fontWeight: FontWeight.bold, // Change the font weight
                ),
                border: const OutlineInputBorder(),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 18.sp,
                    color: lableColor ?? Consts.backgroundColor)),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
