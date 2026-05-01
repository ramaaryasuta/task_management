import 'package:flutter/material.dart';

import '../../../../core/extensions/text_theme_extension.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Calendar', style: context.labelLargeTextStyle));
  }
}
