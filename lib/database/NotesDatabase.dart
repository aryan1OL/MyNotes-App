import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static Future<int> insertNote(
    String title,
    String description,
    String date,
  ) async {
    final db = await NotesDatabase.openDB();
    return await db.insert('notes', {
      'title': title,
      'description': description,
      'date': date,
      'isFavorite': 0,
    });
  }

  static Future<List<Map<String, Object?>>> getNotes() async {
    final db = await NotesDatabase.openDB();
    return await db.query('notes');
  }

  static Future<void> deleteNote(int id) async {
    final db = await NotesDatabase.openDB();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateFavorite(int id, bool isFavorite) async {
    final db = await NotesDatabase.openDB();
    await db.update(
      'notes',
      {'isFavorite': isFavorite == true ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<void> updateNote(
    int id,
    String title,
    String description,
    String date,
  ) async {
    final db = await NotesDatabase.openDB();

    await db.update(
      'notes',
      {'title': title, 'description': description, 'date': date},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<Database> openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  date TEXT NOT NULL,
  isFavorite INTEGER NOT NULL DEFAULT 0
);''');
      },
    );
  }
}
