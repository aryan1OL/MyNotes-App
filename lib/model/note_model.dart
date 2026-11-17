class NoteData {
  int? id;
  String title;
  String description;
  String date;
  bool isFavorite;
  NoteData({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isFavorite = false,
  });

  factory NoteData.fromMap(Map<String, Object?> map) {
    return NoteData(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
      isFavorite: map['isFavorite']==0?false:true,
    );
  }
}
