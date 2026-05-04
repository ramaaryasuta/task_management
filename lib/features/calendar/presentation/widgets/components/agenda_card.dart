import 'package:flutter/material.dart';

import '../../../../../components/color_picker.dart';
import '../../../../../core/extensions/text_theme_extension.dart';
import '../../../../../utils/date_formatting.dart';
import '../../../domain/entities/calender_event.dart';

class AgendaCard extends StatelessWidget {
  const AgendaCard({
    super.key,
    required this.event,
    required this.useBottomMargin,
  });

  final CalenderEvent event;
  final bool useBottomMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: EdgeInsets.only(bottom: useBottomMargin ? 0 : 10),
      decoration: BoxDecoration(
        color: hexToColor(event.colorCode).withValues(alpha: .2),
        border: Border.all(color: hexToColor(event.colorCode)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: .start,
              children: [
                Text(
                  event.title,
                  style: context.bodyMediumTextStyle!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  event.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmallTextStyle,
                ),
              ],
            ),
          ),
          Text(
            DateTimeHelper.timeToH24(
              TimeOfDay(
                hour: event.dateEvent.hour,
                minute: event.dateEvent.minute,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
