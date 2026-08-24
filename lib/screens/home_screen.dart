import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/stats_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/lesson_card.dart';
import '../widgets/daily_challenge_card.dart';
import '../widgets/lumora_bottom_nav.dart';
import '../widgets/category_tile.dart';
import '../widgets/lumora_toast.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';
import 'leaderboard_screen.dart';
import 'learn_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;
  bool isShowingNotifications = false;
  bool dailyClaimed = false;
  final int xpGoal = 1000;

  final AuthService _auth = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _auth.addListener(_onAuthUpdate);
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthUpdate);
    super.dispose();
  }

  void _onAuthUpdate() {
    if (mounted) setState(() {});
  }

  void _claimXp() {
    if (dailyClaimed) {
      showLumoraToast(context, 'Daily XP already claimed ✓');
      return;
    }
    setState(() {
      dailyClaimed = true;
    });
    _auth.addXp(10);
    showLumoraToast(context, '+10 XP added! Keep going 🔥');
  }

  @override
  Widget build(BuildContext context) {
    if (isShowingNotifications) {
      return NotificationsScreen(
        onBack: () => setState(() => isShowingNotifications = false),
        onNavigateToTab: (index) {
          setState(() {
            isShowingNotifications = false;
            navIndex = index;
          });
        },
      );
    }

    if (navIndex == 3) {
      return ProfileScreen(
        onBack: () => setState(() => navIndex = 0),
        onTabChange: (i) => setState(() => navIndex = i),
      );
    }

    if (navIndex == 2) {
      return LeaderboardScreen(
        onBack: () => setState(() => navIndex = 0),
        onTabChange: (i) => setState(() => navIndex = i),
      );
    }

    if (navIndex == 1) {
      return LearnScreen(
        onBack: () => setState(() => navIndex = 0),
        onTabChange: (i) => setState(() => navIndex = i),
      );
    }

    final user = _auth.currentUser;
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
                _TopBar(
                  onBell: () => setState(() => isShowingNotifications = true),
                  onProfile: () => setState(() => navIndex = 3),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Welcome header pill
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Welcome back, ${user.displayName.split(' ').first} 👋',
                                  style: body(13, color: AppColors.muted, weight: FontWeight.w600)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.chipBg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: AppBorders.neo(width: 1.5),
                                  boxShadow: AppShadows.neo(offset: 1.5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.wb_sunny_rounded, size: 13, color: AppColors.text),
                                    const SizedBox(width: 4),
                                    Text('Day ${user.streakDays}',
                                        style: body(10.5, color: AppColors.text, weight: FontWeight.w900)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // 1. StatsCard Section
                          StatsCard(
                            xp: user.weeklyXp,
                            xpGoal: xpGoal,
                            level: user.level,
                            streak: user.streakDays,
                            totalXp: user.totalXp,
                            badges: user.badgesCount,
                            onViewAll: () => setState(() => navIndex = 3),
                          ),
                          const SizedBox(height: 24),

                          // 2. StreakCard Section
                          _SectionHeader(
                            title: 'Your Streak',
                            trailing: Text(
                              '${user.streakDays} days 🔥',
                              style: body(12, color: AppColors.amber, weight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(height: 12),
                          StreakCard(
                            streak: user.streakDays,
                            currentDayIndex: 4,
                            done: const [true, true, true, true, false, false, false],
                          ),
                          const SizedBox(height: 24),

                          // 3. LessonCard Section (Featured Lessons Grid)
                          _SectionHeader(
                            title: 'Featured Lessons',
                            trailing: _SeeAll(
                              text: 'View all',
                              onTap: () => setState(() => navIndex = 1),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: isWide ? 4 : 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.82,
                            children: [
                              LessonCard(
                                icon: Icons.auto_stories_rounded,
                                title: 'The Life of Jesus',
                                subtitle: 'Miracles & Ministry',
                                categoryTag: 'Gospels',
                                stickerTag: 'NEW',
                                trailingText: '+30 XP',
                                progress: 0.65,
                                headerColor: AppColors.chipBg,
                                onTap: () => setState(() => navIndex = 1),
                              ),
                              LessonCard(
                                icon: Icons.water_drop_rounded,
                                title: 'Walk on Water',
                                subtitle: 'Matthew 14:22',
                                categoryTag: 'Miracles',
                                stickerTag: '🔥',
                                trailingText: '+50 XP',
                                headerColor: AppColors.bg,
                                onTap: () => setState(() => navIndex = 1),
                              ),
                              LessonCard(
                                icon: Icons.favorite_rounded,
                                title: 'Love & Forgiveness',
                                subtitle: 'Christian Living',
                                categoryTag: 'Living',
                                stickerTag: '📌',
                                trailingText: '+25 XP',
                                progress: 0.3,
                                headerColor: AppColors.lime,
                                onTap: () => setState(() => navIndex = 1),
                              ),
                              LessonCard(
                                icon: Icons.shield_rounded,
                                title: 'David & Goliath',
                                subtitle: '1 Samuel 17',
                                categoryTag: 'Stories',
                                stickerTag: 'NEW',
                                trailingText: '+35 XP',
                                headerColor: AppColors.bannerBg,
                                onTap: () => setState(() => navIndex = 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 4. DailyChallengeCard Section
                          const _SectionHeader(title: 'Daily Quest'),
                          const SizedBox(height: 12),
                          DailyChallengeCard(
                            title: 'Who walked on water with Jesus?',
                            description: 'Test your knowledge with a quick 5-question Bible challenge.',
                            onStart: () => setState(() => navIndex = 1),
                          ),
                          const SizedBox(height: 24),

                          // 5. CategoryTile Section (Explore the Bible)
                          _SectionHeader(
                            title: 'Explore the Bible',
                            trailing: _SeeAll(
                              text: 'View all',
                              onTap: () => setState(() => navIndex = 1),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CategoryTile(
                                  icon: Icons.auto_awesome_rounded,
                                  title: 'Stories',
                                  subtitle: '28 lessons',
                                  onTap: () => setState(() => navIndex = 1),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CategoryTile(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  title: 'Teachings',
                                  subtitle: '16 lessons',
                                  onTap: () => setState(() => navIndex = 1),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CategoryTile(
                                  icon: Icons.history_edu_rounded,
                                  title: 'History',
                                  subtitle: '12 lessons',
                                  onTap: () => setState(() => navIndex = 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Quick Action Cards
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _claimXp,
                                  borderRadius: BorderRadius.circular(AppRadius.card),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(AppRadius.card),
                                      border: AppBorders.neo(width: 2.0),
                                      boxShadow: AppShadows.neo(offset: 3.0),
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
                                          child: const Icon(Icons.bolt_rounded, size: 22, color: AppColors.text),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Daily Check-in', style: heading(12.5, weight: FontWeight.w900)),
                                              Text('+10 XP ready', style: body(10, color: AppColors.lime2, weight: FontWeight.w800)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => navIndex = 2),
                                  borderRadius: BorderRadius.circular(AppRadius.card),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(AppRadius.card),
                                      border: AppBorders.neo(width: 2.0),
                                      boxShadow: AppShadows.neo(offset: 3.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: AppColors.bannerBg,
                                            borderRadius: BorderRadius.circular(10),
                                            border: AppBorders.neo(width: 1.5),
                                          ),
                                          child: const Icon(Icons.emoji_events_outlined, size: 20, color: AppColors.text),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Leaderboard', style: heading(12.5, weight: FontWeight.w900)),
                                              Text('Top #5 this week', style: body(10, color: AppColors.muted, weight: FontWeight.w700)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                LumoraBottomNav(
                  currentIndex: navIndex,
                  onTap: (i) {
                    setState(() => navIndex = i);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBell;
  final VoidCallback onProfile;
  const _TopBar({required this.onBell, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.surface,
                  border: AppBorders.neo(width: 2.2),
                  boxShadow: AppShadows.neo(offset: 2.5),
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/lumora_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('lumora', style: heading(22, letterSpacing: -0.5)),
                  Text('BIBLICAL LEARNING',
                      style: body(8.5, color: AppColors.lime2, weight: FontWeight.w900)
                          .copyWith(letterSpacing: 1.2)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _IconButton(
                icon: Icons.notifications_none_rounded,
                showDot: true,
                onTap: onBell,
              ),
              const SizedBox(width: 10),
              _IconButton(
                icon: Icons.person_outline_rounded,
                onTap: onProfile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final bool showDot;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap, this.showDot = false});

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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 20, color: AppColors.text),
              if (showDot)
                Positioned(
                  right: -1,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lime,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: heading(17, weight: FontWeight.w900)),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _SeeAll extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _SeeAll({this.text = 'See all', required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: AppBorders.neo(width: 1.5),
          boxShadow: AppShadows.neo(offset: 1.5),
        ),
        child: Text(text, style: body(11, color: AppColors.text, weight: FontWeight.w900)),
      ),
    );
  }
}
