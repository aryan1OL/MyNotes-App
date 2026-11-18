import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_notes/cubit/notes_cubit.dart';
import 'package:my_notes/database/NotesDatabase.dart';
import 'package:my_notes/views/notes_page.dart';

void main() {
  runApp(
    BlocProvider(create:(_)=> NotesCubit(NotesDatabase())..loadNotes()
    ,
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('My Notes', style: TextStyle(color: Colors.white)),
        ),
        body: NotesApp(),
      ),
    ),),
  );
}




