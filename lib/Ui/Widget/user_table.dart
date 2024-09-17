import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Widget/delete_woring.dart';
import '../../Ui/Widget/update_user.dart';
import '../../models/user.dart';

class UsersTable extends StatelessWidget {
  final List<User> users;

  const UsersTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find();
    // log('users -> $users');
    return (users.isEmpty)
        ? Center(
            child: SizedBox(
              height: 300.h,
              width: 600.h,
              child: Lottie.asset('assets/json/nodata.json'),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                    width: 100.w,
                    child: const Text('رقم الهوية'),
                  ),
                ),
                const DataColumn(label: Text('الأسم')),
                const DataColumn(label: Text('الصلاحيات')),
                const DataColumn(
                    label: Align(
                        alignment: Alignment.center,
                        child: Center(child: Text('       تعديل'))))
              ],
              rows: users.map((user) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 20.w,
                        child: Text(
                          '${users.indexOf(user) + 1}',
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
                          '${user.id}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    )),
                    DataCell(SizedBox(
                      width: 300.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          user.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    )),
                    DataCell(Text(
                      user.auth,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp),
                    )),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              usersController.initData(user);
                              Get.dialog(UpdateUser(
                                user: user,
                              ));
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            )),
                        SizedBox(
                          width: 5.w,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.dialog(DeleteWoring(
                                id: user.id,
                              ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ))
                  ],
                );
              }).toList(),
            ),
          );
  }
}
