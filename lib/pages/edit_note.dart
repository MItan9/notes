import 'package:flutter/material.dart';
import 'package:notes/pages/home.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  final Function(Note) onNoteUpdated;
  final Color categoryColor;


  EditNotePage(this.note, this.onNoteUpdated, this.categoryColor);

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late String _noteTitle;
  late String _noteText;

  @override
  void initState() {
    super.initState();
    _noteTitle = widget.note.title;
    _noteText = widget.note.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.categoryColor,
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              final updatedNote = widget.note;
              updatedNote.title = _noteTitle;
              updatedNote.text = _noteText;
              widget.onNoteUpdated(updatedNote);
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
              controller: TextEditingController(text: _noteTitle),
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
              controller: TextEditingController(text: _noteText),
            ),
          ),
        ],
      ),
    );
  }
}
