// import 'package:get/get.dart';
// import 'package:my_notes/database/NotesDatabase.dart';
// import 'package:my_notes/model/note_model.dart';
// import 'package:my_notes/widget/note_card.dart';
//
// class NotesController extends GetxController {
//   final notesList = <NoteData>[].obs;
//
//   @override
//   void onInit(){
//     super.onInit();
//     loadNotes();
//   }
//
//   //done
//   Future<void> loadNotes() async {
//     List<Map<String, Object?>> rows=await NotesDatabase.getNotes();
//     final convertedNotes = rows.map((row)=>NoteData.fromMap(row)).toList();
//     notesList.assignAll(convertedNotes);
//   }
//
//   //done
//   Future<void> addNote(
//       String title,
//       String description,
//       String date,
//       ) async {
//     if (title.trim().isEmpty || description.trim().isEmpty) {
//       return;
//     }
//
//     int id = await NotesDatabase.insertNote(
//       title.trim(),
//       description.trim(),
//       date,
//     );
//
//     NoteData noteData = NoteData(
//       id: id,
//       title: title.trim(),
//       description: description.trim(),
//       date: date,
//     );
//
//     notesList.add(noteData);
//   }
//
//
//  // done
//   Future<void> deleteNote(int index) async {
//     if (index < 0 || index >= notesList.length) {
//       return;
//     }
//     final note = notesList[index];
//     int? noteId=note.id;
//
//     if (noteId == null) {
//       return;
//     }
//
//     await NotesDatabase.deleteNote(noteId);
//     notesList.remove(note);
//   }
//
//   Future<void> toggleFavorite(int index) async {
//     if (index < 0 || index >= notesList.length) {
//       return;
//     }
//     if(notesList[index].id==null){
//       return;
//     }
//
//     final note = notesList[index];
//     final newFavorite = !note.isFavorite;
//
//     await NotesDatabase.updateFavorite(note.id!, newFavorite);
//     note.isFavorite = newFavorite;
//     notesList.refresh();
//   }
//
//   Future<void> updateNote(String title, String description, String date, int index) async {
//     if (title.trim().isEmpty || description.trim().isEmpty) {
//       return;
//     }
//     if (index < 0 || index >= notesList.length) {
//       return;
//     }
//     final note = notesList[index];
//
//     if(notesList[index].id==null){
//       return;
//     }
//
//     await NotesDatabase.updateNote(note.id!, title.trim(), description.trim(), date);
//
//
//     note.title = title.trim();
//     note.description = description.trim();
//     note.date = date;
//     notesList.refresh();
//   }
// }
