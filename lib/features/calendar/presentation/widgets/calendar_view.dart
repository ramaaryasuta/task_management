import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/extensions/color_theme_extension.dart';
import '../../../../core/extensions/text_theme_extension.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_event.dart';
import '../bloc/calendar_state.dart';

class CalendarTabelView extends StatelessWidget {
  const CalendarTabelView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: TableCalendar(
            pageAnimationEnabled: false,
            pageJumpingEnabled: false,
            availableGestures: AvailableGestures.none,
            headerVisible: false,
            currentDay: DateTime.now(),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: state.focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(state.focusedDay, day);
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              selectedDecoration: BoxDecoration(
                color: context.primaryColor,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: context.bodyMediumTextStyle!.copyWith(
                color: context.onPrimaryColor,
                fontWeight: FontWeight.w600,
              ),

              todayDecoration: BoxDecoration(
                border: Border.all(color: context.primaryColor, width: 2),
                shape: BoxShape.circle,
              ),
              todayTextStyle: context.bodyMediumTextStyle!.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            onDaySelected: (selectedDate, focusDate) {
              context.read<CalendarBloc>().add(
                SelectDateEvent(selectedDate, focusDate),
              );
            },
          ),
        );
      },
    );
  }
}
