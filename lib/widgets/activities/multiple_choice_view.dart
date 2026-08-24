import 'package:flutter/material.dart';
import '../../models/lesson_models.dart';
import '../../theme.dart';

class MultipleChoiceView extends StatelessWidget {
  final MultipleChoiceActivity activity;
  final int? selectedIndex;
  final bool hasSubmitted;
  final ValueChanged<int> onSelect;

  const MultipleChoiceView({
    super.key,
    required this.activity,
    required this.selectedIndex,
    required this.hasSubmitted,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (activity.contextVerse != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              borderRadius: BorderRadius.circular(6),
              border: AppBorders.neo(width: 1.2),
            ),
            child: Text(
              activity.contextVerse!,
              style: body(11, weight: FontWeight.w900, color: AppColors.lime),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          activity.question,
          style: heading(20, weight: FontWeight.w900),
        ),
        const SizedBox(height: 24),
        ...List.generate(activity.options.length, (i) {
          final isSelected = selectedIndex == i;
          final isCorrect = i == activity.correctIndex;

          Color bgColor = AppColors.surface;
          Color borderColor = AppColors.neoBorder;

          if (hasSubmitted) {
            if (isCorrect) {
              bgColor = AppColors.lime;
            } else if (isSelected && !isCorrect) {
              bgColor = const Color(0xFFFFDCD8);
            }
          } else if (isSelected) {
            bgColor = AppColors.chipBg;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: hasSubmitted ? null : () => onSelect(i),
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: AppBorders.neo(width: isSelected ? 2.5 : 2.0, color: borderColor),
                  boxShadow: isSelected
                      ? AppShadows.neo(offset: 3.5, color: AppColors.neoBorder)
                      : AppShadows.neo(offset: 2.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected && !hasSubmitted
                            ? AppColors.text
                            : (hasSubmitted && isCorrect
                                ? AppColors.surface
                                : AppColors.bg),
                        borderRadius: BorderRadius.circular(8),
                        border: AppBorders.neo(width: 1.5),
                      ),
                      child: Text(
                        String.fromCharCode(65 + i), // A, B, C, D
                        style: heading(
                          13,
                          weight: FontWeight.w900,
                          color: isSelected && !hasSubmitted
                              ? AppColors.surface
                              : AppColors.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        activity.options[i],
                        style: body(
                          14,
                          weight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: (hasSubmitted && isCorrect)
                              ? AppColors.surface
                              : AppColors.text,
                        ),
                      ),
                    ),
                    if (hasSubmitted && isCorrect)
                      const Icon(Icons.check_circle_rounded, color: AppColors.surface, size: 22)
                    else if (hasSubmitted && isSelected && !isCorrect)
                      const Icon(Icons.cancel_rounded, color: AppColors.text, size: 22),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
