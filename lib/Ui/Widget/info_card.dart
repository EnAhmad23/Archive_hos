import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Consts/consts.dart';

class InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final Widget? subtitle;

  const InfoCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        padding:
            EdgeInsets.only(top: 10.h, bottom: 5.h, left: 10.w, right: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.5.h),
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                width: 50.w,
                height: 45.sp,
                // ignore: deprecated_member_use
                color: Consts.backgroundColor,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 10.sp,
              ),
              SizedBox(child: subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
