import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controllers/login_controllers.dart';
import '../../Controllers/users_controller.dart';
import 'package:flutter/services.dart';

import '../../Consts/consts.dart';
import '../../Controllers/file_controller.dart';
import '../Widget/myTextFormField.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FileController fileController = Get.find<FileController>();
    final LoginController loginController = Get.find<LoginController>();
    final UsersController usersController = Get.find<UsersController>();

    void loginAction() async {
      if (loginController.form.currentState!.validate()) {
        if (loginController.checkUser(loginController.idController.text,
            loginController.passwordController.text)) {
          await usersController
              .getuser(int.parse(loginController.idController.text));
          await usersController.getUsers();
          fileController.getFiles();
          fileController.getInjuredFiles();
          fileController.getKidsFiles();
          fileController.getWomansFiles();
          fileController.getCancerFiles();
          fileController.getDeadsFiles();
          await fileController.getNumOfDeads();
          fileController.getNumOfInjured();
          await fileController.getNumOfWoman();
          fileController.getNumOfCancer();
          await fileController.getNumOfKids();

          Get.to(() => HomeScreen());
        }
      }
    }

    return Scaffold(
      backgroundColor: Consts.backgroundColor,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            loginAction(); // Trigger the login action when Enter is pressed
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400.h,
                  width: 400.w,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: Form(
                      key: loginController.form,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 300.w),
                            child: MyTextFormField(
                              labelText: 'اسم المستخدم',
                              hintText: 'ادخل اسم المستخدم',
                              controller: loginController.idController,
                              lableColor: const Color(0xFFfef7ff),
                              validator: loginController.validUsername,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 300.w),
                            child: MyTextFormField(
                              labelText: 'كلمة المرور',
                              hintText: 'ادخل كلمة المرور',
                              controller: loginController.passwordController,
                              obscureText: true,
                              lableColor: const Color(0xFFfef7ff),
                              validator: loginController.validatePassword,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                            onPressed: loginAction, // Attach the login action
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Consts.backgroundColor,
                            ),
                            child: const Text('تسجيل الدخول'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
