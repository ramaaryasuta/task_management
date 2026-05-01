import 'package:flutter/material.dart';

import '../../extensions/color_theme_extension.dart';
import '../../extensions/text_theme_extension.dart';

class MBadge extends StatelessWidget {
  final int count;
  const MBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: context.labelSmallTextStyle!.copyWith(
          color: context.onPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
