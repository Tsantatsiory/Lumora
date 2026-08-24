import 'package:flutter/material.dart';
import '../services/social_service.dart';
import '../theme.dart';
import '../widgets/lumora_toast.dart';

class FriendsScreen extends StatefulWidget {
  final int initialTabIndex; // 0: Followers, 1: Following
  final VoidCallback onBack;

  const FriendsScreen({
    super.key,
    this.initialTabIndex = 0,
    required this.onBack,
  });

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late int selectedTab;
  final SocialService _socialService = SocialService.instance;

  static const _tabs = ['Abonnés (Followers)', 'Abonnements (Following)', 'Découvrir ✨'];

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTabIndex;
    _socialService.addListener(_onSocialUpdate);
  }

  @override
  void dispose() {
    _socialService.removeListener(_onSocialUpdate);
    super.dispose();
  }

  void _onSocialUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    final followers = _socialService.followers;
    final following = _socialService.following;
    final suggestions = _socialService.suggestions;

    List<FriendUser> currentList;
    if (selectedTab == 0) {
      currentList = followers;
    } else if (selectedTab == 1) {
      currentList = following;
    } else {
      currentList = suggestions;
    }

    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 680 : double.infinity),
            child: Column(
              children: [
                // Top Header Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                  child: Row(
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
                      Text('Amis & Abonnés', style: heading(22, letterSpacing: -0.5)),
                    ],
                  ),
                ),

                // Tabs Switcher
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: AppBorders.neo(width: 2.0),
                      boxShadow: AppShadows.neo(offset: 2.5),
                    ),
                    child: Row(
                      children: List.generate(_tabs.length, (i) {
                        final isSelected = selectedTab == i;
                        return Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedTab = i),
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
                                _tabs[i].split(' ').first,
                                style: body(
                                  11,
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
                ),

                // User Count Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _tabs[selectedTab],
                        style: heading(14, weight: FontWeight.w900),
                      ),
                      Text(
                        '${currentList.length} seekers',
                        style: body(11, color: AppColors.muted, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),

                // List of Users
                Expanded(
                  child: currentList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  border: AppBorders.neo(width: 2.0),
                                ),
                                child: const Icon(Icons.people_outline_rounded, size: 28, color: AppColors.muted),
                              ),
                              const SizedBox(height: 12),
                              Text('Aucun profil dans cette section', style: heading(14, color: AppColors.muted)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          itemCount: currentList.length,
                          itemBuilder: (context, i) {
                            final user = currentList[i];
                            return _buildUserCard(user);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(FriendUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: AppBorders.neo(width: 2.0),
        boxShadow: AppShadows.neo(offset: 2.0),
      ),
      child: Row(
        children: [
          // Avatar with Level Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              shape: BoxShape.circle,
              border: AppBorders.neo(width: 1.8),
            ),
            alignment: Alignment.center,
            child: Text(user.avatar, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),

          // Name, Handle & Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: heading(13.5, weight: FontWeight.w900),
                ),
                Text(
                  user.username,
                  style: body(10.5, color: AppColors.muted, weight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(4),
                        border: AppBorders.neo(width: 1.0),
                      ),
                      child: Text(
                        'LVL ${user.level}',
                        style: body(8.5, weight: FontWeight.w900, color: AppColors.text),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${user.xp} XP • ${user.streak}d 🔥',
                      style: body(9.5, weight: FontWeight.w700, color: AppColors.text),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Follow / Unfollow Button
          InkWell(
            onTap: () {
              _socialService.toggleFollow(user.uid);
              showLumoraToast(
                context,
                user.isFollowing
                    ? 'Vous suivez maintenant ${user.displayName} ✓'
                    : 'Abonnement retiré pour ${user.displayName}',
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: user.isFollowing ? AppColors.surface : AppColors.lime,
                borderRadius: BorderRadius.circular(8),
                border: AppBorders.neo(width: 1.5),
                boxShadow: user.isFollowing ? null : AppShadows.neo(offset: 1.8),
              ),
              child: Text(
                user.isFollowing ? 'Abonné ✓' : 'Suivre +',
                style: body(
                  11,
                  weight: FontWeight.w900,
                  color: user.isFollowing ? AppColors.text : AppColors.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
