import 'package:flutter/material.dart';
import '../models/lesson_models.dart';
import '../models/lesson_repository.dart';
import '../theme.dart';
import '../widgets/lesson_card.dart';
import '../widgets/lumora_bottom_nav.dart';
import '../widgets/lumora_toast.dart';
import 'lesson_session_screen.dart';

class LearnScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final ValueChanged<int>? onTabChange;

  const LearnScreen({super.key, this.onBack, this.onTabChange});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int selectedFilter = 0;
  int navIndex = 1; // Learn tab
  Lesson? activeSessionLesson;

  static const _filters = ['All', 'Gospels', 'Wisdom', 'Stories', 'Living', 'Epistles'];

  final List<Map<String, dynamic>> _allLessons = [
    // Module 1: Gospels
    {
      'title': 'Birth & Early Ministry',
      'subtitle': 'Luke 1-4 • Beginnings',
      'category': 'Gospels',
      'sticker': 'DONE ✓',
      'xp': '+25 XP',
      'progress': 1.0,
      'icon': Icons.auto_awesome_rounded,
      'module': 'The Gospels & Jesus',
    },
    {
      'title': 'Sermon on the Mount',
      'subtitle': 'Matthew 5-7 • Beatitudes',
      'category': 'Gospels',
      'sticker': 'DONE ✓',
      'xp': '+30 XP',
      'progress': 1.0,
      'icon': Icons.menu_book_rounded,
      'module': 'The Gospels & Jesus',
    },
    {
      'title': 'Parables of the Kingdom',
      'subtitle': 'Matthew 13 • Heavenly Truths',
      'category': 'Gospels',
      'sticker': 'DONE ✓',
      'xp': '+30 XP',
      'progress': 1.0,
      'icon': Icons.lightbulb_outline_rounded,
      'module': 'The Gospels & Jesus',
    },
    {
      'title': 'The Life of Jesus',
      'subtitle': 'Miracles & Ministry',
      'category': 'Gospels',
      'sticker': 'ACTIVE',
      'xp': '+30 XP',
      'progress': 0.65,
      'icon': Icons.auto_stories_rounded,
      'module': 'The Gospels & Jesus',
    },

    // Module 2: Wisdom
    {
      'title': 'Proverbs for Daily Life',
      'subtitle': 'Proverbs 1-10 • Practical Living',
      'category': 'Wisdom',
      'sticker': 'NEW',
      'xp': '+25 XP',
      'progress': null,
      'icon': Icons.psychology_outlined,
      'module': 'Wisdom & Poetry',
    },
    {
      'title': 'Psalms of Praise & Peace',
      'subtitle': 'Psalm 23 & 91 • Comfort',
      'category': 'Wisdom',
      'sticker': '📌',
      'xp': '+30 XP',
      'progress': null,
      'icon': Icons.music_note_rounded,
      'module': 'Wisdom & Poetry',
    },
    {
      'title': 'Ecclesiastes: True Purpose',
      'subtitle': 'Ecclesiastes 3 • Seasons of Life',
      'category': 'Wisdom',
      'sticker': '',
      'xp': '+25 XP',
      'progress': null,
      'icon': Icons.hourglass_empty_rounded,
      'module': 'Wisdom & Poetry',
    },

    // Module 3: Stories & Heroes
    {
      'title': 'David & Goliath',
      'subtitle': '1 Samuel 17 • Fearless Faith',
      'category': 'Stories',
      'sticker': 'NEW',
      'xp': '+35 XP',
      'progress': null,
      'icon': Icons.shield_rounded,
      'module': 'Heroes of the Faith',
    },
    {
      'title': 'Moses & the Red Sea',
      'subtitle': 'Exodus 14 • Deliverance',
      'category': 'Stories',
      'sticker': '',
      'xp': '+35 XP',
      'progress': null,
      'icon': Icons.water_rounded,
      'module': 'Heroes of the Faith',
    },
    {
      'title': "Daniel in the Lions' Den",
      'subtitle': 'Daniel 6 • Steadfast Prayer',
      'category': 'Stories',
      'sticker': 'HOT',
      'xp': '+30 XP',
      'progress': null,
      'icon': Icons.pets_rounded,
      'module': 'Heroes of the Faith',
    },

    // Module 4: Living & Epistles
    {
      'title': 'Love & Forgiveness',
      'subtitle': 'Colossians 3 • Christian Living',
      'category': 'Living',
      'sticker': 'ACTIVE',
      'xp': '+25 XP',
      'progress': 0.30,
      'icon': Icons.favorite_rounded,
      'module': 'Christian Living & Epistles',
    },
    {
      'title': 'The Armor of God',
      'subtitle': 'Ephesians 6 • Spiritual Battle',
      'category': 'Epistles',
      'sticker': 'NEW',
      'xp': '+30 XP',
      'progress': null,
      'icon': Icons.military_tech_rounded,
      'module': 'Christian Living & Epistles',
    },
    {
      'title': 'Fruits of the Holy Spirit',
      'subtitle': 'Galatians 5:22 • Character',
      'category': 'Living',
      'sticker': '',
      'xp': '+25 XP',
      'progress': null,
      'icon': Icons.eco_rounded,
      'module': 'Christian Living & Epistles',
    },
  ];

  void _startLesson(String lessonId) {
    final lesson = LessonRepository.getLessonById(lessonId);
    setState(() {
      activeSessionLesson = lesson;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activeSessionLesson != null) {
      return LessonSessionScreen(
        lesson: activeSessionLesson!,
        onFinished: () {
          setState(() {
            activeSessionLesson = null;
          });
          showLumoraToast(context, 'Progression enregistrée ! +XP ajouté 🔥');
        },
      );
    }

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    final filteredLessons = selectedFilter == 0
        ? _allLessons
        : _allLessons.where((l) => l['category'] == _filters[selectedFilter]).toList();

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
                          if (widget.onBack != null)
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
                          Text('Bible Lessons', style: heading(22, letterSpacing: -0.5)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: AppBorders.neo(width: 1.8),
                          boxShadow: AppShadows.neo(offset: 1.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.lime),
                            const SizedBox(width: 4),
                            Text(
                              '13 Lessons',
                              style: body(11, color: AppColors.text, weight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Active / Resume Lesson Hero Banner
                          _buildResumeHeroCard(),
                          const SizedBox(height: 20),

                          // Filter Chips Bar
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_filters.length, (i) {
                                final isSelected = selectedFilter == i;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8, bottom: 4),
                                  child: InkWell(
                                    onTap: () => setState(() => selectedFilter = i),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.text : AppColors.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: AppBorders.neo(width: 1.8),
                                        boxShadow: isSelected
                                            ? AppShadows.neo(offset: 2.0, color: AppColors.lime)
                                            : AppShadows.neo(offset: 1.8),
                                      ),
                                      child: Text(
                                        _filters[i],
                                        style: body(
                                          11.5,
                                          weight: FontWeight.w800,
                                          color: isSelected ? AppColors.surface : AppColors.text,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Section Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedFilter == 0
                                    ? 'All Modules & Chapters'
                                    : '${_filters[selectedFilter]} Lessons',
                                style: heading(16, weight: FontWeight.w900),
                              ),
                              Text(
                                '${filteredLessons.length} available',
                                style: body(11, color: AppColors.muted, weight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 2-Column Grid of Lessons
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWide ? 4 : 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.82,
                            ),
                            itemCount: filteredLessons.length,
                            itemBuilder: (context, i) {
                              final lesson = filteredLessons[i];
                              final lessonId = i == 0
                                  ? 'jesus_miracles'
                                  : (lesson['title'] == 'David & Goliath'
                                      ? 'david_goliath'
                                      : (lesson['title'] == 'Love & Forgiveness'
                                          ? 'love_forgiveness'
                                          : (lesson['title'] == 'The Armor of God'
                                              ? 'armor_of_god'
                                              : 'jesus_miracles')));

                              return LessonCard(
                                icon: lesson['icon'] as IconData,
                                title: lesson['title'] as String,
                                subtitle: lesson['subtitle'] as String,
                                categoryTag: lesson['category'] as String,
                                stickerTag: lesson['sticker'] as String,
                                trailingText: lesson['xp'] as String,
                                progress: lesson['progress'] as double?,
                                headerColor: AppColors.chipBg,
                                onTap: () => _startLesson(lessonId),
                              );
                            },
                          ),
                        ],
                      ),
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

  /// Resume Hero Card
  Widget _buildResumeHeroCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: AppBorders.neo(width: 1.5),
                ),
                child: Text(
                  'CONTINUE LEARNING',
                  style: body(9.5, weight: FontWeight.w900, color: AppColors.text)
                      .copyWith(letterSpacing: 0.6),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: AppBorders.neo(width: 1.2),
                ),
                child: Text(
                  '+30 XP',
                  style: body(10, weight: FontWeight.w900, color: AppColors.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The Life of Jesus',
            style: heading(18, weight: FontWeight.w900, color: AppColors.surface),
          ),
          const SizedBox(height: 2),
          Text(
            'Chapter 4 • Miracles & Ministry',
            style: body(12, color: AppColors.surface.withValues(alpha: 0.9), weight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.neoBorder, width: 1.2),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.65,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '65%',
                style: body(11.5, weight: FontWeight.w900, color: AppColors.surface),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // CTA Button
          InkWell(
            onTap: () => _startLesson('jesus_miracles'),
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: AppBorders.neo(width: 2.0),
                boxShadow: AppShadows.neo(offset: 2.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resume Lesson',
                    style: body(12.5, weight: FontWeight.w900, color: AppColors.text),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.play_arrow_rounded, size: 18, color: AppColors.text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
