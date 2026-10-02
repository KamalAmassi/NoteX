import '../repositories/notes_repository.dart';

class DeleteNote {
  final NotesRepository repository;
  const DeleteNote(this.repository);

  Future<void> call(String id) => repository.deleteNote(id);
}