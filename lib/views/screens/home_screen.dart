// views/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/search_bar.dart' as custom;
import '../../controllers/note_controller.dart';
import '../../models/note_model.dart';
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
      _filteredNotes = notes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Simple Note'),
      ),
      body: Column(
        children: [
          custom.CustomSearchBar(controller: _searchController),
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
                        builder: (context) => EditNoteScreen(
                          note: note,
                          onUpdate: _loadNotes,
                        ),
                      ));
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        // Show a confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Note'),
                              content: const Text(
                                  'Are you sure you want to delete this note?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteNote(note.id!);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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

  void _deleteNote(int id) {
    _noteController.deleteNote(id);
    _loadNotes();
  }
}
