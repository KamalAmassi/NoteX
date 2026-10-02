import 'package:note_x/features/notes/data/model/note_model.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;
  const NotesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Note>> getNotes() => remoteDataSource.getNotes();

  @override
  Future<void> addNote(Note note) =>
      remoteDataSource.saveNote(NoteModel.fromEntity(note));

  @override
  Future<void> updateNote(Note note) =>
      remoteDataSource.saveNote(NoteModel.fromEntity(note));

  @override
  Future<void> deleteNote(String id) => remoteDataSource.deleteNote(id);
}