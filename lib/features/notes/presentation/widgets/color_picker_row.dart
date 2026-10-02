import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ColorPickerRow extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ColorPickerRow({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.noteColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(colors.length, (i) {
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors[i],
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.primary : Colors.black12,
                width: selected ? 2.5 : 1,
              ),
            ),
            child: selected
                ? const Icon(Icons.check_rounded,
                size: 18, color: AppColors.primary)
                : null,
          ),
        );
      }),
    );
  }
}