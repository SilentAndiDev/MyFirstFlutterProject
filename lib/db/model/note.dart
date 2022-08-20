
import 'package:flutter/services.dart';

final String tableNotes = 'Notes';

class NoteFields{
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';

  static final List<String> value = [
    id, isImportant, number, title, description, title
  ];
}

class Note{
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime
}) => Note(
      id: id ?? this.id,
      isImportant: isImportant ?? this.isImportant,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      createdTime: createdTime ?? this.createdTime
  );

  static Note fromJson(Map<String,Object?> json) => Note(
    id: json[NoteFields.id] as int?,
    number: json[NoteFields.number] as int,
    title: json[NoteFields.title]as String,
    description: json[NoteFields.description] as String,
    createdTime: DateTime.parse(json[NoteFields.time] as String) as DateTime,
    isImportant: json[NoteFields.isImportant] == 1
  );

  Map<String,Object?> toJson() =>{
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.description: description,
    NoteFields.isImportant: isImportant ? 1: 0,
    NoteFields.number: number,
    NoteFields.time: createdTime.toIso8601String()
  };
}

