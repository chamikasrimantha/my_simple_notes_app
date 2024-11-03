import 'package:flutter/material.dart';
import '../../controllers/note_controller.dart';
import '../../models/note_model.dart';

class EditNoteScreen extends StatelessWidget {
  const EditNoteScreen({Key? key, required this.note, required this.onUpdate}) : super(key: key);

  final Note note;
  final Function onUpdate;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: note.title);
    final TextEditingController contentController = TextEditingController(text: note.content);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedNote = Note(
                  id: note.id,
                  title: titleController.text,
                  content: contentController.text,
                );
                NoteController().updateNote(updatedNote); // Update note in the controller
                onUpdate(); // Refresh the list in HomeScreen
                Navigator.pop(context); // Go back to HomeScreen
              },
              child: const Text('Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
