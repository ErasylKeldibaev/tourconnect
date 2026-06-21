import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  bool get isLoggedIn => currentUser != null;

  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;
    if (user == null) return null;

    return await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
  }

  Future<void> updateProfile({
    required String fullName,
    String? phone,
    String? bio,
    String? avatarUrl,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await _client.from('profiles').upsert({
      'id': user.id,
      'full_name': fullName.trim(),
      'phone': phone?.trim(),
      'bio': bio?.trim(),
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<String?> uploadAvatar(File imageFile) async {
    final user = currentUser;
    if (user == null) return null;

    final fileExt = p.extension(imageFile.path);
    final fileName =
        '${user.id}_${DateTime.now().millisecondsSinceEpoch}$fileExt';

    await _client.storage.from('avatars').upload(
      fileName,
      imageFile,
      fileOptions: const FileOptions(
        upsert: true,
      ),
    );

    final imageUrl = _client.storage.from('avatars').getPublicUrl(fileName);

    await _client.from('profiles').upsert({
      'id': user.id,
      'avatar_url': imageUrl,
    });

    return imageUrl;
  }
}
