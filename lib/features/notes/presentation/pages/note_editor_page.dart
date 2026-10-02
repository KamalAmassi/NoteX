import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/note.dart';
import '../controllers/notes_controller.dart';
import '../widgets/color_picker_row.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;
  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final NotesController _controller = Get.find<NotesController>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late int _colorIndex;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _colorIndex = widget.note?.colorIndex ?? 1;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.emptyNoteError)));
      return;
    }

    if (_isEdit) {
      await _controller.updateNote(
        widget.note!.copyWith(
          title: title,
          content: content,
          colorIndex: _colorIndex,
        ),
      );
    } else {
      await _controller.addNote(
        title: title,
        content: content,
        colorIndex: _colorIndex,
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.noteColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: colors[_colorIndex],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Get.back(),
          ),
          title: Text(
            _isEdit ? AppStrings.editNote : AppStrings.newNote,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.cream,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  AppStrings.save,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: AppStrings.titleHint,
                    hintStyle: TextStyle(color: AppColors.hint),
                  ),
                ),
                Divider(color: Colors.black.withValues(alpha: 0.08)),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: AppStrings.contentHint,
                      hintStyle: TextStyle(color: AppColors.hint),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ColorPickerRow(
                  selectedIndex: _colorIndex,
                  onChanged: (i) => setState(() => _colorIndex = i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}