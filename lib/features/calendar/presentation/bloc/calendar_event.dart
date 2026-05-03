import '../../domain/entities/calender_event.dart';

sealed class CalenderEvents {
  const CalenderEvents();
}

class SelectFocusDateEvent extends CalenderEvents {
  final DateTime focusDate;
  const SelectFocusDateEvent(this.focusDate);
}

class SelectDateEvent extends CalenderEvents {
  final DateTime focusDate;
  final DateTime selectedDate;
  const SelectDateEvent(this.focusDate, this.selectedDate);
}

class AddCalenderEventEvent extends CalenderEvents {
  final DateTime date;
  final CalenderEvent event;
  const AddCalenderEventEvent({required this.date, required this.event});
}
