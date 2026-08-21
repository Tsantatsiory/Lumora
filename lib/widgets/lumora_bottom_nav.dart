import 'package:flutter/material.dart';
import '../theme.dart';

class LumoraBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LumoraBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'Learn'),
    (Icons.military_tech_outlined, Icons.military_tech_rounded, 'Rank'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        left: 14,
        right: 14,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.neoBorder, width: 2.5),
        ),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final selected = i == currentIndex;
          final (unselectedIcon, selectedIcon, label) = _items[i];
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.bannerBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: selected ? AppBorders.neo(width: 1.8) : null,
                    boxShadow: selected ? AppShadows.neo(offset: 2.0) : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? selectedIcon : unselectedIcon,
                        size: 22,
                        color: AppColors.text,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: body(
                          10.5,
                          color: AppColors.text,
                          weight: selected ? FontWeight.w900 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}