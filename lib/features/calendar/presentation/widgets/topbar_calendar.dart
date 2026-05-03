import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/color_theme_extension.dart';
import '../../../../core/extensions/text_theme_extension.dart';
import '../../../../utils/date_formatting.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_event.dart';
import '../bloc/calendar_state.dart';

class TopBarCalendarView extends StatelessWidget {
  const TopBarCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                DateTimeHelper.formatToMonthYear(state.focusedDay),
                style: context.titleMediumTextStyle!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  _ArrowMonthButton(
                    icon: Icons.chevron_left,
                    onTap: () {
                      final previousMonth = DateTime(
                        state.focusedDay.year,
                        state.focusedDay.month - 1,
                      );
                      context.read<CalendarBloc>().add(
                        SelectFocusDateEvent(previousMonth),
                      );
                    },
                  ),
                  _ArrowMonthButton(
                    icon: Icons.chevron_right,
                    onTap: () {
                      final nextMonth = DateTime(
                        state.focusedDay.year,
                        state.focusedDay.month + 1,
                      );
                      context.read<CalendarBloc>().add(
                        SelectFocusDateEvent(nextMonth),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArrowMonthButton extends StatelessWidget {
  const _ArrowMonthButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.outlineVariantColor, width: 1),
        ),
        child: Icon(icon, color: context.primaryColor),
      ),
    );
  }
}
