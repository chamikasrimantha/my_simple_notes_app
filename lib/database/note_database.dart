import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

class NoteDatabase {
  static final NoteDatabase _instance = NoteDatabase._internal();
  static Database? _database;

  factory NoteDatabase() {
    return _instance;
  }

  NoteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    // Delete the database if it already exists (for debugging purposes)
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, createdAt TEXT, updatedAt TEXT)',
        );
      },
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<void> insert(Note note) async {
    final db = await database;
    try {
      await db.insert(
        'notes',
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Note added successfully');
    } catch (e) {
      print('Error adding note: $e');
    }
  }


  Future<void> update(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  List<Note> dummyNotes = [
    Note(
      id: 1,
      title: "Grocery List",
      content: "Eggs, Milk, Bread, Butter",
      createdAt: DateTime.parse("2024-11-01T10:00:00Z"),
      updatedAt: DateTime.parse("2024-11-01T10:00:00Z"),
    ),
    Note(
      id: 2,
      title: "Meeting Notes",
      content: "Discuss project timeline and deliverables.",
      createdAt: DateTime.parse("2024-11-02T12:30:00Z"),
      updatedAt: DateTime.parse("2024-11-02T12:30:00Z"),
    ),
    Note(
      id: 3,
      title: "Birthday Party",
      content: "Plan a surprise party for Sarah.",
      createdAt: DateTime.parse("2024-11-03T15:45:00Z"),
      updatedAt: DateTime.parse("2024-11-03T15:45:00Z"),
    ),
  ];

}