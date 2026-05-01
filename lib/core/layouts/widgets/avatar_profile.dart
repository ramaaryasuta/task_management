import 'package:flutter/material.dart';

import '../../extensions/color_theme_extension.dart';

class AvatarProfile extends StatelessWidget {
  final String initials;
  final double size;

  const AvatarProfile({super.key, required this.initials, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.primaryContainerColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w500,
          color: context.primaryColor,
        ),
      ),
    );
  }
}
