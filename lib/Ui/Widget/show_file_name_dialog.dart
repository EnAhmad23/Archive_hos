import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_2/Controllers/file_controller.dart';
import 'package:test_2/Ui/Widget/my_button.dart';

class FileNameDialog extends StatelessWidget {
  const FileNameDialog({super.key, required this.onTap});

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    FileController fileController = FileController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('ادخل اسم الملف'),
        content: Form(
          key: fileController.fromKey,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الرجاء ادخال اسم الملف';
              }
            },
            controller: fileController.fileNameController,
            decoration: const InputDecoration(hintText: 'ادخل اسم الملف هنا'),
          ),
        ),
        actions: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                  backgroundColor: Colors.green,
                  onPressed: onTap,
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
