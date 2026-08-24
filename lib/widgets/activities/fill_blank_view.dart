import 'package:flutter/material.dart';
import '../../models/lesson_models.dart';
import '../../theme.dart';

class FillBlankView extends StatelessWidget {
  final FillInBlankActivity activity;
  final String? selectedWord;
  final bool hasSubmitted;
  final ValueChanged<String> onSelectWord;
  final VoidCallback onClearWord;

  const FillBlankView({
    super.key,
    required this.activity,
    required this.selectedWord,
    required this.hasSubmitted,
    required this.onSelectWord,
    required this.onClearWord,
  });

  @override
  Widget build(BuildContext context) {
    final parts = activity.prompt.split('___');
    final isCorrect = selectedWord?.trim().toLowerCase() == activity.correctWord.trim().toLowerCase();

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
          'Complétez le verset biblique :',
          style: heading(20, weight: FontWeight.w900),
        ),
        const SizedBox(height: 20),

        // Phrase avec trou interactif
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: AppBorders.neo(width: 2.2),
            boxShadow: AppShadows.neo(offset: 3.5),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 8,
            children: [
              if (parts.isNotEmpty)
                Text(
                  parts[0],
                  style: body(15, height: 1.6, weight: FontWeight.w700),
                ),
              // Slot / Trou interactif
              InkWell(
                onTap: hasSubmitted || selectedWord == null ? null : onClearWord,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selectedWord == null
                        ? AppColors.bg
                        : (hasSubmitted
                            ? (isCorrect ? AppColors.lime : const Color(0xFFFFDCD8))
                            : AppColors.bannerBg),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.neoBorder,
                      width: 2.0,
                    ),
                    boxShadow: selectedWord != null ? AppShadows.neo(offset: 2.0) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedWord ?? ' ______ ',
                        style: body(
                          14,
                          weight: FontWeight.w900,
                          color: (hasSubmitted && isCorrect)
                              ? AppColors.surface
                              : AppColors.text,
                        ),
                      ),
                      if (selectedWord != null && !hasSubmitted) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.close_rounded, size: 14, color: AppColors.text),
                      ],
                    ],
                  ),
                ),
              ),
              if (parts.length > 1)
                Text(
                  parts[1],
                  style: body(15, height: 1.6, weight: FontWeight.w700),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Banque de mots (Word Bank)
        Text(
          'Choisissez le mot manquant :',
          style: heading(14, weight: FontWeight.w800, color: AppColors.muted),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: activity.wordBank.map((word) {
            final isUsed = selectedWord == word;
            return InkWell(
              onTap: hasSubmitted || isUsed ? null : () => onSelectWord(word),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isUsed ? 0.35 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: AppBorders.neo(width: 2.0),
                    boxShadow: isUsed ? null : AppShadows.neo(offset: 2.5),
                  ),
                  child: Text(
                    word,
                    style: body(13.5, weight: FontWeight.w900, color: AppColors.text),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
