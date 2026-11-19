import 'package:hive_ce/hive.dart';
import 'package:my_notes/database/notes_repository.dart';
import 'package:my_notes/model/note.dart';

class NotesHiveDatabase implements NotesRepository{

  Box<Note> get _box =>Hive.box<Note>('notes');

  @override
  Future<int> insertNote(String title,String description,String date) async{
    int noteId=await _box.add(Note(title: title, description: description, date: date) );
    return noteId;
  }

  @override
  Future<List<Note>> getNotes() async {
    return _box.values.map((note){
      return note.copyWith(id: note.key as int);
    }).toList();
  }

  @override
  Future<void> deleteNote(int id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateFavorite(int id, bool isFavorite) async {
    Note? oldNote=_box.get(id);
    if(oldNote==null){
      return;
    }

    await _box.put(id,oldNote.copyWith(isFavorite: isFavorite));
  }

  @override
  Future<void> updateNote(int id, String title, String description, String date) async {
    Note? oldNote=_box.get(id);
    if(oldNote==null){
      return;
    }
    await _box.put(id, oldNote.copyWith(title: title,description: description,date: date,));
  }
}