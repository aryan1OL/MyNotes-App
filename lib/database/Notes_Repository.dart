abstract class NotesRepository {
  Future<int> insertNote(String title, String description, String date);
  Future<List<Map<String, Object?>>> getNotes();
  Future<void> deleteNote(int id);
  Future<void> updateFavorite(int id, bool isFavorite);
  Future<void> updateNote(int id, String title, String description, String date);
}