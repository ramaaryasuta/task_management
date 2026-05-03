import 'package:equatable/equatable.dart';

class CalenderEvent extends Equatable {
  final int id;
  final String title;
  final String description;
  final String colorCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalenderEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.colorCode,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    colorCode,
    createdAt,
    updatedAt,
  ];

  CalenderEvent copyWith({
    int? id,
    String? title,
    String? description,
    String? colorCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalenderEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      colorCode: colorCode ?? this.colorCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
