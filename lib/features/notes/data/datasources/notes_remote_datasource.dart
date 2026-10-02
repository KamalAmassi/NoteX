import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_x/features/notes/data/model/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> saveNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const NotesRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });


  CollectionReference<Map<String, dynamic>> get _notes => firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('notes');

  @override
  Future<List<NoteModel>> getNotes() async {
    final snapshot =
    await _notes.orderBy('updatedAt', descending: true).get();
    return snapshot.docs.map((d) => NoteModel.fromJson(d.data())).toList();
  }

  @override
  Future<void> saveNote(NoteModel note) {
    return _notes.doc(note.id).set(note.toJson());
  }

  @override
  Future<void> deleteNote(String id) {
    return _notes.doc(id).delete();
  }
}