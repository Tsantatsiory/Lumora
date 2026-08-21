import 'package:flutter/material.dart';
import '../theme.dart';

class DailyChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onStart;

  const DailyChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: 2.5),
        boxShadow: AppShadows.neo(offset: 4.0),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.stickerNew,
                  borderRadius: BorderRadius.circular(6),
                  border: AppBorders.neo(width: 1.8),
                  boxShadow: AppShadows.neo(offset: 1.8),
                ),
                child: Text(
                  "TODAY'S QUEST",
                  style: body(10, color: AppColors.text, weight: FontWeight.w900)
                      .copyWith(letterSpacing: 0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chipBg,
                  borderRadius: BorderRadius.circular(8),
                  border: AppBorders.neo(width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: AppColors.text),
                    const SizedBox(width: 2),
                    Text(
                      '+50 XP',
                      style: body(10.5, color: AppColors.text, weight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: heading(18, weight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            description,
            style: body(12, color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onStart,
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: AppBorders.neo(width: 2.0),
                boxShadow: AppShadows.neo(offset: 2.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start challenge',
                    style: body(13, weight: FontWeight.w800, color: AppColors.bg),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.bg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}