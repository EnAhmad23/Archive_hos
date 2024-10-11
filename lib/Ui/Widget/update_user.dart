import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/login_controllers.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/mycheckbox.dart';
import '../../models/user.dart';

import 'my_button.dart';

class UpdateUser extends StatelessWidget {
  final UsersController usersController = Get.find();
  final User user;
  LoginController loginController = Get.find();
  UpdateUser({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
        child: Container(
          width: 720.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.w,
              ),
              Text(
                'تعديل صلاحيات المستخدم',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 40.h),
              Text(
                'صلاحيات',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: GetBuilder<UsersController>(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Mycheckbox(
                        label: 'شهداء',
                        value: usersController.dead,
                        onChanged: (bool? value) {
                          usersController.changDead(value ?? false);
                        },
                      ),
                      Mycheckbox(
                        label: 'جرحى',
                        value: usersController.injured,
                        onChanged: (bool? value) {
                          usersController.changInjured(value ?? false);
                        },
                      ),
                      Mycheckbox(
                        label: 'أطفال',
                        value: usersController.kids,
                        onChanged: (bool? value) {
                          usersController.changKids(value ?? false);
                        },
                      ),
                      Mycheckbox(
                        label: 'نساء',
                        value: usersController.woman,
                        onChanged: (bool? value) {
                          usersController.changWoman(value ?? false);
                        },
                      ),
                      Mycheckbox(
                        label: 'أورام',
                        value: usersController.cancer,
                        onChanged: (bool? value) {
                          usersController.changCancer(value ?? false);
                        },
                      ),
                      Mycheckbox(
                        label: 'جراحات',
                        value: usersController.surgery,
                        onChanged: (bool? value) {
                          usersController.changSurgery(value ?? false);
                        },
                      ),
                      Mycheckbox(
                        label: 'إعتداء',
                        value: usersController.assault,
                        onChanged: (bool? value) {
                          usersController.changAssault(value ?? false);
                        },
                      ),
                      Mycheckbox(
                        label: 'وفيات',
                        value: usersController.nDead,
                        onChanged: (bool? value) {
                          usersController.changNDead(value ?? false);
                        },
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: 'إلغاء',
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  MyButton(
                    onPressed: () async {
                      usersController.addUpdateAuth();
                      var x = await usersController.updateUser(User(
                          id: user.id,
                          name: user.name,
                          password: user.password,
                          auths: usersController.updateAuth));
                      Get.back();
                      if (x != 0) {
                        Get.showSnackbar(
                          GetSnackBar(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 20.w),
                            titleText: Text(
                              'تم',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                            messageText: Text(
                              'تم تعديل صلاحيات المستخدم بنجاح',
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            maxWidth: 600.w,
                            // title: 'Success',
                            // message: 'File update successfully!',
                            icon: Lottie.asset(
                              'assets/json/check.json',
                            ),
                            backgroundColor: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            borderRadius: 10,
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 3),
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                            mainButton: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'إغلاق',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        );
                        usersController.getUsers();
                        usersController.filterItems('', usersController.users);
                      }
                      // usersController.getUsers();
                      // usersController.filterItems('', usersController.users);
                      // usersController.clearTextFiled();
                      // usersController.clearData();
                    },
                    text: 'تعديل',
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
