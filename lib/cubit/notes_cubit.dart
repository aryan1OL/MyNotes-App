import 'package:my_notes/cubit/notes_state.dart';
import 'package:my_notes/database/NotesDatabase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/database/NotesHiveDatabase.dart';
import 'package:my_notes/database/Notes_Repository.dart';
import 'package:my_notes/model/note_model.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesRepository _repo;
  NotesCubit(this._repo) : super(NotesInitial());

  Future<void> loadNotes() async {
    emit(NotesLoading());
    try {
      final List<Map<String, Object?>> notes = await _repo.getNotes();
      final convertedNotes = notes.map((row)=>NoteData.fromMap(row)).toList();
      emit(NotesLoaded(convertedNotes));
    } catch (_) {
      emit(NotesError('Could not load notes'));
    }
  }

  Future<void> addNotes(String title, String description) async {
    final current = state;
    if (current is! NotesLoaded) return;

    if (title.trim().isEmpty) {
      emit(NotesLoaded(current.notes, message: 'Title cannot be empty'));
      return;
    }

    final now = DateTime.now();
    String date='${now.day}-${now.month}-${now.year}';

    try {
      int id=await _repo.insertNote(
        title.trim(),
        description.trim(),
        date,
      );
      emit(NotesLoaded([NoteData(
        id:id,
      title: title.trim(),
        description: description.trim(),
        date: date,
      ), ...current.notes]));
    } catch (_) {
      emit(NotesLoaded(current.notes, message: 'add note failed'));
    }
  }

  Future<void> deleteNotes(int id) async {
    final current = state;
    if (current is! NotesLoaded) return;

    final newList = current.notes.where((n) => n.id != id).toList();

    try {
      await _repo.deleteNote(id);
      emit(NotesLoaded(newList, message: 'Note Deleted Successfully'));
    } catch (_) {
      emit(NotesLoaded(current.notes, message: 'Note not deleted'));
    }
  }

  Future<void> toggleFavorite(int id) async {
    final current = state;
    if (current is! NotesLoaded) return;

    final NoteData currentNote = current.notes.firstWhere((n) => n.id == id);

    bool newFavoriteState = !currentNote.isFavorite;

    final newList = current.notes
        .map(
          (n) => n.id == id ? n.copyNote(isFavourite: newFavoriteState) : n,
        )
        .toList();

    try {
      await _repo.updateFavorite(id, newFavoriteState);
      if (newFavoriteState) {
        emit(NotesLoaded(newList, message: 'Added to favorite'));
      } else {
        emit(NotesLoaded(newList, message: 'removed from favorite'));
      }
    } catch (_) {
      emit(NotesLoaded(current.notes, message: 'Note not added to favorite'));
    }
  }

  Future<void> updateNote(int id,String title,String description) async {
    final current = state;
    if (current is! NotesLoaded) return;
    if (title.trim().isEmpty) {
      emit(NotesLoaded(current.notes, message: 'Title cannot be empty'));
      return;
    }
    final now = DateTime.now();
    String date='${now.day}-${now.month}-${now.year}';

    final trimmedTitle=title.trim();
    final trimmedDescription=description.trim();
    final newList = current.notes
        .map(
          (n) => n.id == id ? n.copyNote(title: trimmedTitle,description: trimmedDescription,date: date) : n,
    )
        .toList();

    try {
      await _repo.updateNote(id, trimmedTitle, trimmedDescription,date );
      emit(NotesLoaded(newList, message: 'Note Update Successfully'));

    } catch (_) {
      emit(NotesLoaded(current.notes, message: 'Note not updated'));
    }
  }
}
