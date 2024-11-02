import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({Key? key, required this.onAdd}) : super(key: key);

  final Function onAdd;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final note = Note(
                  title: titleController.text,
                  content: contentController.text,
                );
                NoteController().addNote(note);
                onAdd();
                Navigator.pop(context);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
