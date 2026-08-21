import 'package:flutter/material.dart';
import '../theme.dart';

class LessonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String categoryTag;
  final String stickerTag; // e.g. 'NEW', 'HOT', '📌'
  final String trailingText;
  final Widget? trailingWidget;
  final double? progress;
  final Color? headerColor;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.categoryTag = 'Lesson',
    this.stickerTag = '',
    this.trailingText = '',
    this.trailingWidget,
    this.progress,
    this.headerColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: AppBorders.neo(width: 2.2),
            boxShadow: AppShadows.neo(offset: 3.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail / Header Area with Category Tag & Sticker
              Container(
                height: 95,
                decoration: BoxDecoration(
                  color: headerColor ?? AppColors.chipBg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.card - 2.2),
                  ),
                  border: const Border(
                    bottom: BorderSide(color: AppColors.neoBorder, width: 2.0),
                  ),
                ),
                child: Stack(
                  children: [
                    // Center Big Icon / Graphic Motif
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          border: AppBorders.neo(width: 1.8),
                        ),
                        child: Icon(icon, color: AppColors.text, size: 24),
                      ),
                    ),

                    // Top Left Sticker (e.g. 'NEW' or 'HOT')
                    if (stickerTag.isNotEmpty)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: stickerTag == 'NEW'
                                ? AppColors.stickerNew
                                : (stickerTag == '📌' ? AppColors.stickerPin : AppColors.amber),
                            borderRadius: BorderRadius.circular(6),
                            border: AppBorders.neo(width: 1.5),
                            boxShadow: AppShadows.neo(offset: 1.5),
                          ),
                          child: Text(
                            stickerTag,
                            style: body(9, weight: FontWeight.w900, color: AppColors.text),
                          ),
                        ),
                      ),

                    // Top Right XP Pill
                    if (trailingText.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: AppBorders.neo(width: 1.5),
                          ),
                          child: Text(
                            trailingText,
                            style: body(9.5, weight: FontWeight.w900, color: AppColors.lime2),
                          ),
                        ),
                      ),

                    // Bottom Left Category Tag (e.g. 'Gospels')
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.text,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColors.neoBorder, width: 1.2),
                        ),
                        child: Text(
                          categoryTag,
                          style: body(9, weight: FontWeight.w800, color: AppColors.bg),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Area below Thumbnail
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: heading(13.5, weight: FontWeight.w800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.auto_stories_outlined, size: 13, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            subtitle,
                            style: body(10.5, color: AppColors.muted, weight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (progress != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.surface3,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.neoBorder, width: 1),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: progress!.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lime,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}