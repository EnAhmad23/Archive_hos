import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:test_2/Controllers/file_controller.dart';
import '../../Controllers/users_controller.dart';
import 'my_dropdown.dart';

class Woring extends StatelessWidget {
  Woring(
      {super.key,
      required this.title,
      required this.operation,
      required this.onTap});
  final UsersController usersController = Get.find();
  final FileController fileController = Get.find();
  final String title;
  final String operation;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(operation, textAlign: TextAlign.center),
        backgroundColor: Colors.white,
        content: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 150.h,
                  width: 250.h,
                  child: Lottie.asset('assets/json/warning.json')),
              SizedBox(
                height: 5.h,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              MyDropdown(
                lable: 'الفئة',
                value: fileController.catoger ?? 'اختر الفئة',
                itemsList: fileController.catogers,
                onchanged: (value) {
                  if (value != null && value != 'اختر الفئة') {
                    fileController.catoger = value;
                    fileController.catogerController.text = value;
                  }
                },
                validator: (value) {
                  if (value == null || value == 'اختر الفئة') {
                    return 'الرجاء اختيار الفئة';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.r)),
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.all(10.w),
                  child: Text(
                    'تأكيد',
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.r)),
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
