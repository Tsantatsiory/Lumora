import 'package:flutter/material.dart';

enum NotificationCategory {
  retention, // Rappels de streak, anti-churn, créneau personnalisé
  gamification, // Ligue, classement, vies/énergie, déblocages
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationCategory category;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String? ctaLabel;
  final int? targetNavIndex; // 0: Home, 1: Learn, 2: Rank, 3: Profile
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.ctaLabel,
    this.targetNavIndex,
    this.isRead = false,
  });
}

class NotificationRepository {
  static List<NotificationItem> getDefaultNotifications() {
    return [
      // 1. RAPPEL DE SÉRIE (Streak Rescue)
      NotificationItem(
        id: 'notif_streak_1',
        title: '⚠️ Sauvez votre série de 35 jours !',
        message: 'Plus que 2 heures avant minuit pour valider votre défi du jour et protéger vos 35 flammes.',
        category: NotificationCategory.retention,
        timeAgo: 'Il y a 30 min',
        icon: Icons.local_fire_department_rounded,
        iconColor: const Color(0xFFE5A632),
        iconBgColor: const Color(0xFFFDECD2),
        ctaLabel: 'Faire ma leçon (3 min) 🔥',
        targetNavIndex: 1, // Learn
        isRead: false,
      ),

      // 2. ÉVÉNEMENT DE LIGUE / CLASSEMENT
      NotificationItem(
        id: 'notif_league_1',
        title: '🚨 Dépassement au Classement !',
        message: 'David K. vient de gagner 50 XP et vous a dépassé. Vous êtes maintenant au Rang #5.',
        category: NotificationCategory.gamification,
        timeAgo: 'Il y a 2h',
        icon: Icons.emoji_events_rounded,
        iconColor: const Color(0xFF82976C),
        iconBgColor: const Color(0xFFE5EBE0),
        ctaLabel: 'Voir le classement 🏆',
        targetNavIndex: 2, // Rank
        isRead: false,
      ),

      // 3. RECHARGE D'ÉNERGIE / VIES
      NotificationItem(
        id: 'notif_energy_1',
        title: '❤️ Énergies entièrement rechargées',
        message: 'Vos 5 énergies d\'étude sont au maximum ! Prêt à continuer votre progression ?',
        category: NotificationCategory.gamification,
        timeAgo: 'Il y a 4h',
        icon: Icons.favorite_rounded,
        iconColor: const Color(0xFFE05252),
        iconBgColor: const Color(0xFFFFE5E5),
        ctaLabel: 'Reprendre l\'étude ▶',
        targetNavIndex: 1, // Learn
        isRead: true,
      ),

      // 4. CRÉNEAU PERSONNALISÉ (Habit Trigger)
      NotificationItem(
        id: 'notif_habit_1',
        title: '☕ Pause sagesse du matin',
        message: 'C\'est l\'heure idéale de votre pause café pour un court moment de réflexion biblique.',
        category: NotificationCategory.retention,
        timeAgo: 'Ce matin',
        icon: Icons.coffee_rounded,
        iconColor: const Color(0xFF82976C),
        iconBgColor: const Color(0xFFE5EBE0),
        ctaLabel: 'Méditer un verset 📖',
        targetNavIndex: 1, // Learn
        isRead: true,
      ),

      // 5. NOUVEAUTÉS & DÉBLOCAGES
      NotificationItem(
        id: 'notif_unlock_1',
        title: '🔓 Nouveau Chapitre Débloqué !',
        message: 'Félicitations pour vos 2 480 XP ! Le chapitre « Les Héros de la Foi » est désormais accessible.',
        category: NotificationCategory.gamification,
        timeAgo: 'Hier',
        icon: Icons.lock_open_rounded,
        iconColor: const Color(0xFF323232),
        iconBgColor: const Color(0xFFF6F6F6),
        ctaLabel: 'Découvrir le chapitre 🔓',
        targetNavIndex: 1, // Learn
        isRead: true,
      ),

      // 6. RAPPEL D'INACTIVITÉ (Anti-Churn)
      NotificationItem(
        id: 'notif_antichurn_1',
        title: '🌱 Votre parcours vous attend',
        message: '5 petites minutes suffisent pour nourrir votre foi aujourd\'hui. Chaque jour compte !',
        category: NotificationCategory.retention,
        timeAgo: 'Il y a 2 jours',
        icon: Icons.spa_rounded,
        iconColor: const Color(0xFF82976C),
        iconBgColor: const Color(0xFFE5EBE0),
        ctaLabel: 'Continuer le parcours ✨',
        targetNavIndex: 0, // Home
        isRead: true,
      ),
    ];
  }
}
