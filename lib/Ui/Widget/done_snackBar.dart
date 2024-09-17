import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;

  const CustomSnackBar({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return GetSnackBar(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      titleText: Text(
        'تم',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 20.sp),
      ),
      maxWidth: 600.w,
      icon: Lottie.asset('assets/json/check.json'),
      backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 10.r,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text(
          'إغلاق',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
