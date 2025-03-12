import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_2/Ui/Widget/add_file.dart';
import 'package:test_2/Ui/Widget/my_button.dart';
import '../../Controllers/file_controller.dart';

class AddFileButton extends StatelessWidget {
  const AddFileButton({
    super.key,
    required this.index,
    required this.fileController,
  });
  final int index;
  final FileController fileController;
  // final FileController fileController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: MyButton(
        onPressed: () {
          fileController.clearTextFiled();
          fileController.clearData();
          fileController.catoger = fileController.catogers[index];
          Get.dialog(AddFileDialog(
            fileController: fileController,
            index: index,
          ));
          // fileController.catoger = fileController.catogers[0];
        },
        text: 'انشاء ملف',
        icon: Icons.insert_drive_file,
      ),
    );
  }
}
