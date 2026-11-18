class NoteData {
  final int? id;
  final String title;
  final String description;
  final String date;
  final bool isFavorite;

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

  NoteData copyNote({String? title, String? description, bool? isFavourite,String? date}){
    return NoteData(id:id,title: title??this.title, description: description?? this.description, date:date?? this.date,isFavorite: isFavourite??this.isFavorite);
  }
}
