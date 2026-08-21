import 'package:flutter/material.dart';
import '../theme.dart';

class StreakCard extends StatelessWidget {
  final int streak;
  final int currentDayIndex; // 0=Mon ... 6=Sun
  final List<bool> done; // 7 entries

  const StreakCard({
    super.key,
    required this.streak,
    required this.currentDayIndex,
    required this.done,
  });

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: 2.5),
        boxShadow: AppShadows.neo(offset: 4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.fireBg,
                  borderRadius: BorderRadius.circular(14),
                  border: AppBorders.neo(width: 1.8),
                  boxShadow: AppShadows.neo(offset: 2.0),
                ),
                child: const Text('🔥', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Keep the flame alive!', style: heading(15, weight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(
                      "You're on a $streak-day streak! Don't break it.",
                      style: body(11.5, color: AppColors.muted, weight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(14),
              border: AppBorders.neo(width: 1.5),
            ),
            child: Row(
              children: List.generate(7, (i) {
                final isDone = done[i];
                final isCurrent = i == currentDayIndex;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        Text(
                          _labels[i],
                          style: body(
                            10.5,
                            color: isCurrent ? AppColors.text : AppColors.muted,
                            weight: isCurrent ? FontWeight.w900 : FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? AppColors.lime
                                : (isCurrent ? AppColors.stickerNew : AppColors.surface),
                            border: AppBorders.neo(width: isCurrent ? 2.2 : 1.5),
                            boxShadow: isDone || isCurrent
                                ? AppShadows.neo(offset: 1.5)
                                : null,
                          ),
                          child: Icon(
                            isDone
                                ? Icons.check_rounded
                                : (isCurrent ? Icons.play_arrow_rounded : Icons.circle),
                            size: isDone ? 18 : (isCurrent ? 16 : 6),
                            color: isDone
                              ? AppColors.bg
                                : (isCurrent ? AppColors.text : AppColors.muted.withValues(alpha: 0.4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}