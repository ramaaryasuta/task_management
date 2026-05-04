import 'package:equatable/equatable.dart';

class CalenderEvent extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String colorCode;
  final DateTime dateEvent;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalenderEvent({
    this.id,
    required this.title,
    required this.description,
    required this.colorCode,
    required this.dateEvent,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    colorCode,
    dateEvent,
    createdAt,
    updatedAt,
  ];

  CalenderEvent copyWith({
    int? id,
    String? title,
    String? description,
    String? colorCode,
    DateTime? dateEvent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalenderEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      colorCode: colorCode ?? this.colorCode,
      dateEvent: dateEvent ?? this.dateEvent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
