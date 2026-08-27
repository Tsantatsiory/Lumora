import 'package:flutter/material.dart';

import '../services/social_service.dart';
import '../theme.dart';
import '../widgets/lumora_toast.dart';

class PublicProfileScreen extends StatefulWidget {
  final String userId;

  const PublicProfileScreen({super.key, required this.userId});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final SocialService _social = SocialService.instance;

  @override
  void initState() {
    super.initState();
    _social.addListener(_refresh);
  }

  @override
  void dispose() {
    _social.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _social.findById(widget.userId);
    final isFollowing = _social.isFollowing(widget.userId);
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Profil introuvable')));
    }

    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Expanded(child: Text('Profil', style: heading(22))),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                    child: Column(
                      children: [
                        Container(
                          height: 112,
                          decoration: BoxDecoration(
                            color: AppColors.bannerBg,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: AppBorders.neo(width: 2),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -42),
                          child: Container(
                            width: 84,
                            height: 84,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.chipBg,
                              shape: BoxShape.circle,
                              border: AppBorders.neo(width: 2.5),
                              boxShadow: AppShadows.neo(offset: 3),
                            ),
                            child: Text(user.avatar,
                                style: const TextStyle(fontSize: 40)),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -32),
                          child: Column(
                            children: [
                              Text(user.displayName,
                                  style: heading(23, weight: FontWeight.w900)),
                              const SizedBox(height: 3),
                              Text(user.username,
                                  style: body(13,
                                      color: AppColors.muted,
                                      weight: FontWeight.w700)),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  final following =
                                      await _social.toggleFollow(user.uid);
                                  if (!mounted) return;
                                  if (following == null) return;
                                  showLumoraToast(
                                    this.context,
                                    following
                                        ? 'Vous suivez maintenant ${user.displayName} ✓'
                                        : 'Vous ne suivez plus ${user.displayName}',
                                  );
                                },
                                borderRadius:
                                    BorderRadius.circular(AppRadius.button),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26, vertical: 11),
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? AppColors.surface
                                        : AppColors.lime,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.button),
                                    border: AppBorders.neo(width: 2),
                                    boxShadow: isFollowing
                                        ? null
                                        : AppShadows.neo(offset: 2.5),
                                  ),
                                  child: Text(
                                    isFollowing ? 'Abonné ✓' : 'Suivre +',
                                    style: body(13,
                                        weight: FontWeight.w900,
                                        color: isFollowing
                                            ? AppColors.text
                                            : AppColors.surface),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(user.bio,
                                  style: body(13, height: 1.45),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  _stat('${user.followersCount}', 'Abonnés'),
                                  const SizedBox(width: 10),
                                  _stat(
                                      '${user.followingCount}', 'Abonnements'),
                                  const SizedBox(width: 10),
                                  _stat('Niv. ${user.level}', '${user.xp} XP'),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.card),
                                  border: AppBorders.neo(width: 1.8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                        Icons.local_fire_department_rounded,
                                        color: AppColors.amber),
                                    const SizedBox(width: 7),
                                    Text(
                                        'Série actuelle : ${user.streak} jours',
                                        style:
                                            body(13, weight: FontWeight.w900)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Badges',
                                    style:
                                        heading(16, weight: FontWeight.w900)),
                              ),
                              const SizedBox(height: 12),
                              _buildBadges(user),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: AppBorders.neo(width: 1.5),
        ),
        child: Column(
          children: [
            Text(value, style: heading(14, weight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label,
                style:
                    body(9.5, color: AppColors.muted, weight: FontWeight.w700),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges(FriendUser user) {
    final badges = <Map<String, dynamic>>[
      {
        'title': 'Flame Keeper',
        'icon': Icons.local_fire_department_rounded,
        'color': AppColors.fireBg,
      },
      {
        'title': 'Gospel Scholar',
        'icon': Icons.menu_book_rounded,
        'color': AppColors.chipBg,
      },
      {
        'title': 'Prayer Warrior',
        'icon': Icons.favorite_rounded,
        'color': AppColors.bg,
      },
      if (user.level >= 10)
        {
          'title': 'Wisdom Seeker',
          'icon': Icons.auto_awesome_rounded,
          'color': AppColors.lime,
        },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: badge['color'] as Color,
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
        );
      },
    );
  }
}
