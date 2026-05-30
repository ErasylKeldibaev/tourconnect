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
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
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
      'full_name': fullName,
      'phone': phone,
      'bio': bio,
      'avatar_url': avatarUrl,
    });
  }
}