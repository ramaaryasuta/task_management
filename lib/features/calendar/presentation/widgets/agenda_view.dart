import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/color_theme_extension.dart';
import '../../../../core/extensions/text_theme_extension.dart';
import '../../../../utils/date_formatting.dart';
import '../../../../utils/ui_helper.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_state.dart';

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
            crossAxisAlignment: .start,
            children: [
              Text(
                DateTimeHelper.formatToDayMonth(state.focusedDay),
                style: context.bodyMediumTextStyle!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
