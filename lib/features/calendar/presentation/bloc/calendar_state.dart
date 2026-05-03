import '../../domain/entities/calender_event.dart';

class CalendarState {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Map<DateTime, List<CalenderEvent>> events;

  const CalendarState({
    required this.focusedDay,
    required this.selectedDay,
    this.events = const {},
  });

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    Map<DateTime, List<CalenderEvent>>? events,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      events: events ?? this.events,
    );
  }
}
