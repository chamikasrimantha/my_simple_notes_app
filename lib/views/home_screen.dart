import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteController _noteController = NoteController();
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final notes = await _noteController.getNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes; // Initially, show all notes
    });
  }

  void _filterNotes() {
    setState(() {
      _filteredNotes = _notes
          .where((note) =>
      note.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _confirmDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteNote(id);
    }
  }

  void _deleteNote(int id) {
    _noteController.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Simple Note'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredNotes.isEmpty
                ? Center(
              child: Text(
                'No notes found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            EditNoteScreen(note: note, onUpdate: _loadNotes),
                      ));
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(note.id!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddNoteScreen(
              onAdd: () async {
                await _loadNotes();
              },
            ),
          ));
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
