import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controllers/file_controller.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FileController fileController = Get.find();

    return Scaffold(body: Obx(() {
      log(' lenfth -> ${fileController.numberOfFileOfUsers}');
      if (fileController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                'الإحصائيات',
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'إحصائيات المستخدمين',
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                color: Colors.white,
                elevation: 1,
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                    width: 1200.w,
                    height: 400.h,
                    child: BarChart(
                      duration: const Duration(
                          milliseconds: 500), // Animation duration
                      curve: Curves.easeInOut, // Animation curve
                      BarChartData(
                        barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                                '${(rod.toY)}',
                                TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold));
                          },
                          getTooltipColor: (group) =>
                              Colors.grey[800] ?? const Color(0x00000002),
                        )),
                        backgroundColor: Colors.grey[200],
                        minY: 0,
                        maxY: fileController.maxNum,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(
                            show: true,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey, // Set the border color
                                width: 2.w, // Set the border width
                              ),
                              right: BorderSide(
                                color: Colors.grey, // Set the border color
                                width: 2.w, // Set the border width
                              ),
                            )),
                        barGroups: fileController.numberOfFileOfUsers?.map(
                          (map) {
                            final categoryIndex = fileController
                                .numberOfFileOfUsers!
                                .indexWhere((item) {
                              return item['user_name'] == map['user_name'];
                            });
                            log('Category Index: $categoryIndex'); // Log the index for each bar
                            return BarChartGroupData(
                              x: categoryIndex,
                              barRods: [
                                BarChartRodData(
                                  toY: (map['file_count'] as int).toDouble(),
                                  color: Colors.grey[800],
                                  width: 25.w,
                                  borderRadius: BorderRadius.circular(4.r),

                                  // backDrawRodData: BackgroundBarChartRodData(
                                  //   show: true,
                                  //   color: Colors.white,
                                  //   toY: fileController.maxNum,
                                  // ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 95
                                  .h, // Increase the space reserved for X-axis labels
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (fileController.numberOfFileOfUsers !=
                                        null &&
                                    index <
                                        fileController
                                            .numberOfFileOfUsers!.length) {
                                  final userName = fileController
                                      .numberOfFileOfUsers![index]['user_name'];

                                  // Split the username into lines (you can modify this as per your requirement)
                                  final formattedUserName =
                                      userName.toString().replaceAll(' ', '\n');

                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      formattedUserName,
                                      textAlign: TextAlign
                                          .center, // Center the text vertically
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: const Text(''),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'إحصائيات الفئات',
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                color: Colors.white,
                elevation: 1,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  width: 1200.w,
                  height: 400.h,
                  child: BarChart(
                    duration: const Duration(milliseconds: 150), // Optional
                    curve: Curves.easeInOut,
                    BarChartData(
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Set the border color
                            width: 2.w, // Set the border width
                          ),
                          right: BorderSide(
                            color: Colors.grey, // Set the border color
                            width: 2.w, // Set the border width
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                              '${(rod.toY).toInt()}',
                              TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold));
                        },
                        getTooltipColor: (group) =>
                            Colors.grey[800] ?? const Color(0x00000002),
                      )),
                      // alignment: BarChartAlignment.spaceAround,
                      backgroundColor: Colors.grey[200],
                      minY: 0,
                      maxY: fileController.maxNum + 1,
                      gridData: const FlGridData(show: false),
                      // /  borderData: FlBorderData(show: false),
                      barGroups: fileController.numForCatoger?.map(
                        (map) {
                          final categoryIndex =
                              fileController.numForCatoger!.indexWhere((item) {
                            return item['Category'] == map['Category'];
                          });

                          return BarChartGroupData(
                            x: categoryIndex,
                            barRods: [
                              BarChartRodData(
                                toY: (map['file_count'] as int).toDouble(),
                                color: Colors.grey[800],
                                width: 25.w,
                                borderRadius: BorderRadius.circular(4.r),
                                // backDrawRodData: BackgroundBarChartRodData(
                                //   show: true,
                                //   color: Colors.white,
                                //   toY: fileController.maxNum,
                                // ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                      titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            // axisNameWidget: const Text('الفئات'),
                            sideTitles: SideTitles(
                              reservedSize: 40.sp,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();

                                if (fileController.numForCatoger != null &&
                                    // index >= 0 &&
                                    index <
                                        fileController.numForCatoger!.length) {
                                  final category = fileController
                                      .numForCatoger![index]['Category'];
                                  return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        category.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ));
                                }
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: const Text(''));
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                              // axisNameWidget: const Text('عدد الحالات'),
                              sideTitles: SideTitles(
                            reservedSize: 60.sp,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(meta.formattedValue));
                            },
                          ))),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              )
            ],
          ),
        ),
      );
    }));
  }
}
