import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/button.dart';
import '../../../../components/color_picker.dart';
import '../../../../core/extensions/color_theme_extension.dart';
import '../../../../core/extensions/text_theme_extension.dart';
import '../../../../utils/date_formatting.dart';
import '../../../../utils/ui_helper.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_state.dart';
import 'dialogs/add_event_dialog.dart';

class AgendaView extends StatelessWidget {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(minHeight: screenHeight(context) - 60),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: context.outlineVariantColor, width: 1),
            ),
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: .start,
            children: [
              Text(
                DateTimeHelper.formatToDayMonth(state.focusedDay),
                style: context.bodyMediumTextStyle!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Builder(
                builder: (context) {
                  if (state.events.isEmpty) {
                    return Center(
                      child: Text(
                        'No events',
                        style: context.bodyMediumTextStyle!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  /// if there is events on selected day, show them

                  final normalizeSelectedDate = DateTimeHelper.normalizeDate(
                    state.selectedDay,
                  );

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.events[normalizeSelectedDate]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final event = state.events[normalizeSelectedDate]![index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        margin: EdgeInsets.only(
                          bottom:
                              index ==
                                  state.events[normalizeSelectedDate]!.length -
                                      1
                              ? 0
                              : 10,
                        ),
                        decoration: BoxDecoration(
                          color: hexToColor(
                            event.colorCode,
                          ).withValues(alpha: .25),
                          border: Border.all(
                            color: hexToColor(event.colorCode),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              event.title,
                              style: context.bodyMediumTextStyle!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(event.description),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              Center(
                child: MElevatedButton(
                  label: 'Add Event',
                  onPressed: () => openAddEventDialog(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
