import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../controllers/notes_controller.dart';
import 'note_editor_page.dart';

class NoteDetailsPage extends GetView<NotesController> {
  final String noteId;
  const NoteDetailsPage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final matches = controller.notes.where((n) => n.id == noteId);
      if (matches.isEmpty) return const Scaffold();

      final note = matches.first;
      final colors = AppColors.noteColors;
      final bg = colors[note.colorIndex % colors.length];
      final hasTitle = note.title.trim().isNotEmpty;

      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: AppStrings.editNote,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Get.to(
                    () => NoteEditorPage(note: note),
                transition: Transition.downToUp,
                duration: const Duration(milliseconds: 320),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasTitle ? note.title : AppStrings.untitled,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 15, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      DateFormatter.format(note.updatedAt),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.black.withValues(alpha: 0.08)),
                const SizedBox(height: 16),
                SelectableText(
                  note.content,
                  style: const TextStyle(fontSize: 16, height: 1.9),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}