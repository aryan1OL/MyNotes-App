

import 'package:hive_ce/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject{
  final int? id;

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String date;

  @HiveField(3,defaultValue:false)
  final bool isFavorite;

  Note({
    this.id,
  required this.title,
  required this.description,
  required this.date,
  this.isFavorite = false,
  });

  Note copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    bool? isFavorite,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'date': date,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}