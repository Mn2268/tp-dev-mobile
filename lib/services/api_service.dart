import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com";
  // 🔵 GET
  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) {
        return Note(
          id: e['id'].toString(),
          titre: e['title'] ?? '',
          contenu: e['body'] ?? '',
          couleur: "0xFFFFFFFF",
          dateCreation: DateTime.now(),
        );
      }).toList();
    } else {
      print("Eror fetching notes: ${response.statusCode}");
      print(response.body); // 👈 طباعة الجسم الكامل للرد
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  // 🟢 POST
  Future<bool> createNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': note.titre, 'body': note.contenu}),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // 🔴 DELETE
  Future<bool> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
