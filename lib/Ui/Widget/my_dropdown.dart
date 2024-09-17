import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDropdown extends StatelessWidget {
  const MyDropdown(
      {super.key,
      required this.lable,
      required this.itemsList,
      required this.onchanged,
      required this.value,
      required this.validator,
      this.fontSize,
      this.hint});
  final String lable;
  final String? value;
  final String? hint;
  final List<String> itemsList;
  final void Function(String?) onchanged;
  final String? Function(String?)? validator;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            lable,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w800, fontSize: 22.sp),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButtonFormField<String>(
            hint: Text(hint ?? ''),
            style:
                (fontSize != null) ? TextStyle(fontSize: fontSize?.sp) : null,
            validator: validator,
            value: value,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: itemsList
                .map((type) => DropdownMenuItem(
                      alignment: Alignment.centerRight,
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: onchanged,
          ),
        ),
      ],
    );
  }
}
