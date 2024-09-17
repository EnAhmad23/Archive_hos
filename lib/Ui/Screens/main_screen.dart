import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/animated_number.dart';
import '../../Ui/Widget/my_button.dart';

import '../../Controllers/file_controller.dart';
import '../Widget/file_table.dart';
import '../Widget/info_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fileController = Get.find<FileController>();
    final UsersController usersController = Get.find<UsersController>();
    log('${usersController.currentUser}');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            SizedBox(
              height: 250.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio:
                        MediaQuery.of(context).size.width < 1400 ? 1.1 : 1.4,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InfoCard(
                      icon: 'assets/icons/dead.svg',
                      title: 'عدد الشهداء',
                      subtitle: AnimatedNumber(
                        targetNumber: fileController.numOfDeads,
                      ),
                    ),
                    InfoCard(
                      icon: 'assets/icons/injured.svg',
                      title: 'عدد حالات الجرحى',
                      subtitle: AnimatedNumber(
                        targetNumber: fileController.numOfInjured,
                      ),
                    ),
                    InfoCard(
                      icon: 'assets/icons/kids.svg',
                      title: 'عدد حالات الأطفال',
                      subtitle: AnimatedNumber(
                        targetNumber: fileController.numOfKids,
                      ),
                    ),
                    InfoCard(
                      icon: 'assets/icons/woman.svg',
                      title: 'عدد حالات النساء',
                      subtitle: AnimatedNumber(
                        targetNumber: fileController.numOfWoman,
                      ),
                    ),
                    InfoCard(
                      icon: 'assets/icons/cancer.svg',
                      title: 'عدد حالات الأورام',
                      subtitle: AnimatedNumber(
                        targetNumber: fileController.numOfCancer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'اخر عشر ملفات',
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  if (usersController.currentUser!.auths.contains(5))
                    MyButton(
                        onPressed: () => fileController
                            .pickAndReadExcel(usersController.currentUser!),
                        text: 'استيراد ملف')
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GetBuilder<FileController>(builder: (context) {
                    return FileTable(
                      files: fileController.files ?? [],
                      index: 1,
                    );
                  })
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}
