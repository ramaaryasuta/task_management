import 'package:flutter/material.dart';

import '../../extensions/text_theme_extension.dart';

const kPrimary = Color(0xFF534AB7);
const kPrimaryLight = Color(0xFFEEEDFE);
const kPrimaryDark = Color(0xFF3C3489);
const kSurface = Color(0xFFF8F7FC);
const kBorder = Color(0xFFE8E6F0);
const kTextPrimary = Color(0xFF1A1825);
const kTextSecondary = Color(0xFF6E6A85);
const kTextTertiary = Color(0xFFADABBF);

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MobileAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: kBorder,
      titleSpacing: 16,
      title: Text(
        title,
        style: context.bodySmallTextStyle!.copyWith(
          fontWeight: FontWeight.w500,
          color: kTextPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: kTextSecondary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.add, color: kPrimary),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
