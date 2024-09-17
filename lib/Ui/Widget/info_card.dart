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
            EdgeInsets.only(top: 20.h, bottom: 30.h, left: 20.w, right: 40.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  icon,
                  width: 55.w,
                  // ignore: deprecated_member_use
                  color: Consts.backgroundColor,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
                ),
              ),
              Align(alignment: Alignment.bottomCenter, child: subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
