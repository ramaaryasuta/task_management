import 'package:flutter/material.dart';

import '../../../../core/extensions/color_theme_extension.dart';
import '../widgets/agenda_view.dart';
import '../widgets/calendar_view.dart';
import '../widgets/topbar_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollCtrl,
      child: Column(
        children: [
          const TopBarCalendarView(),
          Divider(color: context.outlineVariantColor, height: 0),
          Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  if (maxWidth < 600) {
                    return const Column(
                      crossAxisAlignment: .start,
                      children: [CalendarTabelView(), Divider(), AgendaView()],
                    );
                  }

                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: CalendarTabelView()),
                      Expanded(flex: 3, child: AgendaView()),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
