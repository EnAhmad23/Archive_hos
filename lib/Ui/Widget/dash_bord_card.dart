import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashBordCard extends StatelessWidget {
  const DashBordCard({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });
  final String iconAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                height: 60.h,
                width: 60.w,
                child: SvgPicture.asset(iconAsset),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                children: [
                  Text(title),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(subtitle)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
