sealed class CalendarEvent {
  const CalendarEvent();
}

class SelectFocusDateEvent extends CalendarEvent {
  final DateTime focusDate;
  const SelectFocusDateEvent(this.focusDate);
}

class SelectDateEvent extends CalendarEvent {
  final DateTime focusDate;
  final DateTime selectedDate;
  const SelectDateEvent(this.focusDate, this.selectedDate);
}
