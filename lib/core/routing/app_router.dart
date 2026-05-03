import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/dashboard/presentation/page/dashboard_page.dart';
import '../layouts/base_layout.dart';
import '../layouts/not_found_page.dart';
import 'app_routes.dart';

final appRoute = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AdaptiveNavigationShell(child: child);
      },
      routes: [
        // Dashboard
        GoRoute(
          path: AppRoutes.dashboard,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardPage()),
        ),

        // Calendar
        GoRoute(
          path: AppRoutes.calendar,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CalendarPage()),
        ),
      ],
    ),
  ],

  // Redirect: if user go to '/' redirect to '/dashboard'
  redirect: (context, state) {
    if (state.uri.toString() == '/') return AppRoutes.dashboard;
    return null;
  },

  // Error page if route not found
  errorBuilder: (context, state) => const NotFoundPage(),
);
