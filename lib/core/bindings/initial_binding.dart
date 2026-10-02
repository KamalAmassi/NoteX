import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/notes/data/datasources/notes_remote_datasource.dart';
import '../../features/notes/data/repositories/notes_repository_impl.dart';
import '../../features/notes/domain/repositories/notes_repository.dart';
import '../../features/notes/domain/usecases/add_note.dart';
import '../../features/notes/domain/usecases/delete_note.dart';
import '../../features/notes/domain/usecases/get_notes.dart';
import '../../features/notes/domain/usecases/update_note.dart';
import '../../features/notes/presentation/controllers/notes_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Data
    Get.lazyPut<NotesRemoteDataSource>(
          () => NotesRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      ),
      fenix: true,
    );
    Get.lazyPut<NotesRepository>(
          () => NotesRepositoryImpl(Get.find<NotesRemoteDataSource>()),
      fenix: true,
    );

    // Use cases
    Get.lazyPut(() => GetNotes(Get.find<NotesRepository>()), fenix: true);
    Get.lazyPut(() => AddNote(Get.find<NotesRepository>()), fenix: true);
    Get.lazyPut(() => UpdateNote(Get.find<NotesRepository>()), fenix: true);
    Get.lazyPut(() => DeleteNote(Get.find<NotesRepository>()), fenix: true);

    // Controller
    Get.put(
      NotesController(
        getNotesUseCase: Get.find<GetNotes>(),
        addNoteUseCase: Get.find<AddNote>(),
        updateNoteUseCase: Get.find<UpdateNote>(),
        deleteNoteUseCase: Get.find<DeleteNote>(),
      ),
      permanent: true,
    );
  }
}