import 'package:flutter/material.dart';
import '../theme.dart';

class StatsCard extends StatelessWidget {
  final int xp;
  final int xpGoal;
  final int level;
  final int streak;
  final int totalXp;
  final int badges;
  final VoidCallback? onViewAll;

  const StatsCard({
    super.key,
    required this.xp,
    required this.xpGoal,
    required this.level,
    required this.streak,
    required this.totalXp,
    required this.badges,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: 2.5),
        boxShadow: AppShadows.neo(offset: 4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Title + "View all" / "Stats" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR JOURNEY',
                style: heading(13, weight: FontWeight.w900, color: AppColors.text)
                    .copyWith(letterSpacing: 0.8),
              ),
              InkWell(
                onTap: onViewAll,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: AppBorders.neo(width: 1.8),
                    boxShadow: AppShadows.neo(offset: 1.8),
                  ),
                  child: Text(
                    'LVL $level • $xp XP',
                    style: body(11, weight: FontWeight.w800, color: AppColors.text),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4-Column Stat Tiles (matching the reference photo's 4 items with active highlight)
          Row(
            children: [
              _StatColumnItem(
                icon: Icons.menu_book_outlined,
                value: '$level',
                label: 'Level',
                isActive: false,
              ),
              const SizedBox(width: 6),
              _StatColumnItem(
                icon: Icons.bolt_rounded,
                value: '$totalXp',
                label: 'Total XP',
                isActive: true, // highlighted card like the 32 Links
              ),
              const SizedBox(width: 6),
              _StatColumnItem(
                icon: Icons.local_fire_department_outlined,
                value: '$streak',
                label: 'Streak',
                isActive: false,
              ),
              const SizedBox(width: 6),
              _StatColumnItem(
                icon: Icons.military_tech_outlined,
                value: '$badges',
                label: 'Badges',
                isActive: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumnItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isActive;

  const _StatColumnItem({
    required this.icon,
    required this.value,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surface.withValues(alpha: 0.85) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? AppBorders.neo(width: 1.8) : null,
          boxShadow: isActive ? AppShadows.neo(offset: 2.0) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: AppColors.text),
            const SizedBox(height: 5),
            Text(
              value,
              style: heading(18, weight: FontWeight.w900, color: AppColors.text),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: body(10, weight: FontWeight.w700, color: AppColors.text),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}