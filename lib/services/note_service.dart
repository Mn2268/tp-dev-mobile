import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteService extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  int get count => _notes.length;

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void updateNote(Note note) {
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  List<Note> search(String query) {
    return _notes.where((note) {
      return note.titre.toLowerCase().contains(query.toLowerCase()) ||
          note.contenu.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}