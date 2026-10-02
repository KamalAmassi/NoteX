import 'package:get/get.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/update_note.dart';

enum NotesStatus { initial, loading, success, failure }

class NotesController extends GetxController {
  final GetNotes getNotesUseCase;
  final AddNote addNoteUseCase;
  final UpdateNote updateNoteUseCase;
  final DeleteNote deleteNoteUseCase;

  NotesController({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  });

  final Rx<NotesStatus> status = NotesStatus.initial.obs;
  final RxList<Note> notes = <Note>[].obs;
  final RxString query = ''.obs;

  List<Note> get filteredNotes {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return notes;
    return notes.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    status.value = NotesStatus.loading;
    try {
      final result = await getNotesUseCase();
      notes.assignAll(result);
      status.value = NotesStatus.success;
    } catch (_) {
      status.value = NotesStatus.failure;
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
    required int colorIndex,
  }) async {
    final now = DateTime.now();
    final note = Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      colorIndex: colorIndex,
      createdAt: now,
      updatedAt: now,
    );
    await addNoteUseCase(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await updateNoteUseCase(note.copyWith(updatedAt: DateTime.now()));
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    notes.removeWhere((n) => n.id == id);
    await deleteNoteUseCase(id);
    await loadNotes();
  }

  // للتراجع عن الحذف: نرجّع نفس الملاحظة بنفس الـ id
  Future<void> restoreNote(Note note) async {
    await addNoteUseCase(note);
    await loadNotes();
  }

  void search(String value) => query.value = value;
}