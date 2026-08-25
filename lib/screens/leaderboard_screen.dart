import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/lumora_bottom_nav.dart';
import '../widgets/lumora_toast.dart';
import '../services/auth_service.dart';

class LeaderboardScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final ValueChanged<int>? onTabChange;

  const LeaderboardScreen({super.key, this.onBack, this.onTabChange});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int selectedPeriod = 0; // 0 = This Week, 1 = All Time, 2 = Friends
  int navIndex = 2; // Rank tab

  static const _periods = ['This Week', 'All Time', 'Friends'];

  final List<Map<String, dynamic>> _topUsers = [
    {
      'rank': 1,
      'name': 'Sarah M.',
      'handle': '@sarah_faith',
      'level': 12,
      'xp': 4820,
      'streak': 54,
      'avatar': '👩‍🎓',
      'isYou': false,
    },
    {
      'rank': 2,
      'name': 'David K.',
      'handle': '@david_psalms',
      'level': 11,
      'xp': 3950,
      'streak': 42,
      'avatar': '🧑‍💼',
      'isYou': false,
    },
    {
      'rank': 3,
      'name': 'Esther L.',
      'handle': '@esther_grace',
      'level': 10,
      'xp': 3410,
      'streak': 38,
      'avatar': '👩‍🎨',
      'isYou': false,
    },
    {
      'rank': 4,
      'name': 'Samuel B.',
      'handle': '@samuel_seeker',
      'level': 9,
      'xp': 2890,
      'streak': 29,
      'avatar': '👨‍🚀',
      'isYou': false,
    },
    {
      'rank': 5,
      'name': 'Tsanta Tsiory',
      'handle': '@tsanta_tsiory',
      'level': 8,
      'xp': 2480,
      'streak': 35,
      'avatar': '🧑‍💻',
      'isYou': true,
    },
    {
      'rank': 6,
      'name': 'Rachel P.',
      'handle': '@rachel_light',
      'level': 8,
      'xp': 2310,
      'streak': 21,
      'avatar': '👩‍🔬',
      'isYou': false,
    },
    {
      'rank': 7,
      'name': 'Joshua N.',
      'handle': '@joshua_valiant',
      'level': 7,
      'xp': 1980,
      'streak': 18,
      'avatar': '👨‍🏫',
      'isYou': false,
    },
    {
      'rank': 8,
      'name': 'Miriam T.',
      'handle': '@miriam_song',
      'level': 7,
      'xp': 1750,
      'streak': 15,
      'avatar': '👩‍⚕️',
      'isYou': false,
    },
    {
      'rank': 9,
      'name': 'Daniel V.',
      'handle': '@daniel_wisdom',
      'level': 6,
      'xp': 1520,
      'streak': 12,
      'avatar': '👨‍🌾',
      'isYou': false,
    },
    {
      'rank': 10,
      'name': 'Hannah G.',
      'handle': '@hannah_prayer',
      'level': 6,
      'xp': 1400,
      'streak': 9,
      'avatar': '👩‍🍳',
      'isYou': false,
    },
  ];

  List<Map<String, dynamic>> get _dynamicTopUsers {
    final auth = AuthService.instance;
    final profiles = [...auth.profiles];
    if (profiles.isEmpty) return _topUsers;
    if (!profiles.any((profile) => profile.uid == auth.currentUser.uid)) {
      profiles.add(auth.currentUser);
    }
    profiles.sort((a, b) => b.totalXp.compareTo(a.totalXp));
    return profiles.asMap().entries.map((entry) {
      final user = entry.value;
      return {
        'rank': entry.key + 1,
        'name': user.displayName,
        'handle': user.username,
        'level': user.level,
        'xp': user.totalXp,
        'streak': user.streakDays,
        'avatar': user.username.contains('sarah') ? '👩‍🎓' : user.username.contains('david') ? '🧑‍💼' : user.username.contains('esther') ? '👩‍🎨' : '🧑‍💻',
        'isYou': user.uid == auth.currentUser.uid,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    final topUsers = _dynamicTopUsers;
    final rank1 = topUsers[0];
    final rank2 = topUsers[1];
    final rank3 = topUsers[2];
    final remainingUsers = topUsers.sublist(3);
    final currentUser = topUsers.firstWhere((u) => u['isYou'] == true);

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
                          Text('Leaderboard', style: heading(22, letterSpacing: -0.5)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.bannerBg,
                          borderRadius: BorderRadius.circular(20),
                          border: AppBorders.neo(width: 1.8),
                          boxShadow: AppShadows.neo(offset: 2.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events_rounded, size: 15, color: AppColors.surface),
                            const SizedBox(width: 5),
                            Text(
                              'League #1',
                              style: body(11, color: AppColors.surface, weight: FontWeight.w900),
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
                        children: [
                          const SizedBox(height: 8),

                          // Period Filter Switcher (This Week / All Time / Friends)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: AppBorders.neo(width: 2.0),
                              boxShadow: AppShadows.neo(offset: 2.5),
                            ),
                            child: Row(
                              children: List.generate(_periods.length, (i) {
                                final isSelected = selectedPeriod == i;
                                return Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => selectedPeriod = i);
                                      showLumoraToast(context, '${_periods[i]} ranking updated');
                                    },
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
                                        _periods[i],
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
                          const SizedBox(height: 20),

                          // Visual Podium for Top 3 (2nd, 1st, 3rd)
                          _buildTop3Podium(rank1, rank2, rank3),
                          const SizedBox(height: 18),

                          // Current User Highlight Card (Sticky position preview)
                          _buildCurrentUserBanner(currentUser),
                          const SizedBox(height: 18),

                          // Section Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('All Seekers', style: heading(16, weight: FontWeight.w900)),
                              Text('Top 10 this week',
                                  style: body(11, color: AppColors.muted, weight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Remaining Users List (#4 - #10)
                          Column(
                            children: remainingUsers.map((user) => _buildUserRankTile(user)).toList(),
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

  /// Top 3 Podium Widget (2nd, 1st, 3rd)
  Widget _buildTop3Podium(
    Map<String, dynamic> rank1,
    Map<String, dynamic> rank2,
    Map<String, dynamic> rank3,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // #2 Silver (Left)
        Expanded(
          child: _buildPodiumColumn(
            user: rank2,
            rankText: '🥈 #2',
            columnHeight: 110,
            avatarSize: 52,
            isFirst: false,
          ),
        ),
        const SizedBox(width: 8),

        // #1 Gold (Center - Highest)
        Expanded(
          child: _buildPodiumColumn(
            user: rank1,
            rankText: '👑 #1',
            columnHeight: 140,
            avatarSize: 64,
            isFirst: true,
          ),
        ),
        const SizedBox(width: 8),

        // #3 Bronze (Right)
        Expanded(
          child: _buildPodiumColumn(
            user: rank3,
            rankText: '🥉 #3',
            columnHeight: 95,
            avatarSize: 52,
            isFirst: false,
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumColumn({
    required Map<String, dynamic> user,
    required String rankText,
    required double columnHeight,
    required double avatarSize,
    required bool isFirst,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar with crown/rank
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: isFirst ? AppColors.lime : AppColors.surface,
                shape: BoxShape.circle,
                border: AppBorders.neo(width: isFirst ? 2.5 : 2.0),
                boxShadow: AppShadows.neo(offset: 2.5),
              ),
              alignment: Alignment.center,
              child: Text(
                user['avatar'] as String,
                style: TextStyle(fontSize: avatarSize * 0.48),
              ),
            ),
            Positioned(
              bottom: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isFirst ? AppColors.lime : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: AppBorders.neo(width: 1.2),
                ),
                child: Text(
                  rankText,
                  style: body(9, weight: FontWeight.w900, color: isFirst ? AppColors.surface : AppColors.text),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Name & XP text
        Text(
          user['name'] as String,
          style: heading(12, weight: FontWeight.w900),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.chipBg,
            borderRadius: BorderRadius.circular(4),
            border: AppBorders.neo(width: 1.0),
          ),
          child: Text(
            '${user['xp']} XP',
            style: body(9.5, weight: FontWeight.w900, color: AppColors.text),
          ),
        ),
        const SizedBox(height: 6),

        // Podium Block
        Container(
          height: columnHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isFirst ? AppColors.lime : AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: AppBorders.neo(width: 2.2),
            boxShadow: AppShadows.neo(offset: 3.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LVL ${user['level']}',
                style: heading(
                  13,
                  weight: FontWeight.w900,
                  color: isFirst ? AppColors.surface : AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 2),
                  Text(
                    '${user['streak']}d',
                    style: body(
                      10,
                      weight: FontWeight.w800,
                      color: isFirst ? AppColors.surface : AppColors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Current Logged-in User Position Banner
  Widget _buildCurrentUserBanner(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: 2.2),
        boxShadow: AppShadows.neo(offset: 3.0),
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: AppBorders.neo(width: 1.8),
            ),
            child: Text(
              '#${user['rank']}',
              style: heading(13, weight: FontWeight.w900, color: AppColors.text),
            ),
          ),
          const SizedBox(width: 10),

          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: AppBorders.neo(width: 1.8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/profile_avatar.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(user['avatar'] as String, style: const TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name & You Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user['name'] as String,
                        style: heading(13.5, weight: FontWeight.w900, color: AppColors.surface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(5),
                        border: AppBorders.neo(width: 1.2),
                      ),
                      child: Text(
                        'YOU',
                        style: body(8.5, weight: FontWeight.w900, color: AppColors.text),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Level ${user['level']} • ${user['streak']} day streak 🔥',
                  style: body(10.5, color: AppColors.surface.withValues(alpha: 0.9), weight: FontWeight.w700),
                ),
              ],
            ),
          ),

          // Total XP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: AppBorders.neo(width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, size: 14, color: AppColors.text),
                const SizedBox(width: 2),
                Text(
                  '${user['xp']}',
                  style: body(11.5, weight: FontWeight.w900, color: AppColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Individual Rank Tile for #4 - #10
  Widget _buildUserRankTile(Map<String, dynamic> user) {
    final isYou = user['isYou'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isYou ? AppColors.chipBg : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: AppBorders.neo(width: isYou ? 2.2 : 1.8),
        boxShadow: AppShadows.neo(offset: isYou ? 2.5 : 2.0),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 28,
            child: Text(
              '#${user['rank']}',
              style: heading(13, weight: FontWeight.w900, color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),

          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.bg,
              shape: BoxShape.circle,
              border: AppBorders.neo(width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(user['avatar'] as String, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 10),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user['name'] as String,
                        style: heading(12.5, weight: FontWeight.w900),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isYou) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.lime,
                          borderRadius: BorderRadius.circular(4),
                          border: AppBorders.neo(width: 1.0),
                        ),
                        child: Text(
                          'YOU',
                          style: body(8, weight: FontWeight.w900, color: AppColors.surface),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LVL ${user['level']}',
                        style: body(9, color: AppColors.muted, weight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${user['streak']}d 🔥',
                      style: body(9.5, color: AppColors.amber, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // XP Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(8),
              border: AppBorders.neo(width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, size: 13, color: AppColors.text),
                const SizedBox(width: 2),
                Text(
                  '${user['xp']} XP',
                  style: body(10.5, weight: FontWeight.w900, color: AppColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
