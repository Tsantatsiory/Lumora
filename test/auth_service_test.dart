import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumora_app/services/auth_service.dart';
import 'package:lumora_app/services/social_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final auth = AuthService.instance;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    auth.logout();
    await auth.restoreSession();
  });

  test('registration validates username and persists a session', () async {
    final invalid = await auth.register(
      fullName: 'Test User',
      username: '!',
      email: 'test@example.com',
      password: 'secret123',
    );
    expect(invalid, isFalse);

    final created = await auth.register(
      fullName: 'Test User',
      username: 'test_user',
      email: 'test@example.com',
      password: 'secret123',
    );
    expect(created, isTrue);
    expect(auth.currentUser.username, '@test_user');

    auth.logout();
    final loggedIn = await auth.login('test@example.com', 'secret123');
    expect(loggedIn, isTrue);
    expect(auth.currentUser.displayName, 'Test User');
  });

  test('username change is locked for 30 days', () async {
    await auth.register(
      fullName: 'Another User',
      username: 'another_user',
      email: 'another@example.com',
      password: 'secret123',
    );
    expect(auth.updateUsername('new_name'), isNull);
    expect(auth.currentUser.username, '@new_name');
    expect(auth.usernameChangeDaysRemaining, greaterThan(0));
    expect(auth.updateUsername('later_name'), isNotNull);
  });

  test('follow from a public profile updates and persists the relationship', () async {
    await auth.login('sarah@lumora.app', 'demo123');
    final social = SocialService.instance;
    await social.initialize();
    final target = auth.profiles.firstWhere((profile) => profile.username == '@david_psalms');
    final before = target.followersCount;

    expect(social.isFollowing(target.uid), isFalse);
    expect(await social.toggleFollow(target.uid), isTrue);
    expect(social.isFollowing(target.uid), isTrue);
    expect(auth.currentUser.followingCount, 1);
    expect(auth.profiles.firstWhere((profile) => profile.uid == target.uid).followersCount, before + 1);

    await social.initialize();
    expect(social.isFollowing(target.uid), isTrue);

    auth.logout();
    await auth.login('david@lumora.app', 'demo123');
    expect(social.followers.any((user) => user.username == '@sarah_faith'), isTrue);
  });
}
