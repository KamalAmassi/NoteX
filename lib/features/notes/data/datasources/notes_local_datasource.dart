import 'dart:convert';
import 'package:note_x/features/notes/data/model/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> cacheNotes(List<NoteModel> notes);
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  static const String _key = 'notex_notes';

  final SharedPreferences prefs;
  const NotesLocalDataSourceImpl(this.prefs);

  @override
  Future<List<NoteModel>> getNotes() async {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    final encoded = jsonEncode(notes.map((n) => n.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}