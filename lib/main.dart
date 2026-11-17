import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';
import 'package:my_notes/controller/notes_controller.dart';
import 'package:my_notes/views/notes_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  Get.put(NotesController());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('My Notes', style: TextStyle(color: Colors.white)),
        ),
        body: NotesApp(),
      ),
    ),
  );
}




