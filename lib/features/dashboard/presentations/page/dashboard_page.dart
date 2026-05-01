import 'package:flutter/material.dart';

import '../../../../core/extensions/text_theme_extension.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Dashboard', style: context.labelLargeTextStyle));
  }
}
