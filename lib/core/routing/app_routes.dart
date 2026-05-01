class AppRoutes {
  const AppRoutes._();

  static const String dashboard = '/dashboard';
  static const String calendar = '/calendar';
  static const String kanban = '/kanban';
  static const String todo = '/todo';
  static const String notes = '/notes';

  // child routes
  static const String calendarDetail = '/calendar/:id';
}
