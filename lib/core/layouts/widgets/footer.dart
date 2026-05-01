import 'package:flutter/material.dart';

import '../../extensions/color_theme_extension.dart';
import 'avatar_profile.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.outlineVariantColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          const AvatarProfile(initials: 'AR', size: 30),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rama Arya',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.onSurfaceColor,
                  ),
                ),
                Text(
                  'Personal plan',
                  style: TextStyle(fontSize: 10, color: context.outlineColor),
                ),
              ],
            ),
          ),
          Icon(Icons.more_horiz, size: 16, color: context.outlineColor),
        ],
      ),
    );
  }
}
