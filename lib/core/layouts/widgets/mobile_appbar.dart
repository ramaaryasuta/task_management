import 'package:flutter/material.dart';

import '../../../components/app_logo.dart';
import '../../extensions/color_theme_extension.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MobileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      scrolledUnderElevation: 1,
      shadowColor: context.outlineColor,
      titleSpacing: 16,
      title: const AppLogo(),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: context.primaryColor),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.add, color: context.primaryColor),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
