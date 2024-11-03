import 'package:flutter/material.dart';
import '../../controllers/note_controller.dart';
import '../../models/note_model.dart';

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
                final now = DateTime.now();
                final note = Note(
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: now,
                  updatedAt: now,
                );

                print('Adding note: ${note.toMap()}'); // Debugging line

                NoteController().addNote(note).then((_) {
                  print('Note added'); // Confirm it has been added
                  onAdd();
                  Navigator.pop(context);
                }).catchError((error) {
                  print('Error adding note: $error');
                });
              },
              child: const Text('Save Note'),
            )
          ],
        ),
      ),
    );
  }
}
