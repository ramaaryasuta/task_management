class CalendarState {
  final DateTime focusedDay;
  final DateTime selectedDay;

  const CalendarState({required this.focusedDay, required this.selectedDay});

  CalendarState copyWith({DateTime? focusedDay, DateTime? selectedDay}) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}
