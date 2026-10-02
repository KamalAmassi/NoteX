import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetNotes {
  final NotesRepository repository;
  const GetNotes(this.repository);

  Future<List<Note>> call() => repository.getNotes();
}