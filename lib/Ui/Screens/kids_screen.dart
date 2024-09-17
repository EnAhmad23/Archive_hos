import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Controllers/file_controller.dart';
import '../Widget/add_file.dart';
import '../Widget/file_table.dart';
import '../Widget/my_button.dart';

class KidsScreen extends StatelessWidget {
  const KidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FileController fileController = Get.find<FileController>();
    final ValueNotifier<String> textFieldValue = ValueNotifier<String>('');

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Text(
            'ملف الأطفال',
            style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 140.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 300.w,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                // padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ValueListenableBuilder<String>(
                  valueListenable: textFieldValue,
                  builder: (context, value, child) {
                    return TextFormField(
                      onChanged: (value) {
                        textFieldValue.value = value;
                        fileController.filterItems(value, fileController.kids);
                      },
                      controller: fileController.searchController,
                      decoration: InputDecoration(
                        suffixIcon: value.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  fileController.searchController.clear();
                                  textFieldValue.value = '';
                                  fileController.filterItems(
                                      '', fileController.kids);
                                },
                                icon: Icon(Icons.clear, size: 17.sp),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        hintText: "البحث عن ملف",
                        prefixIcon: const Icon(Icons.search),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: MyButton(
                  onPressed: () {
                    Get.dialog(AddFileDialog(
                      fileController: fileController,
                      index: 2,
                    ));
                    // fileController.catoger = fileController.catogers[0];
                  },
                  text: 'انشاء ملف',
                  icon: Icons.insert_drive_file,
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          // Wrapping only the FileTable with Obx
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Obx(() {
              if (fileController.filteredItems.isEmpty) {
                return const Column(
                  children: [
                    FileTable(files: []),
                  ],
                );
              }
              return Container(
                  width: double.infinity,
                  child: FileTable(files: fileController.filteredItems));
            }),
          ),
        ],
      ),
    );
  }
}
