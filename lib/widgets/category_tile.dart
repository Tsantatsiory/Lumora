import 'package:flutter/material.dart';
import '../theme.dart';

class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
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
          constraints: const BoxConstraints(minHeight: 104),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: AppBorders.neo(width: 2.0),
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: AppShadows.neo(offset: 3.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.chipBg,
                  borderRadius: BorderRadius.circular(10),
                  border: AppBorders.neo(width: 1.5),
                ),
                child: Icon(icon, color: AppColors.text, size: 19),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: heading(13, weight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: body(9.5, color: AppColors.muted, weight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}