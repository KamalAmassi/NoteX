import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class UpdateNote {
  final NotesRepository repository;
  const UpdateNote(this.repository);

  Future<void> call(Note note) => repository.updateNote(note);
}