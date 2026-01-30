import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:test_2/Ui/Screens/home_screen.dart';
import 'package:test_2/Ui/Widget/show_file_name_dialog.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/animated_number.dart';
import '../../Ui/Widget/my_button.dart';

import '../../Controllers/file_controller.dart';
import '../Widget/Woring.dart';
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
              height: 200.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 20.w,
                    childAspectRatio:
                        MediaQuery.of(context).size.width < 1400 ? 1 : 1.2,
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
                    InfoCard(
                      icon: 'assets/icons/surgery.svg',
                      title: 'عدد حالات الجراحة',
                      subtitle: AnimatedNumber(
                        targetNumber: fileController.numOfCancer,
                      ),
                    ),
                    InfoCard(
                      icon: 'assets/icons/assault.svg',
                      title: 'عدد حالات الإعتداء',
                      subtitle: AnimatedNumber(
                        targetNumber: fileController.numOfCancer,
                      ),
                    ),
                    SizedBox(
                      child: InfoCard(
                        icon: 'assets/icons/dead.svg',
                        title: 'عدد حالات الوفيات',
                        subtitle: AnimatedNumber(
                          targetNumber: fileController.numOfCancer,
                        ),
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
                    Row(
                      children: [
                        MyButton(
                            onPressed: () {
                              Get.dialog(const FileNameDialog());
                            },
                            text: 'تصدير ملف'),
                        SizedBox(
                          width: 10.w,
                        ),
                        MyButton(
                            onPressed: () {
                              Get.dialog(Woring(
                                title:
                                    '''يجب أن يكون الملف من نوع إكسل و ان يكون من 4 أعمدة\n رقم الملف ,رقم الهوية , الأسم  , التاريخ بالترتيب''',
                                operation: 'إستيراد',
                                onTap: () {
                                  fileController.pickAndReadExcel(
                                      usersController.currentUser!,
                                      fileController.catoger);
                                  Get.back();
                                },
                              ));
                            },
                            text: 'استيراد ملف'),
                        SizedBox(
                          width: 10.w,
                        ),
                        MyButton(
                            onPressed: () {
                              String? selectedMonth;
                              Get.dialog(
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title:
                                        const Center(child: Text('إغلاق شهر')),
                                    content: SizedBox(
                                      width: 450.w,
                                      child: FutureBuilder<List<String>>(
                                        future: fileController
                                            .getOpenMonthsWithFiles(),
                                        builder: (context, snapshot) {
                                          final months = snapshot.data ?? [];
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox(
                                              height: 80,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          }

                                          if (months.isEmpty) {
                                            return const Text(
                                              'لا يوجد أشهر مفتوحة لإغلاقها',
                                              textAlign: TextAlign.center,
                                            );
                                          }

                                          selectedMonth ??= months.first;
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  DropdownButtonFormField<
                                                      String>(
                                                    value: selectedMonth,
                                                    items: months
                                                        .map(
                                                          (m) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                            value: m,
                                                            child: Text(m),
                                                          ),
                                                        )
                                                        .toList(),
                                                    onChanged: (value) {
                                                      if (value == null) return;
                                                      setState(() {
                                                        selectedMonth = value;
                                                      });
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'الشهر',
                                                    ),
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  const Text(
                                                    'لن تظهر ملفات هذا الشهر في البحث بعد الإغلاق',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MyButton(
                                              backgroundColor: Colors.green,
                                              onPressed: () async {
                                                if (selectedMonth == null ||
                                                    selectedMonth!.isEmpty) {
                                                  Get.back();
                                                  return;
                                                }
                                                Get.dialog(
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: AlertDialog(
                                                      title: const Center(
                                                          child: Text('تأكيد')),
                                                      content: SizedBox(
                                                        width: 450.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Lottie.asset(
                                                              'assets/json/warning.json',
                                                              height: 120.h,
                                                            ),
                                                            SizedBox(
                                                                height: 10.h),
                                                            Text(
                                                              'هل أنت متأكد من إغلاق شهر ${selectedMonth!} ؟',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              MyButton(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                onPressed:
                                                                    () async {
                                                                  Get.back();
                                                                  await fileController
                                                                      .closeMonthAndRefresh(
                                                                          selectedMonth!);
                                                                  Get.off(
                                                                      HomeScreen());
                                                                },
                                                                text: 'تأكيد',
                                                              ),
                                                              SizedBox(
                                                                  width: 10.w),
                                                              MyButton(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                text: 'إلغاء',
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              text: 'إغلاق',
                                            ),
                                            SizedBox(width: 10.w),
                                            MyButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              text: 'إلغاء',
                                              backgroundColor: Colors.red,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            text: 'إغلاق شهر'),
                      ],
                    )
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
                      // fileController.files != null
                      //     ? fileController.files!.take(10).toList()
                      //     : [],
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
