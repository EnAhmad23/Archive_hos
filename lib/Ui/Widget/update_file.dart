import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../Ui/Widget/myTextFormField.dart';
import '../../Controllers/file_controller.dart';
import '../../Controllers/patients_controller.dart';

import '../../models/file.dart';
import '../../models/patients.dart';
import 'my_dropdown.dart';
import 'my_button.dart';

class UpdateFileDialog extends StatelessWidget {
  final FileController fileController;
  final PatientsController patientController;
  final int? index;
  final String? temp;

  const UpdateFileDialog({
    super.key,
    required this.fileController,
    required this.patientController,
    this.index,
    this.temp,
  });

  @override
  Widget build(BuildContext context) {
    var oldId = int.parse(fileController.idController.text);
    log('old id -> $oldId');
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
        child: SizedBox(
          width: 720.w,
          child: Form(
            key: fileController.fromKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.w,
                ),
                Text(
                  'تعديل ملف',
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  validator: fileController.fileIdValidet,
                  labelText: 'رقم الملف',
                  hintText: 'أدخل رقم الملف',
                  controller: fileController.idController,
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  validator: fileController.patientsIdValidet,
                  labelText: 'رقم الهوية',
                  hintText: 'أدخل رقم الهوية',
                  controller: fileController.patientIdController,
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  validator: fileController.patientNameValidet,
                  labelText: 'اسم المريض',
                  hintText: 'ادخل اسم المريض',
                  controller: fileController.patientNameController,
                ),
                SizedBox(height: 20.h),
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
                SizedBox(height: 10.h),
                GetBuilder<FileController>(builder: (file) {
                  return MyTextFormField(
                    validator: fileController.dateValidet,
                    readOnly: true,
                    labelText: 'التاريخ',
                    hintText: fileController.hintData,
                    controller: fileController.dateController,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      fileController.date = pickedDate;
                      fileController.hintDate = pickedDate.toString();

                      if (pickedDate != null) {
                        fileController.hintDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  );
                }),
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
                        if (fileController.fromKey.currentState!.validate()) {
                          fileController.id =
                              int.tryParse(fileController.idController.text);
                          fileController.patientID = int.tryParse(
                              fileController.patientIdController.text);
                          fileController.patientName =
                              fileController.patientNameController.text;
                          log(fileController.patientName);
                          log(' key -> ${fileController.patientKey}');

                          // fileController.catoger =
                          //     fileController.catogerController.text;
                          var y = await patientController.updatePatient(Patient(
                              id: int.parse(
                                  fileController.patientIdController.text),
                              name: fileController.patientNameController.text,
                              key: fileController.patientKey));
                          log('y -> $y');
                          log('id -> ${fileController.idController.text}');
                          var x = await fileController.updateFile(
                              AppFile(
                                id: oldId,
                                patientKey: fileController.patientKey ?? 0,
                                patientId: int.tryParse(fileController
                                        .patientIdController.text) ??
                                    0,
                                category: fileController.catoger ?? '',
                                date: fileController.date!,
                                patientName:
                                    fileController.patientNameController.text,
                                userName: '',
                              ),
                              int.tryParse(fileController.idController.text) ??
                                  0);
                          log('x -> $x');
                          Get.back();
                          if (x != 0 || y != 0) {
                            log('index -> $index');
                            if (index != null && index == 1) {
                              await fileController.getFiles();
                              fileController.filterItems(
                                  '', fileController.files);
                            } else {
                              switch (fileController.catoger) {
                                case 'شهداء':
                                  await fileController.getDeadsFiles();
                                  await fileController.getNumOfDeads();
                                  fileController.filterItems(
                                      '', fileController.daeds);
                                  break;
                                case 'جرحى':
                                  await fileController.getInjuredFiles();
                                  await fileController.getNumOfInjured();
                                  fileController.filterItems(
                                      '', fileController.injureds);
                                  break;
                                case 'أطفال':
                                  await fileController.getKidsFiles();
                                  await fileController.getNumOfKids();
                                  fileController.filterItems(
                                      '', fileController.kids);
                                  break;
                                case 'نساء':
                                  await fileController.getWomansFiles();
                                  await fileController.getNumOfWoman();
                                  fileController.filterItems(
                                      '', fileController.womans);
                                  break;
                                case 'أورام':
                                  await fileController.getCancerFiles();
                                  await fileController.getNumOfCancer();
                                  fileController.filterItems(
                                      '', fileController.cancers);
                                  break;
                                default:
                              }
                              switch (temp) {
                                case 'شهداء':
                                  await fileController.getDeadsFiles();
                                  await fileController.getNumOfDeads();
                                  fileController.filterItems(
                                      '', fileController.daeds);
                                  break;
                                case 'جرحى':
                                  await fileController.getInjuredFiles();
                                  await fileController.getNumOfInjured();
                                  fileController.filterItems(
                                      '', fileController.injureds);
                                  break;
                                case 'أطفال':
                                  await fileController.getKidsFiles();
                                  await fileController.getNumOfKids();
                                  fileController.filterItems(
                                      '', fileController.kids);
                                  break;
                                case 'نساء':
                                  await fileController.getWomansFiles();
                                  await fileController.getNumOfWoman();
                                  fileController.filterItems(
                                      '', fileController.womans);
                                  break;
                                case 'أورام':
                                  await fileController.getCancerFiles();
                                  await fileController.getNumOfCancer();
                                  fileController.filterItems(
                                      '', fileController.cancers);
                                  break;
                                default:
                              }
                            }
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
                                  'تم حفظ التعديلات',
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                maxWidth: 600.w,
                                title: 'Success',
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
                          }
                          fileController.clearTextFiled();
                          fileController.clearData();
                        }
                      },
                      text: 'حفظ',
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
