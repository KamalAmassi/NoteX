import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.noteColors;
    final color = colors[note.colorIndex % colors.length];
    final hasTitle = note.title.trim().isNotEmpty;
    final hasContent = note.content.trim().isNotEmpty;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasTitle ? note.title : AppStrings.untitled,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: hasTitle
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              if (hasContent) ...[
                const SizedBox(height: 6),
                Text(
                  note.content,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                DateFormatter.format(note.updatedAt),
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.hint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}