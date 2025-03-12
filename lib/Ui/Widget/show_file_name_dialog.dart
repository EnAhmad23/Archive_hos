import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_2/Controllers/file_controller.dart';
import 'package:test_2/Ui/Widget/myTextFormField.dart';
import 'package:test_2/Ui/Widget/my_button.dart';

class FileNameDialog extends StatelessWidget {
  const FileNameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    FileController fileController = FileController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Center(child: Text('تصدير الملف')),
        content: SizedBox(
          height: 150.h,
          child: Form(
            key: fileController.fromKey,
            child: MyTextFormField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء ادخال اسم الملف';
                }
                return null;
              },
              controller: fileController.fileNameController,
              labelText: 'اسم الملف',
              hintText: 'ادخل اسم الملف هنا',
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    log(fileController.fileNameController.text);
                    if (fileController.fromKey.currentState!.validate()) {
                      fileController.exportFileTableToExcel(
                          fileController.fileNameController.text);
                    }
                    Get.back();
                  },
                  text: 'حفظ',
                ),
                SizedBox(
                  width: 10.w,
                ),
                MyButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: 'إلغاء',
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
