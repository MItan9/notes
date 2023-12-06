import 'package:flutter/material.dart';
import 'package:notes/pages/home.dart';
import 'package:notes/pages/note_search.dart';
import 'package:notes/pages/edit_note.dart';
import 'package:notes/pages/add_note.dart';
import 'package:intl/intl.dart';

class CategoryNotes extends StatefulWidget {
  final Map<String, dynamic> categoryData;
  final int categoryIndex;
  final Function(int, Map<String, dynamic>) updateCategory;
  final Color categoryColor;

  CategoryNotes({
    required this.categoryData,
    required this.categoryIndex,
    required this.updateCategory,
    required this.categoryColor,
  });
  @override
  State<CategoryNotes> createState() => _CategoryNotesState(categoryData, updateCategory);
}

class _CategoryNotesState extends State<CategoryNotes> {
  late List<Note> notes;
  final Function(int, Map<String, dynamic>) updateCategoryCallback;

  _CategoryNotesState(Map<String, dynamic> categoryData, this.updateCategoryCallback) {
    notes = (categoryData['notes'] as List)
        .map((noteJson) {
      final noteData = noteJson as Map<String, dynamic>;
      return Note(
        title: noteData['title'] as String,
        text: noteData['text'] as String,
        date: DateTime.parse(noteData['date'] as String),
      );
    })
        .toList();
  }

  String _noteSearchText = '';

  @override
  Widget build(BuildContext context) {
    List<Note> filteredNotes = notes.where((note) {
      return note.title.toLowerCase().contains(_noteSearchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.categoryData['color']),
        title: Text(widget.categoryData['name']),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(notes, (context, index) {
                  _editNoteCallback(context, index);
                }),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, noteIndex) {
                return Card(
                  child: ListTile(
                    title: Text(filteredNotes[noteIndex].title),
                    subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(filteredNotes[noteIndex].date.toLocal())),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: () {
                        _deleteNoteCallback(noteIndex);
                      },
                    ),
                    onTap: () {
                      _editNoteCallback(context, noteIndex);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNotePage(notes, (newNote) {
                setState(() {
                  notes.add(newNote);
                  _saveCategoryData();
                });
              },
                widget.categoryColor,
              ),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.amber,
      ),
    );
  }

  _saveCategoryData() {
    final List<Map<String, dynamic>> serializedNotes = notes.map((note) {
      return {
        'title': note.title,
        'text': note.text,
        'date': note.date.toIso8601String(),
      };
    }).toList();

    final Map<String, dynamic> updatedCategoryData = {
      'name': widget.categoryData['name'],
      'notes': serializedNotes,
      'color': widget.categoryData['color'],
    };
    widget.updateCategory(widget.categoryIndex, updatedCategoryData);
  }

  _editNoteCallback(BuildContext context, int noteIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditNotePage(
          notes[noteIndex],
              (updatedNote) {
            setState(() {
              notes[noteIndex] = updatedNote;
              _saveCategoryData();
            });
          },
          widget.categoryColor,
        ),
      ),
    );
  }

  _deleteNoteCallback(int noteIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note', style: TextStyle(color: Colors.amber)),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.amber)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  notes.removeAt(noteIndex);
                  _saveCategoryData();
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      },
    );
  }
}
