import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/note_view_model.dart';

class NoteItem extends StatelessWidget {
  final String noteId;
  final String title;
  final String content;

  NoteItem({
    required this.noteId,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text(content),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            noteViewModel.deleteNote(noteId);
          },
        ),
      ),
    );
  }
}