import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/lumora_bottom_nav.dart';
import '../widgets/lumora_toast.dart';
import 'auth_screen.dart';
import 'friends_screen.dart';

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
  int? openFriendsTab; // 0: Followers, 1: Following
  bool showAuthModal = false;

  final AuthService _auth = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _auth.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

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
      'text':
          'Trust in the Lord with all your heart, and do not lean on your own understanding.',
      'category': 'Trust',
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _savedVersesByUser = {};

  bool get _isDemoProfile => _auth.currentUser.uid == 'demo_user_01';

  List<Map<String, dynamic>> get _currentBadges => _isDemoProfile
      ? _badges
      : [
          {
            'title': 'Bienvenue',
            'subtitle': 'Votre aventure Lumora commence',
            'tag': 'Départ',
            'icon': Icons.waving_hand_rounded,
            'sticker': 'NEW',
            'bgColor': AppColors.chipBg,
            'date': 'Débloqué aujourd’hui',
          },
        ];

  List<Map<String, dynamic>> get _currentActivities => _isDemoProfile
      ? _activities
      : [
          {
            'title': 'Compte créé',
            'xp': '+25 XP',
            'time': 'Aujourd’hui',
            'icon': Icons.auto_awesome_rounded,
            'iconColor': AppColors.lime,
          },
        ];

  List<Map<String, dynamic>> get _currentSavedVerses => _isDemoProfile
      ? _savedVerses
      : _savedVersesByUser.putIfAbsent(_auth.currentUser.uid, () => []);

  @override
  Widget build(BuildContext context) {
    if (showAuthModal) {
      return AuthScreen(
        onAuthSuccess: () => setState(() => showAuthModal = false),
      );
    }

    if (openFriendsTab != null) {
      return FriendsScreen(
        initialTabIndex: openFriendsTab!,
        onBack: () => setState(() => openFriendsTab = null),
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
                            child: const Icon(Icons.arrow_back_rounded,
                                size: 20, color: AppColors.text),
                          ),
                        ),
                      if (widget.onBack != null) const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${user.username} • Level ${user.level} Seeker',
                          style: heading(14,
                              weight: FontWeight.w900, color: AppColors.text),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          _IconButton(
                            icon: Icons.logout_rounded,
                            onTap: () {
                              _auth.logout();
                              setState(() => showAuthModal = true);
                            },
                          ),
                          const SizedBox(width: 8),
                          _IconButton(
                            icon: Icons.share_outlined,
                            onTap: () => showLumoraToast(
                                context, 'Lien de profil copié ! 📋'),
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
                        // Cover Banner with Avatar Overlap
                        _buildCoverWithAvatar(user),
                        const SizedBox(height: 14),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Name with Verified Checkmark Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(user.displayName,
                                      style:
                                          heading(22, weight: FontWeight.w900)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: AppColors.lime,
                                      shape: BoxShape.circle,
                                      border: AppBorders.neo(width: 1.5),
                                    ),
                                    child: const Icon(Icons.check_rounded,
                                        size: 14, color: AppColors.surface),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Followers & Following (Friends system)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        setState(() => openFriendsTab = 0),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: AppBorders.neo(width: 1.5),
                                        boxShadow: AppShadows.neo(offset: 1.8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('${user.followersCount}',
                                              style: heading(12.5,
                                                  weight: FontWeight.w900)),
                                          const SizedBox(width: 4),
                                          Text('Followers',
                                              style: body(11,
                                                  color: AppColors.muted,
                                                  weight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () =>
                                        setState(() => openFriendsTab = 1),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: AppBorders.neo(width: 1.5),
                                        boxShadow: AppShadows.neo(offset: 1.8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('${user.followingCount}',
                                              style: heading(12.5,
                                                  weight: FontWeight.w900)),
                                          const SizedBox(width: 4),
                                          Text('Following',
                                              style: body(11,
                                                  color: AppColors.muted,
                                                  weight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Bio Quote
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.line),
                                ),
                                child: Text(
                                  user.bio,
                                  style: body(11.5,
                                      color: AppColors.text, height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 18),

                              // 3 Key Stats Boxes
                              Row(
                                children: [
                                  _buildStatBox('${user.totalXp}', 'Total XP',
                                      Icons.bolt_rounded, AppColors.lime),
                                  const SizedBox(width: 10),
                                  _buildStatBox(
                                      '${user.streakDays}',
                                      'Day Streak',
                                      Icons.local_fire_department_rounded,
                                      AppColors.amber),
                                  const SizedBox(width: 10),
                                  _buildStatBox(
                                      '${user.badgesCount}',
                                      'Badges',
                                      Icons.military_tech_rounded,
                                      AppColors.amber),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Action Buttons Row (Main CTA + Options)
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: _showEditProfileDialog,
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.button),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.bannerBg,
                                          borderRadius: BorderRadius.circular(
                                              AppRadius.button),
                                          border: AppBorders.neo(width: 2.2),
                                          boxShadow:
                                              AppShadows.neo(offset: 3.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Edit Profile',
                                              style: body(13.5,
                                                  weight: FontWeight.w900,
                                                  color: AppColors.text),
                                            ),
                                            const SizedBox(width: 6),
                                            const Icon(Icons.add_rounded,
                                                size: 18,
                                                color: AppColors.text),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => showLumoraToast(
                                        context, 'More options'),
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.button),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.button),
                                        border: AppBorders.neo(width: 2.2),
                                        boxShadow: AppShadows.neo(offset: 3.0),
                                      ),
                                      child: const Icon(Icons.more_vert_rounded,
                                          size: 22, color: AppColors.text),
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
                                      onTap: () =>
                                          setState(() => selectedTab = i),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                  ),
                                                ),
                                              Text(
                                                _tabs[i],
                                                style: heading(
                                                  16,
                                                  weight: isSelected
                                                      ? FontWeight.w900
                                                      : FontWeight.w600,
                                                  color: isSelected
                                                      ? AppColors.text
                                                      : AppColors.muted,
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
  Widget _buildCoverWithAvatar(user) {
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
                  user.bannerUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.bannerBg),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: AppBorders.neo(width: 1.5),
                      boxShadow: AppShadows.neo(offset: 1.5),
                    ),
                    child: Text(
                      'LUMORA LEARNER',
                      style: body(9.5,
                          weight: FontWeight.w900, color: AppColors.text),
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
                user.avatarUrl,
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
  Widget _buildStatBox(
      String value, String label, IconData icon, Color iconColor) {
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

  /// Grille de badges minimaliste : icône cerclée + nom.
  Widget _buildBadgesGrid(bool isWide) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 6 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: _currentBadges.length,
      itemBuilder: (context, i) {
        final badge = _currentBadges[i];
        return InkWell(
          onTap: () =>
              showLumoraToast(context, '${badge['title']} badge selected!'),
          borderRadius: BorderRadius.circular(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: badge['bgColor'] as Color,
                  shape: BoxShape.circle,
                  border: AppBorders.neo(width: 2),
                  boxShadow: AppShadows.neo(offset: 2.5),
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: AppBorders.neo(width: 1.5),
                    ),
                    child: Icon(badge['icon'] as IconData,
                        size: 25, color: AppColors.text),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                badge['title'] as String,
                style: body(11, weight: FontWeight.w900),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Activity List
  Widget _buildActivityList() {
    return Column(
      children: List.generate(_currentActivities.length, (i) {
        final act = _currentActivities[i];
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
                child: Icon(act['icon'] as IconData,
                    size: 20, color: act['iconColor'] as Color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(act['title'] as String,
                        style: heading(12.5, weight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(act['time'] as String,
                        style: body(10, color: AppColors.muted)),
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
                child: Text(act['xp'] as String,
                    style: body(10.5, weight: FontWeight.w900)),
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
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _showAddVerseDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Ajouter un verset'),
          ),
        ),
        if (_currentSavedVerses.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Aucun verset enregistré pour ce compte.',
                style: body(12, color: AppColors.muted)),
          ),
        ...List.generate(_currentSavedVerses.length, (i) {
          final verse = _currentSavedVerses[i];
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
                    Text(verse['reference'] as String,
                        style: heading(14, weight: FontWeight.w900)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.chipBg,
                        borderRadius: BorderRadius.circular(6),
                        border: AppBorders.neo(width: 1.2),
                      ),
                      child: Text(verse['category'] as String,
                          style: body(9.5, weight: FontWeight.w800)),
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
      ],
    );
  }

  Future<void> _showEditProfileDialog() async {
    final user = _auth.currentUser;
    final nameController = TextEditingController(text: user.displayName);
    final usernameController =
        TextEditingController(text: user.username.replaceFirst('@', ''));
    final bioController = TextEditingController(text: user.bio);
    var avatar = user.avatarUrl;
    var banner = user.bannerUrl;
    const avatars = [
      'assets/images/profile_avatar.jpg',
      'assets/images/lesson_faith.jpg'
    ];
    const banners = [
      'assets/images/profile_banner.jpg',
      'assets/images/lesson_miracles.jpg',
      'assets/images/lesson_living.jpg'
    ];

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Modifier le profil', style: heading(18)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Nom affiché')),
                TextField(
                  controller: usernameController,
                  enabled: _auth.usernameChangeDaysRemaining == 0,
                  decoration: InputDecoration(
                    labelText: 'Identifiant (@username)',
                    helperText: _auth.usernameChangeDaysRemaining == 0
                        ? 'Modifiable une fois tous les 30 jours'
                        : 'Modifiable dans ${_auth.usernameChangeDaysRemaining} jours',
                  ),
                ),
                TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Bio')),
                const SizedBox(height: 14),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo de profil',
                        style: body(12, weight: FontWeight.w900))),
                Wrap(
                  spacing: 8,
                  children: avatars
                      .map((path) => ChoiceChip(
                            label: const Text('Choisir'),
                            selected: avatar == path,
                            onSelected: (_) =>
                                setDialogState(() => avatar = path),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Bannière',
                        style: body(12, weight: FontWeight.w900))),
                Wrap(
                  spacing: 8,
                  children: banners
                      .map((path) => ChoiceChip(
                            label: const Text('Choisir'),
                            selected: banner == path,
                            onSelected: (_) =>
                                setDialogState(() => banner = path),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Annuler')),
            FilledButton(
              onPressed: () {
                final requestedUsername = usernameController.text.trim();
                if ('@$requestedUsername' != user.username) {
                  final error = _auth.updateUsername(requestedUsername);
                  if (error != null) {
                    showLumoraToast(this.context, error);
                    return;
                  }
                }
                _auth.updateProfile(
                  displayName: nameController.text.trim().isEmpty
                      ? user.displayName
                      : nameController.text.trim(),
                  bio: bioController.text.trim(),
                  avatarUrl: avatar,
                  bannerUrl: banner,
                );
                Navigator.pop(dialogContext);
                showLumoraToast(this.context, 'Profil mis à jour ✓');
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
  }

  Future<void> _showAddVerseDialog() async {
    final referenceController = TextEditingController();
    final textController = TextEditingController();
    final categoryController = TextEditingController(text: 'Favori');
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Enregistrer un verset', style: heading(18)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: referenceController,
                  decoration: const InputDecoration(labelText: 'Référence')),
              TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'Texte du verset')),
              TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Catégorie')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              if (referenceController.text.trim().isEmpty ||
                  textController.text.trim().isEmpty) {
                return;
              }
              setState(() {
                _currentSavedVerses.add({
                  'reference': referenceController.text.trim(),
                  'text': textController.text.trim(),
                  'category': categoryController.text.trim().isEmpty
                      ? 'Favori'
                      : categoryController.text.trim(),
                });
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    referenceController.dispose();
    textController.dispose();
    categoryController.dispose();
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
