import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/myTextFormField.dart';
import '../../models/user.dart';
import '../../Controllers/file_controller.dart';
import '../../Controllers/patients_controller.dart';

import '../../models/file.dart';
import '../../models/patients.dart';
import 'my_button.dart';

class AddFileDialog extends StatelessWidget {
  final FileController fileController;
  final PatientsController patientController = Get.find();
  final UsersController usersController = Get.find();
  final int index;

  AddFileDialog({
    super.key,
    required this.fileController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
        child: Container(
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
                  'انشاء ملف جديد',
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: fileController.fileIdValidet,
                  labelText: 'رقم الملف',
                  hintText: 'أدخل رقم الملف',
                  controller: fileController.idController,
                ),
                SizedBox(height: 20.h),
                MyTextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                          fileController.catoger =
                              fileController.catogers[index];
                          patientController.addPatient(Patient(
                            id: fileController.patientID,
                            name: fileController.patientName,
                          ));
                          var x = await fileController.addFile(
                              AppFile(
                                id: fileController.id,
                                patientId: fileController.patientID,
                                category: fileController.catoger!,
                                date: fileController.date!,
                                patientName: fileController.patientName,
                                userName: '',
                              ),
                              usersController.currentUser!);
                          // fileController.getFiles();
                          switch (index) {
                            case 0:
                              await fileController.getDeadsFiles();
                              await fileController.getNumOfDeads();
                              fileController.filterItems(
                                  '', fileController.daeds);
                              break;
                            case 1:
                              await fileController.getInjuredFiles();
                              await fileController.getNumOfInjured();
                              fileController.filterItems(
                                  '', fileController.injureds);
                              break;
                            case 2:
                              await fileController.getKidsFiles();
                              await fileController.getNumOfKids();
                              fileController.filterItems(
                                  '', fileController.kids);
                              break;
                            case 3:
                              await fileController.getWomansFiles();
                              await fileController.getNumOfWoman();
                              fileController.filterItems(
                                  '', fileController.womans);
                              break;
                            case 4:
                              await fileController.getCancerFiles();
                              await fileController.getNumOfCancer();
                              fileController.filterItems(
                                  '', fileController.cancers);
                              break;
                            default:
                              break;
                          }
                          await fileController.getFiles();
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
                                  'تم انشاء الملف',
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
                          }
                          fileController.clearTextFiled();
                          fileController.clearData();
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
