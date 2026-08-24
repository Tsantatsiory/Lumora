import 'package:flutter/material.dart';
import '../../models/lesson_models.dart';
import '../../theme.dart';

class TrueFalseView extends StatelessWidget {
  final TrueFalseActivity activity;
  final bool? selectedAnswer;
  final bool hasSubmitted;
  final ValueChanged<bool> onSelect;

  const TrueFalseView({
    super.key,
    required this.activity,
    required this.selectedAnswer,
    required this.hasSubmitted,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isTrueCorrect = activity.isTrue;

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
          'Vrai ou Faux ?',
          style: heading(20, weight: FontWeight.w900),
        ),
        const SizedBox(height: 14),

        // Statement Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: AppBorders.neo(width: 2.2),
            boxShadow: AppShadows.neo(offset: 3.5),
          ),
          child: Text(
            '« ${activity.statement} »',
            style: body(16, height: 1.4, weight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),

        // True / False Buttons Row
        Row(
          children: [
            // Bouton VRAI
            Expanded(
              child: _buildChoiceButton(
                title: 'VRAI',
                icon: Icons.check_circle_outline_rounded,
                value: true,
                isSelected: selectedAnswer == true,
                isCorrect: isTrueCorrect,
              ),
            ),
            const SizedBox(width: 14),
            // Bouton FAUX
            Expanded(
              child: _buildChoiceButton(
                title: 'FAUX',
                icon: Icons.highlight_off_rounded,
                value: false,
                isSelected: selectedAnswer == false,
                isCorrect: !isTrueCorrect,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceButton({
    required String title,
    required IconData icon,
    required bool value,
    required bool isSelected,
    required bool isCorrect,
  }) {
    Color bgColor = AppColors.surface;
    Color contentColor = AppColors.text;

    if (hasSubmitted) {
      if (isCorrect) {
        bgColor = AppColors.lime;
        contentColor = AppColors.surface;
      } else if (isSelected && !isCorrect) {
        bgColor = const Color(0xFFFFDCD8);
        contentColor = AppColors.text;
      }
    } else if (isSelected) {
      bgColor = AppColors.bannerBg;
      contentColor = AppColors.surface;
    }

    return InkWell(
      onTap: hasSubmitted ? null : () => onSelect(value),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: AppBorders.neo(width: isSelected ? 2.8 : 2.0),
          boxShadow: isSelected ? AppShadows.neo(offset: 3.5) : AppShadows.neo(offset: 2.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: contentColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: heading(16, weight: FontWeight.w900, color: contentColor),
            ),
          ],
        ),
      ),
    );
  }
}
