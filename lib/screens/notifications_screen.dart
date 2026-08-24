import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../theme.dart';
import '../widgets/lumora_bottom_nav.dart';
import '../widgets/lumora_toast.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<int> onNavigateToTab;

  const NotificationsScreen({
    super.key,
    required this.onBack,
    required this.onNavigateToTab,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int selectedCategoryIndex = 0; // 0: Toutes, 1: Rappels (Rétention), 2: Progression (Gamification)
  late List<NotificationItem> notifications;

  static const _filters = ['Toutes', '🔥 Rappels', '🏆 Progression'];

  @override
  void initState() {
    super.initState();
    notifications = NotificationRepository.getDefaultNotifications();
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in notifications) {
        n.isRead = true;
      }
    });
    showLumoraToast(context, 'Toutes les notifications sont lues ✓');
  }

  void _onNotificationTap(NotificationItem item) {
    setState(() {
      item.isRead = true;
    });

    if (item.targetNavIndex != null) {
      widget.onNavigateToTab(item.targetNavIndex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    final unreadCount = notifications.where((n) => !n.isRead).length;

    final filteredList = selectedCategoryIndex == 0
        ? notifications
        : (selectedCategoryIndex == 1
            ? notifications.where((n) => n.category == NotificationCategory.retention).toList()
            : notifications.where((n) => n.category == NotificationCategory.gamification).toList());

    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 1180 : 580),
            child: Column(
              children: [
                // Top Header Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.onBack,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: AppBorders.neo(width: 2.0),
                                boxShadow: AppShadows.neo(offset: 2.0),
                              ),
                              child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.text),
                            ),
                          ),
                          Text('Notifications', style: heading(22, letterSpacing: -0.5)),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.amber,
                                borderRadius: BorderRadius.circular(10),
                                border: AppBorders.neo(width: 1.2),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: body(10, weight: FontWeight.w900, color: AppColors.text),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (unreadCount > 0)
                        InkWell(
                          onTap: _markAllAsRead,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: AppBorders.neo(width: 1.5),
                              boxShadow: AppShadows.neo(offset: 1.5),
                            ),
                            child: Text(
                              'Tout lire',
                              style: body(11, weight: FontWeight.w900, color: AppColors.text),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Filter Selector (Toutes / Rappels / Progression)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: AppBorders.neo(width: 2.0),
                              boxShadow: AppShadows.neo(offset: 2.5),
                            ),
                            child: Row(
                              children: List.generate(_filters.length, (i) {
                                final isSelected = selectedCategoryIndex == i;
                                return Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => selectedCategoryIndex = i),
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.lime : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: isSelected ? AppBorders.neo(width: 1.5) : null,
                                      ),
                                      child: Text(
                                        _filters[i],
                                        style: body(
                                          11.5,
                                          weight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                          color: isSelected ? AppColors.surface : AppColors.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Notifications List
                          if (filteredList.isEmpty) ...[
                            const SizedBox(height: 60),
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      shape: BoxShape.circle,
                                      border: AppBorders.neo(width: 2.0),
                                    ),
                                    child: const Icon(Icons.notifications_none_rounded, size: 30, color: AppColors.muted),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('Aucune notification', style: heading(15, color: AppColors.muted)),
                                ],
                              ),
                            ),
                          ] else
                            Column(
                              children: filteredList.map((item) => _buildNotificationTile(item)).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Navigation
                LumoraBottomNav(
                  currentIndex: 0,
                  onTap: (i) => widget.onNavigateToTab(i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isRead ? AppColors.surface : AppColors.chipBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: item.isRead ? 1.8 : 2.4),
        boxShadow: item.isRead
            ? AppShadows.neo(offset: 2.0)
            : AppShadows.neo(offset: 3.5, color: AppColors.neoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: AppBorders.neo(width: 1.5),
                ),
                child: Icon(item.icon, size: 22, color: item.iconColor),
              ),
              const SizedBox(width: 12),

              // Title & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            style: heading(13.5, weight: FontWeight.w900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.lime,
                              borderRadius: BorderRadius.circular(4),
                              border: AppBorders.neo(width: 1.0),
                            ),
                            child: Text(
                              'NOUVEAU',
                              style: body(8, weight: FontWeight.w900, color: AppColors.surface),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.timeAgo,
                      style: body(10, color: AppColors.muted, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Message
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              item.message,
              style: body(12, color: AppColors.text, height: 1.4, weight: FontWeight.w600),
            ),
          ),

          // CTA Action Button if available
          if (item.ctaLabel != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _onNotificationTap(item),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 9),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.isRead ? AppColors.bg : AppColors.lime,
                  borderRadius: BorderRadius.circular(8),
                  border: AppBorders.neo(width: 1.5),
                  boxShadow: item.isRead ? null : AppShadows.neo(offset: 2.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.ctaLabel!,
                      style: body(
                        11.5,
                        weight: FontWeight.w900,
                        color: item.isRead ? AppColors.text : AppColors.surface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: item.isRead ? AppColors.text : AppColors.surface,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
