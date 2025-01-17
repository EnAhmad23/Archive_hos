import 'package:flutter/material.dart';

class Mycheckbox extends StatelessWidget {
  const Mycheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
