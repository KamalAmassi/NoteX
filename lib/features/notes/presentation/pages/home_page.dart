import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/note.dart';
import '../controllers/notes_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_details_page.dart';
import 'note_editor_page.dart';

class HomePage extends GetView<NotesController> {
  const HomePage({super.key});

  void _openEditor([Note? note]) {
    Get.to(
          () => NoteEditorPage(note: note),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 320),
    );
  }

  void _openDetails(Note note) {
    Get.to(
          () => NoteDetailsPage(noteId: note.id),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 280),
    );
  }

  void _showActions(BuildContext context, Note note) {
    Get.bottomSheet(
      _NoteActionsSheet(
        note: note,
        onEdit: () {
          Get.back();
          _openEditor(note);
        },
        onDelete: () {
          Get.back();
          _delete(context, note);
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _delete(BuildContext context, Note note) async {
    await controller.deleteNote(note.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(AppStrings.noteDeleted),
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          action: SnackBarAction(
            label: AppStrings.undo,
            textColor: AppColors.accent,
            onPressed: () => controller.restoreNote(note),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Obx(() => _buildScroll(context)),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16 + bottomInset,
            child: FadeSlideIn(
              index: 3,
              child: _FloatingBar(
                onChanged: controller.search,
                onAdd: _openEditor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScroll(BuildContext context) {
    final status = controller.status.value;
    final total = controller.notes.length;
    final notes = controller.filteredNotes;
    final searching = controller.query.value.trim().isNotEmpty;

    Widget body;

    if (status == NotesStatus.loading && total == 0) {
      body = const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    } else if (status == NotesStatus.failure) {
      body = const SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 90),
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            title: AppStrings.loadError,
            subtitle: '',
          ),
        ),
      );
    } else if (notes.isEmpty) {
      body = SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: FadeSlideIn(
            index: 1,
            child: EmptyState(
              icon: searching
                  ? Icons.search_off_rounded
                  : Icons.sticky_note_2_outlined,
              title: searching ? AppStrings.noResults : AppStrings.emptyTitle,
              subtitle: searching
                  ? AppStrings.noResultsSubtitle
                  : AppStrings.emptySubtitle,
            ),
          ),
        ),
      );
    } else {
      body = SliverToBoxAdapter(child: _buildMasonry(context, notes));
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _Header(count: total)),
        body,
      ],
    );
  }

  // عمودين بأطوال مختلفة (masonry بسيط بدون مكتبات)
  Widget _buildMasonry(BuildContext context, List<Note> notes) {
    final left = <Widget>[];
    final right = <Widget>[];

    for (var i = 0; i < notes.length; i++) {
      final note = notes[i];
      final card = Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: FadeSlideIn(
          key: ValueKey(note.id),
          index: i,
          child: NoteCard(
            note: note,
            onTap: () => _openDetails(note),
            onLongPress: () => _showActions(context, note),
          ),
        ),
      );
      (i.isEven ? left : right).add(card);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 130),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(children: left)),
          const SizedBox(width: 14),
          Expanded(child: Column(children: right)),
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
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      child: FadeSlideIn(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.greeting(),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    AppStrings.myNotes,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      AppStrings.notesCount(count),
                      key: ValueKey(count),
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: AppColors.cream,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شريط زجاجي عائم: بحث + زر إضافة
class _FloatingBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onAdd;

  const _FloatingBar({required this.onChanged, required this.onAdd});

  @override
  State<_FloatingBar> createState() => _FloatingBarState();
}

class _FloatingBarState extends State<_FloatingBar> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_refresh);
    _text.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _text,
                    focusNode: _focus,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppStrings.searchHint,
                      hintStyle: const TextStyle(
                        color: AppColors.hint,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: _text.text.isEmpty
                          ? null
                          : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: AppColors.textSecondary,
                        onPressed: () {
                          _text.clear();
                          widget.onChanged('');
                        },
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: AlignmentDirectional.centerEnd,
                  child: focused
                      ? const SizedBox(height: 52)
                      : Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: Material(
                      color: AppColors.accent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: widget.onAdd,
                        child: const SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// قائمة الإجراءات عند الضغط المطوّل على ملاحظة
class _NoteActionsSheet extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoteActionsSheet({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.noteColors;
    final hasTitle = note.title.trim().isNotEmpty;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colors[note.colorIndex % colors.length],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasTitle ? note.title : AppStrings.untitled,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.edit_outlined,
              label: AppStrings.editNote,
              onTap: onEdit,
            ),
            _ActionTile(
              icon: Icons.delete_outline_rounded,
              label: AppStrings.delete,
              color: AppColors.primary,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}