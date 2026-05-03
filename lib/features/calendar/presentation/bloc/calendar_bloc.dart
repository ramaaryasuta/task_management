import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/calender_event.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalenderEvents, CalendarState> {
  CalendarBloc()
    : super(
        CalendarState(focusedDay: DateTime.now(), selectedDay: DateTime.now()),
      ) {
    on<SelectFocusDateEvent>(_onFocusDateSelected);
    on<SelectDateEvent>(_onDaySelected);
    on<AddCalenderEventEvent>(_onAddEvent);
  }

  void _onFocusDateSelected(
    SelectFocusDateEvent event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(focusedDay: event.focusDate));
  }

  void _onDaySelected(SelectDateEvent event, Emitter<CalendarState> emit) {
    emit(
      state.copyWith(
        focusedDay: event.selectedDate,
        selectedDay: event.selectedDate,
      ),
    );
  }

  void _onAddEvent(AddCalenderEventEvent event, Emitter<CalendarState> emit) {
    // Normalize tanggal — hapus jam/menit agar key-nya konsisten
    final key = DateTime(event.date.year, event.date.month, event.date.day);

    // Salin map lama, tambahkan event baru ke tanggal yang dipilih
    final updatedEvents = Map<DateTime, List<CalenderEvent>>.from(state.events);
    updatedEvents[key] = [...(updatedEvents[key] ?? []), event.event];

    emit(state.copyWith(events: updatedEvents));
  }
}
