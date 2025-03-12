import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/file_controller.dart';
import '../../Controllers/patients_controller.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/update_file.dart';

import '../../models/file.dart';

class FileTable extends StatelessWidget {
  final List<AppFile> files;
  final int? index;
  const FileTable({super.key, required this.files, this.index});

  @override
  Widget build(BuildContext context) {
    FileController fileController = Get.find();
    PatientsController patientController = Get.find();
    UsersController usersController = Get.find();
    log('files -> $files');
    return (files.isEmpty)
        ? Center(
            child: SizedBox(
              height: 300.h,
              width: 600.h,
              child: Lottie.asset('assets/json/nodata.json'),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Card(
              elevation: 1,
              child: DataTable(
                showBottomBorder: true,
                border: const TableBorder(
                  // verticalInside: BorderSide(color: Colors.black),
                  horizontalInside: BorderSide(
                    color:
                        Colors.white, // Change the color of horizontal dividers
                    width: 2.0, // Thickness of horizontal dividers
                  ),
                ),
                headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.white,
                ),
                dataRowColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.grey.shade100,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                columns: [
                  DataColumn(
                      label: SizedBox(
                    width: 20.w,
                    child: const Text('#'),
                  )),
                  DataColumn(
                      label: SizedBox(
                          width: 85.w, child: const Text('رقم الملف'))),
                  DataColumn(
                    label: SizedBox(
                      width: 100.w,
                      child: const Text('رقم الهوية'),
                    ),
                  ),
                  const DataColumn(label: Text('الأسم')),
                  const DataColumn(label: Text('الفئة')),
                  DataColumn(
                      label: SizedBox(
                          width: 100.w, child: const Text('اسم المدخل'))),
                  DataColumn(
                      label:
                          SizedBox(width: 100.w, child: const Text('التاريخ'))),
                  DataColumn(
                      label: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: 50.w, child: const Text('تعديل'))))
                ],
                rows: files.map((file) {
                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 20.w,
                          child: Text(
                            '${files.indexOf(file) + 1}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                      DataCell(SizedBox(
                        width: 100.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${file.id}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      )),
                      DataCell(Text(
                        '${file.patientId}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      )),
                      DataCell(SizedBox(
                        width: 300.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            file.patientName,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      )),
                      DataCell(Text(
                        file.category,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      )),
                      DataCell(Text(
                        file.userName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      )),
                      DataCell(SizedBox(
                        width: 100.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            file.formattedDate ?? '_',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      )),
                      DataCell(IconButton(
                          onPressed: () {
                            fileController.initData(file);
                            Get.dialog(UpdateFileDialog(
                                temp: file.category,
                                index: index,
                                fileController: fileController,
                                patientController: patientController));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          )))
                    ],
                  );
                }).toList(),
              ),
            ),
          );
  }
}
