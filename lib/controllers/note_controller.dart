import '../models/note_model.dart';
import '../database/note_database.dart';

class NoteController {
  final NoteDatabase _noteDatabase = NoteDatabase();

  Future<List<Note>> getNotes() async {
    return await _noteDatabase.getNotes();
  }

  Future<void> addNote(Note note) async {
    await _noteDatabase.insert(note);
  }

  Future<void> updateNote(Note note) async {
    await _noteDatabase.update(note);
  }

  Future<void> deleteNote(int id) async {
    await _noteDatabase.delete(id);
  }
}
