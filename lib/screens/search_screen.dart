import 'package:flutter/material.dart';

import '../models/lesson_repository.dart';
import '../services/social_service.dart';
import '../theme.dart';
import 'public_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SearchScreen({super.key, required this.onBack});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _social = SocialService.instance;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final users = _social.allUsers.where((user) =>
        user.username.toLowerCase().contains(query) || user.displayName.toLowerCase().contains(query)).toList();
    final lessons = LessonRepository.getAllLessons().where((lesson) =>
        lesson.title.toLowerCase().contains(query) || lesson.category.toLowerCase().contains(query)).toList();
    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(children: [
                IconButton(onPressed: widget.onBack, icon: const Icon(Icons.arrow_back_rounded)),
                Expanded(child: Text('Rechercher', style: heading(22))),
              ]),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Comptes, leçons, bientôt…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  children: [
                    Text('Comptes', style: heading(16)),
                    const SizedBox(height: 8),
                    if (users.isEmpty) _empty('Aucun compte trouvé'),
                    ...users.map((user) => ListTile(
                          leading: CircleAvatar(child: Text(user.avatar)),
                          title: Text(user.displayName),
                          subtitle: Text(user.username),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PublicProfileScreen(userId: user.uid),
                          )),
                        )),
                    const SizedBox(height: 18),
                    Text('Leçons', style: heading(16)),
                    const SizedBox(height: 8),
                    if (lessons.isEmpty) _empty('Aucune leçon trouvée'),
                    ...lessons.map((lesson) => ListTile(
                          leading: const Icon(Icons.menu_book_rounded),
                          title: Text(lesson.title),
                          subtitle: Text('${lesson.category} • +${lesson.xpReward} XP'),
                        )),
                    const SizedBox(height: 18),
                    Text('À venir', style: heading(16)),
                    const ListTile(
                      leading: Icon(Icons.auto_awesome_rounded),
                      title: Text('Nouveaux parcours bibliques'),
                      subtitle: Text('Bientôt disponibles dans Lumora'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _empty(String message) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(message, style: body(12, color: AppColors.muted)),
      );
}
