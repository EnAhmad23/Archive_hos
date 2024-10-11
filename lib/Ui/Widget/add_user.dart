import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/login_controllers.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/myTextFormField.dart';
import '../../Ui/Widget/mycheckbox.dart';
import '../../models/user.dart';

import 'my_button.dart';

class AddUserDialog extends StatelessWidget {
  final UsersController usersController = Get.find();
  final LoginController loginController = Get.find();
  AddUserDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
        child: Container(
          width: 720.w,
          child: Form(
            key: usersController.fromKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.w,
                ),
                Text(
                  'اضافة مستخدم',
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  validator: usersController.userIdValidet,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  labelText: 'رقم المستخدم',
                  hintText: 'أدخل رقم المستخدم',
                  controller: usersController.idController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  validator: usersController.userNameValidet,
                  labelText: 'اسم المستخدم',
                  hintText: 'أدخل اسم المستخدم',
                  controller: usersController.nameController,
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  obscureText: true,
                  validator: usersController.passwordValidet,
                  labelText: 'كلمة المرور',
                  hintText: 'ادخل كلمة المرور',
                  controller: usersController.passwordController,
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  obscureText: true,
                  validator: usersController.conPasswordValidet,
                  labelText: 'تأكيد كلمة المرور',
                  hintText: 'أعد ادخال كلمة المرور',
                  controller: usersController.conPasswordController,
                ),
                SizedBox(height: 30.h),
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
                        if (usersController.fromKey.currentState!.validate()) {
                          usersController.id =
                              int.tryParse(usersController.idController.text);

                          usersController.name =
                              usersController.nameController.text;
                          usersController.password =
                              usersController.passwordController.text;
                          usersController.addAuth();
                          var x = usersController.addUser(User(
                              id: usersController.id,
                              name: usersController.name,
                              password: usersController.password,
                              auths: usersController.authList));
                          Get.back();
                          if (x != 0) {
                            Get.showSnackbar(
                              GetSnackBar(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 20.w),
                                titleText: Text(
                                  'تم',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                messageText: Text(
                                  'تم اضافة المستخدم بنجاح',
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
                            await usersController.getUsers();
                            await loginController.getIds();
                            await loginController.getUsers();
                            usersController.filterItems(
                                '', usersController.users);
                          }
                          usersController.clearTextFiled();
                          usersController.clearData();
                        }
                      },
                      text: 'اضافة',
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
