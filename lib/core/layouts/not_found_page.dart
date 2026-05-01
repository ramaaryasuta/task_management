import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_routes.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '404',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text('Page not found'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
