import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/button.dart';
import '../../../../core/extensions/color_theme_extension.dart';
import '../../../../core/extensions/text_theme_extension.dart';
import '../../../../utils/date_formatting.dart';
import '../../../../utils/ui_helper.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_state.dart';
import 'components/agenda_card.dart';
import 'dialogs/add_event_dialog.dart';

class AgendaView extends StatelessWidget {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        final normalizeSelectedDate = DateTimeHelper.normalizeDate(
          state.selectedDay,
        );

        final events = state.events[normalizeSelectedDate] ?? [];

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
                DateTimeHelper.formatToDayMonth(state.selectedDay),
                style: context.bodyMediumTextStyle!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Builder(
                builder: (context) {
                  if (events.isEmpty) {
                    return SizedBox(
                      height: screenHeight(context) / 3,
                      child: Center(
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: .end,
                          children: [
                            Icon(
                              Icons.event_note_outlined,
                              color: context.primaryColor,
                            ),
                            Text(
                              'No events',
                              style: context.bodyMediumTextStyle!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  /// if there is events on selected day, show them

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.events[normalizeSelectedDate]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final event = state.events[normalizeSelectedDate]![index];
                      return AgendaCard(
                        event: event,
                        useBottomMargin:
                            index ==
                            (state.events[normalizeSelectedDate]!.length - 1),
                      );
                    },
                  );
                },
              ),

              Builder(
                builder: (context) {
                  if (events.isEmpty) {
                    return Center(
                      child: MElevatedButton(
                        label: 'Add Event',
                        onPressed: () => openAddEventDialog(context),
                      ),
                    );
                  }

                  return InkWell(
                    onTap: () => openAddEventDialog(context),
                    child: DottedBorder(
                      options: RectDottedBorderOptions(
                        padding: const EdgeInsets.all(10),
                        strokeWidth: 1,
                        color: context.outlineVariantColor,
                      ),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: .center,
                        children: [
                          Icon(Icons.add, color: context.primaryColor),
                          Text(
                            'Add New Event',
                            style: context.bodyMediumTextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
