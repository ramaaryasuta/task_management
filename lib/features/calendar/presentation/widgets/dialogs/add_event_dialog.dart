import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../components/base_dialog.dart';
import '../../../../../components/button.dart';
import '../../../../../components/color_picker.dart';
import '../../../../../components/text_field.dart';
import '../../../../../utils/printlog.dart';
import '../../../domain/entities/calender_event.dart';
import '../../bloc/calendar_bloc.dart';
import '../../bloc/calendar_event.dart';
import '../../bloc/calendar_state.dart';

Future<void> openAddEventDialog(BuildContext context) async {
  showAppDialog(
    context: context,
    title: 'Add Event',
    contentPadding: const EdgeInsets.all(24),
    child: const AddEventForm(),
  );
}

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _hexColor = '#534AB7';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        MTextField(hint: 'Event title', controller: _titleCtrl, label: 'Title'),
        MTextField(
          hint: 'Event description',
          controller: _descCtrl,
          label: 'Description',
          minLines: 4,
          maxLines: 10,
        ),
        MColorPicker(
          label: 'Select Event Color',
          onColorChanged: (hexColor) {
            setState(() => _hexColor = hexColor);
          },
        ),
        BlocSelector<CalendarBloc, CalendarState, DateTime>(
          selector: (state) {
            return state.selectedDay;
          },
          builder: (context, state) {
            return MElevatedButton(
              label: 'Save Event',
              onPressed: () {
                printLog(_hexColor);
                context.read<CalendarBloc>().add(
                  AddCalenderEventEvent(
                    date: state,
                    event: CalenderEvent(
                      id: Random().nextInt(100),
                      title: _titleCtrl.text,
                      description: _descCtrl.text,
                      colorCode: _hexColor,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  ),
                );

                Navigator.pop(context);
              },
            );
          },
        ),
      ],
    );
  }
}
