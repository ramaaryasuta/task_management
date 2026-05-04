import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/extensions/color_theme_extension.dart';
import '../../../../core/extensions/text_theme_extension.dart';
import '../../../../utils/utils.dart';
import '../../domain/entities/calender_event.dart';
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
              return isSameDay(state.selectedDay, day);
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

            eventLoader: (day) {
              final key = DateTime(day.year, day.month, day.day);
              return state.events[key] ?? [];
            },

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return const SizedBox.shrink();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.take(3).map((e) {
                    final event = e as CalenderEvent;
                    return Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: hexColor(event.colorCode),
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
