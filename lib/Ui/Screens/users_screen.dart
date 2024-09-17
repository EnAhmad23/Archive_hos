import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/add_user.dart';
import '../../Ui/Widget/user_table.dart';

import '../Widget/file_table.dart';
import '../Widget/my_button.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersController usersController = Get.find<UsersController>();
    final ValueNotifier<String> textFieldValue = ValueNotifier<String>('');

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Text(
            'المستخدمين',
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
                        usersController.filterItems(
                            value, usersController.users);
                      },
                      controller: usersController.searchController,
                      decoration: InputDecoration(
                        suffixIcon: value.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  usersController.searchController.clear();
                                  textFieldValue.value = '';
                                  usersController.filterItems(
                                      '', usersController.users);
                                },
                                icon: Icon(Icons.clear, size: 17.sp),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        hintText: "البحث عن مستخدم",
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
                    // fileController.catoger = fileController.catogers[0];
                    Get.dialog(AddUserDialog());
                  },
                  text: 'إضافة مستخدم',
                  icon: Icons.person,
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          // Wrapping only the FileTable with Obx
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Obx(() {
              if (usersController.filteredItems.isEmpty) {
                return const Column(
                  children: [
                    FileTable(files: []),
                  ],
                );
              }
              return Container(
                  width: double.infinity,
                  child: UsersTable(users: usersController.filteredItems));
            }),
          ),
        ],
      ),
    );
  }
}
