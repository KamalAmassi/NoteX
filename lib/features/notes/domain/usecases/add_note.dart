import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class AddNote {
  final NotesRepository repository;
  const AddNote(this.repository);

  Future<void> call(Note note) => repository.addNote(note);
}