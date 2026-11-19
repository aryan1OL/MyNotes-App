
import 'package:my_notes/model/note.dart';

sealed class NotesState {}

class NotesInitial extends NotesState{}

class NotesLoading extends NotesState{}

class NotesLoaded extends NotesState{
  final List<Note> notes;
  final String? message;

  NotesLoaded(this.notes,{this.message});
}

class NotesError extends NotesState{
  final String message;
  NotesError(this.message);
}