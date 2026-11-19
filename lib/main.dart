import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_notes/cubit/notes_cubit.dart';
import 'package:my_notes/database/NotesDatabase.dart';
import 'package:my_notes/database/NotesHiveDatabase.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/views/notes_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox('settings');
  runApp(
    BlocProvider(create:(_)=> NotesCubit(NotesHiveDatabase())..loadNotes()
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




