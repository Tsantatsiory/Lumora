import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/lumora_bottom_nav.dart';
import '../widgets/lumora_toast.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final ValueChanged<int>? onTabChange;

  const ProfileScreen({super.key, this.onBack, this.onTabChange});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTab = 0; // 0 = Badges, 1 = Activity, 2 = Saved
  int navIndex = 3; // Profile tab

  static const _tabs = ['Badges', 'Activity', 'Saved Verses'];

  final List<Map<String, dynamic>> _badges = [
    {
      'title': 'Flame Keeper',
      'subtitle': '30-day streak master',
      'tag': 'Streak',
      'icon': Icons.local_fire_department_rounded,
      'sticker': '🔥',
      'bgColor': AppColors.fireBg,
      'date': 'Unlocked Aug 18',
    },
    {
      'title': 'Gospel Scholar',
      'subtitle': 'Finished Matthew & Mark',
      'tag': 'Gospels',
      'icon': Icons.menu_book_rounded,
      'sticker': 'NEW',
      'bgColor': AppColors.chipBg,
      'date': 'Unlocked Aug 12',
    },
    {
      'title': 'Prayer Warrior',
      'subtitle': '7 days of daily prayer',
      'tag': 'Devotion',
      'icon': Icons.favorite_rounded,
      'sticker': '⭐',
      'bgColor': AppColors.bg,
      'date': 'Unlocked Aug 05',
    },
    {
      'title': 'Early Bird',
      'subtitle': 'Morning study before 8am',
      'tag': 'Habits',
      'icon': Icons.wb_sunny_rounded,
      'sticker': '✨',
      'bgColor': AppColors.bannerBg,
      'date': 'Unlocked Jul 28',
    },
    {
      'title': 'Wisdom Seeker',
      'subtitle': 'Studied 50 Proverbs',
      'tag': 'Wisdom',
      'icon': Icons.auto_awesome_rounded,
      'sticker': '📌',
      'bgColor': AppColors.bg,
      'date': 'Unlocked Jul 15',
    },
    {
      'title': 'Quiz Champion',
      'subtitle': '10 perfect daily quests',
      'tag': 'Quests',
      'icon': Icons.military_tech_rounded,
      'sticker': '🏆',
      'bgColor': AppColors.lime,
      'date': 'Unlocked Jul 02',
    },
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      'title': 'Completed Chapter 4: Life of Jesus',
      'xp': '+30 XP',
      'time': '2 hours ago',
      'icon': Icons.check_circle_rounded,
      'iconColor': AppColors.lime2,
    },
    {
      'title': 'Daily Quest: Who walked on water?',
      'xp': '+50 XP',
      'time': 'Yesterday',
      'icon': Icons.bolt_rounded,
      'iconColor': AppColors.amber,
    },
    {
      'title': 'Claimed Daily Check-in Streak',
      'xp': '+10 XP',
      'time': 'Yesterday',
      'icon': Icons.local_fire_department_rounded,
      'iconColor': AppColors.amber,
    },
    {
      'title': 'Completed Lesson: Love & Forgiveness',
      'xp': '+25 XP',
      'time': '3 days ago',
      'icon': Icons.favorite_rounded,
      'iconColor': AppColors.lime,
    },
  ];

  final List<Map<String, dynamic>> _savedVerses = [
    {
      'reference': 'Psalm 119:105',
      'text': 'Your word is a lamp to my feet and a light to my path.',
      'category': 'Guidance',
    },
    {
      'reference': 'Philippians 4:13',
      'text': 'I can do all things through Christ who strengthens me.',
      'category': 'Strength',
    },
    {
      'reference': 'Proverbs 3:5-6',
      'text': 'Trust in the Lord with all your heart, and do not lean on your own understanding.',
      'category': 'Trust',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 1180 : 580),
            child: Column(
              children: [
                // Top Action Bar with Username & Actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                  child: Row(
                    children: [
                      if (widget.onBack != null)
                        InkWell(
                          onTap: widget.onBack,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 40,
                            height: 40,
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
                      if (widget.onBack != null) const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '@tsanta_tsiory',
                          style: heading(15, weight: FontWeight.w900, color: AppColors.text),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          _IconButton(
                            icon: Icons.share_outlined,
                            onTap: () => showLumoraToast(context, 'Profile link copied!'),
                          ),
                          const SizedBox(width: 8),
                          _IconButton(
                            icon: Icons.settings_outlined,
                            onTap: () => showLumoraToast(context, 'Settings opened'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover Banner with Avatar Overlap (matching reference)
                        _buildCoverWithAvatar(),
                        const SizedBox(height: 14),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Name with Verified Checkmark Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Tsanta Tsiory', style: heading(22, weight: FontWeight.w900)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: AppColors.lime,
                                      shape: BoxShape.circle,
                                      border: AppBorders.neo(width: 1.5),
                                    ),
                                    child: const Icon(Icons.check_rounded, size: 14, color: AppColors.surface),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Followers & Following (Friends system)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => showLumoraToast(context, 'Followers list coming soon'),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: AppBorders.neo(width: 1.5),
                                        boxShadow: AppShadows.neo(offset: 1.8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('142', style: heading(12.5, weight: FontWeight.w900)),
                                          const SizedBox(width: 4),
                                          Text('Followers',
                                              style: body(11, color: AppColors.muted, weight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => showLumoraToast(context, 'Following list coming soon'),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: AppBorders.neo(width: 1.5),
                                        boxShadow: AppShadows.neo(offset: 1.8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('86', style: heading(12.5, weight: FontWeight.w900)),
                                          const SizedBox(width: 4),
                                          Text('Following',
                                              style: body(11, color: AppColors.muted, weight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Bio Quote
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.line),
                                ),
                                child: Text(
                                  '“Your word is a lamp to my feet and a light to my path.” — Psalm 119:105',
                                  style: body(11.5, color: AppColors.text, height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 18),

                              // 3 Key Stats Boxes (matching the 3 boxes from the photo)
                              Row(
                                children: [
                                  _buildStatBox('2,480', 'Total XP', Icons.bolt_rounded, AppColors.lime),
                                  const SizedBox(width: 10),
                                  _buildStatBox('35', 'Day Streak', Icons.local_fire_department_rounded, AppColors.amber),
                                  const SizedBox(width: 10),
                                  _buildStatBox('12', 'Badges', Icons.military_tech_rounded, AppColors.amber),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Action Buttons Row (Main CTA + Options)
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => showLumoraToast(context, 'Edit profile opened'),
                                      borderRadius: BorderRadius.circular(AppRadius.button),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.bannerBg,
                                          borderRadius: BorderRadius.circular(AppRadius.button),
                                          border: AppBorders.neo(width: 2.2),
                                          boxShadow: AppShadows.neo(offset: 3.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Edit Profile',
                                              style: body(13.5, weight: FontWeight.w900, color: AppColors.text),
                                            ),
                                            const SizedBox(width: 6),
                                            const Icon(Icons.add_rounded, size: 18, color: AppColors.text),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => showLumoraToast(context, 'More options'),
                                    borderRadius: BorderRadius.circular(AppRadius.button),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(AppRadius.button),
                                        border: AppBorders.neo(width: 2.2),
                                        boxShadow: AppShadows.neo(offset: 3.0),
                                      ),
                                      child: const Icon(Icons.more_vert_rounded, size: 22, color: AppColors.text),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),

                              // Tabs Row (Item's / Activity / Saved)
                              Row(
                                children: List.generate(_tabs.length, (i) {
                                  final isSelected = selectedTab == i;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 18),
                                    child: InkWell(
                                      onTap: () => setState(() => selectedTab = i),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              if (isSelected)
                                                Positioned(
                                                  bottom: 2,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.bannerBg,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                  ),
                                                ),
                                              Text(
                                                _tabs[i],
                                                style: heading(
                                                  16,
                                                  weight: isSelected ? FontWeight.w900 : FontWeight.w600,
                                                  color: isSelected ? AppColors.text : AppColors.muted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 16),

                              // Content depending on selected tab
                              if (selectedTab == 0)
                                _buildBadgesGrid(isWide)
                              else if (selectedTab == 1)
                                _buildActivityList()
                              else
                                _buildSavedVersesList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation
                LumoraBottomNav(
                  currentIndex: navIndex,
                  onTap: (i) {
                    setState(() => navIndex = i);
                    if (widget.onTabChange != null) {
                      widget.onTabChange!(i);
                    } else if (i == 0 && widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      const labels = ['Home', 'Learn', 'Rank', 'Profile'];
                      showLumoraToast(context, '${labels[i]} selected');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Cover banner with overlapping avatar (matches reference photo)
  Widget _buildCoverWithAvatar() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Cover Banner Image Container
        Container(
          height: 145,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.chipBg,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: AppBorders.neo(width: 2.2),
            boxShadow: AppShadows.neo(offset: 3.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card - 2.2),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/profile_banner.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.bannerBg),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: AppBorders.neo(width: 1.5),
                      boxShadow: AppShadows.neo(offset: 1.5),
                    ),
                    child: Text(
                      'LUMORA LEARNER',
                      style: body(9.5, weight: FontWeight.w900, color: AppColors.text),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Overlapping Avatar Card
        Positioned(
          bottom: -36,
          child: Container(
            width: 84,
            height: 84,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: AppBorders.neo(width: 2.5),
              boxShadow: AppShadows.neo(offset: 3.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Image.asset(
                'assets/images/profile_avatar.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.bannerBg,
                  alignment: Alignment.center,
                  child: const Text('🧑‍💻', style: TextStyle(fontSize: 40)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 3 Stat boxes (Followers / Value / Owned in reference -> Total XP / Streak / Badges)
  Widget _buildStatBox(String value, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: AppBorders.neo(width: 2.0),
          boxShadow: AppShadows.neo(offset: 2.5),
        ),
        child: Column(
          children: [
            Text(value, style: heading(16, weight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(
              label,
              style: body(10, color: AppColors.muted, weight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// 2-Column Badges Grid (matches the 2-column cards layout from the photo)
  Widget _buildBadgesGrid(bool isWide) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: _badges.length,
      itemBuilder: (context, i) {
        final badge = _badges[i];
        return InkWell(
          onTap: () => showLumoraToast(context, '${badge['title']} badge selected!'),
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: AppBorders.neo(width: 2.2),
              boxShadow: AppShadows.neo(offset: 3.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Thumbnail Area with Icon & Sticker
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: badge['bgColor'] as Color,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.card - 2.2),
                    ),
                    border: const Border(
                      bottom: BorderSide(color: AppColors.neoBorder, width: 2.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: AppBorders.neo(width: 1.8),
                          ),
                          child: Icon(badge['icon'] as IconData, size: 22, color: AppColors.text),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(5),
                            border: AppBorders.neo(width: 1.2),
                          ),
                          child: Text(badge['sticker'] as String, style: const TextStyle(fontSize: 10)),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.text,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge['tag'] as String,
                            style: body(8.5, weight: FontWeight.w800, color: AppColors.bg),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Text Area
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(badge['title'] as String, style: heading(13, weight: FontWeight.w900), maxLines: 1),
                      const SizedBox(height: 2),
                      Text(badge['subtitle'] as String,
                          style: body(10, color: AppColors.muted, weight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(badge['date'] as String,
                          style: body(9, color: AppColors.lime2, weight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Activity List
  Widget _buildActivityList() {
    return Column(
      children: List.generate(_activities.length, (i) {
        final act = _activities[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: AppBorders.neo(width: 2.0),
            boxShadow: AppShadows.neo(offset: 2.5),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.chipBg,
                  borderRadius: BorderRadius.circular(10),
                  border: AppBorders.neo(width: 1.5),
                ),
                child: Icon(act['icon'] as IconData, size: 20, color: act['iconColor'] as Color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(act['title'] as String, style: heading(12.5, weight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(act['time'] as String, style: body(10, color: AppColors.muted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bannerBg,
                  borderRadius: BorderRadius.circular(6),
                  border: AppBorders.neo(width: 1.2),
                ),
                child: Text(act['xp'] as String, style: body(10.5, weight: FontWeight.w900)),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Saved Verses List
  Widget _buildSavedVersesList() {
    return Column(
      children: List.generate(_savedVerses.length, (i) {
        final verse = _savedVerses[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: AppBorders.neo(width: 2.0),
            boxShadow: AppShadows.neo(offset: 2.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(verse['reference'] as String, style: heading(14, weight: FontWeight.w900)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.chipBg,
                      borderRadius: BorderRadius.circular(6),
                      border: AppBorders.neo(width: 1.2),
                    ),
                    child: Text(verse['category'] as String, style: body(9.5, weight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '“${verse['text']}”',
                style: body(12, color: AppColors.text, height: 1.45),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: AppBorders.neo(width: 2.0),
            boxShadow: AppShadows.neo(offset: 2.5),
          ),
          child: Icon(icon, size: 20, color: AppColors.text),
        ),
      ),
    );
  }
}
