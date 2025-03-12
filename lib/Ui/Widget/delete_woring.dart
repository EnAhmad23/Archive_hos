import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/users_controller.dart';

class DeleteWoring extends StatelessWidget {
  DeleteWoring({super.key, required this.id});
  final UsersController usersController = Get.find();
  final int id;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('حذف', textAlign: TextAlign.center),
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
                'هل متاكد من حذف العنصر؟',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  var x = usersController.deleteUser(id);
                  if (x != 0) {
                    Get.back();
                    Get.showSnackbar(GetSnackBar(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.w),
                      titleText: Text(
                        'تم',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      messageText: Text(
                        'تم حذف العنصر بنجاخ',
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
                    ));
                    await usersController.getUsers();
                    usersController.filterItems('', usersController.users);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.r)),
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.all(10.w),
                  child: Text(
                    'نعم',
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
                    'لا',
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
