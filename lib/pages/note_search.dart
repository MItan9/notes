import 'package:flutter/material.dart';
import 'package:notes/pages/home.dart';

class NoteSearchDelegate extends SearchDelegate<String> {
  final List<Note> notes;
  final Function(BuildContext, int) editNoteCallback;

  NoteSearchDelegate(this.notes, this.editNoteCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Note> searchResults = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].title),
          subtitle: Text(searchResults[index].date.toLocal().toString()),
          onTap: () {
            editNoteCallback(context, notes.indexOf(searchResults[index]));
            close(context, query);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Note> suggestionList = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].title),
          subtitle: Text(suggestionList[index].date.toLocal().toString()),
          onTap: () {
            editNoteCallback(context, notes.indexOf(suggestionList[index]));
            close(context, query);
          },
        );
      },
    );
  }
}
