import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/firestore/user_profile_model.dart';

class LocalAccountStore {
  static const _accountsKey = 'lumora_accounts_v1';
  static const _sessionKey = 'lumora_active_user_v1';
  static const _followingKey = 'lumora_following_v1';

  Future<Map<String, Map<String, dynamic>>> readAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accountsKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)));
  }

  Future<List<UserProfileModel>> readProfiles() async => (await readAccounts())
      .values
      .map((account) => UserProfileModel.fromLocalJson(Map<String, dynamic>.from(account['profile'] as Map)))
      .toList();

  Future<void> saveAccount(UserProfileModel profile, String password) async {
    final accounts = await readAccounts();
    accounts[profile.email.toLowerCase()] = {'profile': profile.toLocalJson(), 'password': password};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    final accounts = await readAccounts();
    final existing = accounts[profile.email.toLowerCase()];
    if (existing == null) return;
    accounts[profile.email.toLowerCase()] = {
      'profile': profile.toLocalJson(),
      'password': existing['password'],
    };
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  Future<UserProfileModel?> login(String email, String password) async {
    final account = (await readAccounts())[email.toLowerCase()];
    if (account == null || account['password'] != password) return null;
    return UserProfileModel.fromLocalJson(Map<String, dynamic>.from(account['profile'] as Map));
  }

  Future<bool> usernameExists(String username, {String? excludingEmail}) async {
    final normalized = username.toLowerCase();
    final accounts = await readAccounts();
    return accounts.entries.any((entry) => entry.key != excludingEmail?.toLowerCase() &&
        (entry.value['profile'] as Map)['username'].toString().toLowerCase() == normalized);
  }

  Future<void> saveSession(String? email) async {
    final prefs = await SharedPreferences.getInstance();
    if (email == null) {
      await prefs.remove(_sessionKey);
    } else {
      await prefs.setString(_sessionKey, email.toLowerCase());
    }
  }

  Future<UserProfileModel?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_sessionKey);
    if (email == null) return null;
    final account = (await readAccounts())[email];
    if (account == null) return null;
    return UserProfileModel.fromLocalJson(Map<String, dynamic>.from(account['profile'] as Map));
  }

  Future<Map<String, Set<String>>> readFollowing() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_followingKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((uid, ids) => MapEntry(uid, Set<String>.from(ids as List)));
  }

  Future<void> saveFollowing(Map<String, Set<String>> following) async {
    final prefs = await SharedPreferences.getInstance();
    final json = following.map((uid, ids) => MapEntry(uid, ids.toList()));
    await prefs.setString(_followingKey, jsonEncode(json));
  }
}
