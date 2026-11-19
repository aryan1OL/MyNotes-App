

import 'package:hive_ce/hive.dart';
import 'package:my_notes/database/Notes_Repository.dart';
import 'package:my_notes/model/note.dart';

class NotesHiveDatabase implements NotesRepository{

  Box<Note> get _box =>Hive.box<Note>('notes');

  Future<int> insertNote(String title,String description,String date) async{
    int noteId=await _box.add(Note(title: title, description: description, date: date) );
    return noteId;
  }

  Future<List<Map<String, Object?>>> getNotes() async {
    return _box.values.map((note)=>{
      'id': note.key,
      'title': note.title,
      'description': note.description,
      'date': note.date,
      'isFavorite': note.isFavorite ? 1 : 0,
    }).toList();
  }

  Future<void> deleteNote(int id) async {
    await _box.delete(id);
  }
  Future<void> updateFavorite(int id, bool isFavorite) async {
    Note? oldNote=_box.get(id);
    if(oldNote==null){
      return;
    }

    await _box.put(id,Note(title: oldNote.title, description: oldNote.description, date: oldNote.date,isFavorite: isFavorite));
  }

  Future<void> updateNote(int id, String title, String description, String date) async {
    Note? oldNote=_box.get(id);
    if(oldNote==null){
      return;
    }
    await _box.put(id, Note(title: title, description: description, date: date,isFavorite: oldNote.isFavorite));

  }
}