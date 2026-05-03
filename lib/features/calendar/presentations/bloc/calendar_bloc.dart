import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
    : super(
        CalendarState(focusedDay: DateTime.now(), selectedDay: DateTime.now()),
      ) {
    on<SelectFocusDateEvent>(_onFocusDateSelected);
    on<SelectDateEvent>(_onDaySelected);
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
}
