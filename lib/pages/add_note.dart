import 'package:flutter/material.dart';
import 'package:notes/pages/home.dart';

class AddNotePage extends StatefulWidget {
  final List<Note> notes;
  final Function(Note) onNoteAdded;
  final Color categoryColor;

  AddNotePage(this.notes, this.onNoteAdded, this.categoryColor);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late String _noteTitle;
  late String _noteText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
        backgroundColor: widget.categoryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              final note = Note(
                title: _noteTitle,
                text: _noteText,
                date: DateTime.now(),
              );
              widget.onNoteAdded(note);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String value) {
                _noteTitle = value;
              },
              decoration: InputDecoration(
                hintText: 'Note title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String value) {
                _noteText = value;
              },
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Start typing your note here...',
              ),
            ),
          )],
      ),
    );
  }
}
