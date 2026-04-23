import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';
import '../models/note.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  Future<void> _ouvrirCreation(BuildContext context) async {
    final note = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const CreateNotePage()),
    );

    if (note != null) {
      context.read<NoteService>().addNote(note);
    }
  }

  Future<void> _ouvrirDetail(BuildContext context, Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(note: note)),
    );

    if (result == 'deleted') {
      context.read<NoteService>().deleteNote(note.id);
    } else if (result is Note) {
      context.read<NoteService>().updateNote(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteService>().notes;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Mes Notes"),
            Consumer<NoteService>(
              builder: (_, service, __) {
                return Text("${service.count}");
              },
            ),
          ],
        ),
      ),

      body: notes.isEmpty
          ? const Center(child: Text("Aucune note"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, i) {
                final note = notes[i];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _ouvrirDetail(context, note),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: _hexToColor(note.couleur),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.titre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.contenu,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "${note.dateCreation.day}/${note.dateCreation.month}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _ouvrirCreation(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}