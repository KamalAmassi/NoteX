import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/note.dart';
import '../controllers/notes_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_details_page.dart';
import 'note_editor_page.dart';

class HomePage extends GetView<NotesController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const NoteEditorPage()),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cream,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          AppStrings.newNote,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => _Header(count: controller.notes.length)),
            _SearchField(onChanged: controller.search),
            Expanded(child: Obx(_buildContent)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final status = controller.status.value;

    if (status == NotesStatus.loading && controller.notes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (status == NotesStatus.failure) {
      return const EmptyState(
        icon: Icons.error_outline_rounded,
        title: AppStrings.loadError,
        subtitle: '',
      );
    }

    final notes = controller.filteredNotes;

    if (notes.isEmpty) {
      final searching = controller.query.value.trim().isNotEmpty;
      return EmptyState(
        icon: searching ? Icons.search_off_rounded : Icons.sticky_note_2_outlined,
        title: searching ? AppStrings.noResults : AppStrings.emptyTitle,
        subtitle:
        searching ? AppStrings.noResultsSubtitle : AppStrings.emptySubtitle,
      );
    }

    // عمودين بأطوال مختلفة (masonry بسيط بدون مكتبات)
    final left = <Note>[];
    final right = <Note>[];
    for (var i = 0; i < notes.length; i++) {
      (i.isEven ? left : right).add(notes[i]);
    }

    Widget column(List<Note> items) {
      return Column(
        children: items
            .map(
              (n) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NoteCard(
              note: n,
              onTap: () => Get.to(() => NoteDetailsPage(noteId: n.id)),
            ),
          ),
        )
            .toList(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: column(left)),
          const SizedBox(width: 12),
          Expanded(child: column(right)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int count;
  const _Header({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.myNotes,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.notesCount(count),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: AppColors.cream,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: const TextStyle(color: AppColors.hint, fontSize: 14),
          prefixIcon:
          const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
            const BorderSide(color: AppColors.primaryLight, width: 1.4),
          ),
        ),
      ),
    );
  }
}