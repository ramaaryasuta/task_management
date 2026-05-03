import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/color_theme_extension.dart';
import '../extensions/text_theme_extension.dart';
import '../routing/app_routes.dart';
import 'models/navbar_item.dart';
import 'widgets/avatar_profile.dart';
import 'widgets/badge.dart';
import 'widgets/footer.dart';
import 'widgets/mobile_appbar.dart';

const List<String> kNavPaths = [
  AppRoutes.dashboard,
  AppRoutes.calendar,
  // AppRoutes.kanban,
  // AppRoutes.todo,
  // AppRoutes.notes,
];

final List<NavItem> kNavItems = [
  const NavItem(
    label: 'Dashboard',
    icon: Icons.space_dashboard_outlined,
    iconSelected: Icons.space_dashboard,
  ),
  const NavItem(
    label: 'Calendar',
    icon: Icons.calendar_month_outlined,
    iconSelected: Icons.calendar_month,
    badgeCount: 6,
  ),
  // const NavItem(
  //   label: 'Kanban',
  //   icon: Icons.view_kanban_outlined,
  //   iconSelected: Icons.view_kanban,
  //   badgeCount: 12,
  // ),
  // const NavItem(
  //   label: 'Todo',
  //   icon: Icons.check_circle_outline,
  //   iconSelected: Icons.check_circle,
  // ),
  // const NavItem(
  //   label: 'Notes',
  //   icon: Icons.sticky_note_2_outlined,
  //   iconSelected: Icons.sticky_note_2,
  // ),
];

class AdaptiveNavigationShell extends StatelessWidget {
  final Widget child;

  const AdaptiveNavigationShell({super.key, required this.child});

  // Hitung index aktif dari current location
  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = kNavPaths.indexWhere((path) => location.startsWith(path));
    return index < 0 ? 0 : index;
  }

  // Navigasi saat item dipilih
  void _onDestinationSelected(BuildContext context, int index) {
    context.go(kNavPaths[index]);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= 900) {
          return _DesktopLayout(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => _onDestinationSelected(context, i),
            child: child,
          );
        } else if (width >= 600) {
          return _TabletLayout(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => _onDestinationSelected(context, i),
            child: child,
          );
        } else {
          return _MobileLayout(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => _onDestinationSelected(context, i),
            child: child,
          );
        }
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const _DesktopLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: Row(
        children: [
          _ExpandedSidebar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          // Divider line
          Container(width: 1, color: context.outlineVariantColor),
          // Main content
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ExpandedSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _ExpandedSidebar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: context.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Workspace header
          _SidebarHeader(),

          const SizedBox(height: 8),

          // ── Main nav section
          const _SectionLabel('Menu'),
          ...List.generate(kNavItems.length, (i) {
            final item = kNavItems[i];
            return _SidebarNavItem(
              item: item,
              isSelected: selectedIndex == i,
              onTap: () => onDestinationSelected(i),
            );
          }),

          const SizedBox(height: 8),

          // // ── Quick access section
          // _SectionLabel('Quick access'),
          // _SidebarNavItem(
          //   item: const NavItem(
          //     label: 'Pinned',
          //     icon: Icons.push_pin_outlined,
          //     iconSelected: Icons.push_pin,
          //   ),
          //   isSelected: false,
          //   onTap: () {},
          // ),
          // _SidebarNavItem(
          //   item: const NavItem(
          //     label: 'Trash',
          //     icon: Icons.delete_outline,
          //     iconSelected: Icons.delete,
          //   ),
          //   isSelected: false,
          //   onTap: () {},
          // ),
          const Spacer(),

          // ── User profile footer
          const SidebarFooter(),
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const _TabletLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: Row(
        children: [
          _CompactRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          Container(width: 1, color: context.outlineVariantColor),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _CompactRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _CompactRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      color: context.surfaceColor,
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Logo mark
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'V',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nav icons
          ...List.generate(kNavItems.length, (i) {
            final item = kNavItems[i];
            final isSelected = selectedIndex == i;
            return Tooltip(
              message: item.label,
              preferBelow: false,
              child: GestureDetector(
                onTap: () => onDestinationSelected(i),
                child: Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.primaryContainerColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        isSelected ? item.iconSelected : item.icon,
                        size: 20,
                        color: isSelected
                            ? context.primaryColor
                            : context.secondaryColor,
                      ),
                      if (item.badgeCount != null)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: MBadge(count: item.badgeCount!),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // Avatar
          const AvatarProfile(initials: 'AR', size: 32),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const _MobileLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MobileAppBar(title: kNavItems[selectedIndex].label),
      body: child,
      bottomNavigationBar: _AppBottomNavBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class _AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _AppBottomNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: context.outlineVariantColor, width: 1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: Colors.white,
        indicatorColor: context.primaryContainerColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: kNavItems.map((item) {
          return NavigationDestination(
            icon: Badge(
              isLabelVisible: item.badgeCount != null,
              label: item.badgeCount != null
                  ? Text('${item.badgeCount}')
                  : null,
              child: Icon(item.icon, color: context.secondaryColor),
            ),
            selectedIcon: Badge(
              isLabelVisible: item.badgeCount != null,
              label: item.badgeCount != null
                  ? Text('${item.badgeCount}')
                  : null,
              child: Icon(item.iconSelected, color: context.primaryColor),
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SIDEBAR SUB-WIDGETS
// ─────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.outlineVariantColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo mark
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
            child: const Text(
              'V',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vyne',
                style: context.labelMediumTextStyle!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.onSurfaceColor,
                ),
              ),
              Text(
                'Personal workspace',
                style: context.labelSmallTextStyle!.copyWith(
                  color: context.tertiaryColor,
                ),
              ),
            ],
          ),
          // const Spacer(),
          // Icon(Icons.unfold_more, size: 16, color: context.tertiaryColor),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: context.labelSmallTextStyle!.copyWith(
          fontWeight: FontWeight.w500,
          color: context.tertiaryColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? context.primaryContainerColor
                : context.surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? item.iconSelected : item.icon,
                size: 17,
                color: isSelected
                    ? context.primaryColor
                    : context.secondaryColor,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  item.label,
                  style: context.bodySmallTextStyle!.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? context.onSurfaceColor
                        : context.secondaryColor,
                  ),
                ),
              ),
              if (item.badgeCount != null) MBadge(count: item.badgeCount!),
            ],
          ),
        ),
      ),
    );
  }
}
