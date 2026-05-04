import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../components/base_dialog.dart';
import '../../../../../components/button.dart';
import '../../../../../components/color_picker.dart';
import '../../../../../components/text_field.dart';
import '../../../../../components/time_picker.dart';
import '../../../domain/entities/calender_event.dart';
import '../../bloc/calendar_bloc.dart';
import '../../bloc/calendar_event.dart';
import '../../bloc/calendar_state.dart';

Future<void> openAddEventDialog(BuildContext context) async {
  showAppDialog(
    context: context,
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
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _hexColor = '#534AB7';

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CalendarBloc, CalendarState, DateTime>(
      selector: (state) {
        return state.selectedDay;
      },
      builder: (context, stateValue) {
        return Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Add Event',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              MTextField(
                hint: 'Event title',
                controller: _titleCtrl,
                label: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              MTextField(
                hint: 'Event description',
                controller: _descCtrl,
                label: 'Description',
                minLines: 4,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter desc';
                  }
                  return null;
                },
              ),
              MTimePicker(
                initialTime: _selectedTime,
                label: 'Select Event Time',
                onTimeChanged: (time, _) {
                  setState(() {
                    _selectedTime = time;
                  });
                },
              ),
              MColorPicker(
                label: 'Select Event Color',
                onColorChanged: (hexColor) {
                  setState(() => _hexColor = hexColor);
                },
              ),
              MElevatedButton(
                label: 'Save Event',
                onPressed: () {
                  if (_formKey.currentState?.validate() == false) return;

                  context.read<CalendarBloc>().add(
                    AddCalenderEventEvent(
                      date: stateValue,
                      event: CalenderEvent(
                        title: _titleCtrl.text,
                        description: _descCtrl.text,
                        colorCode: _hexColor,
                        dateEvent: DateTime(
                          stateValue.year,
                          stateValue.month,
                          stateValue.day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                        ),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
