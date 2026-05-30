import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class AuthProfileScreen extends StatefulWidget {
  const AuthProfileScreen({super.key});

  @override
  State<AuthProfileScreen> createState() => _AuthProfileScreenState();
}

class _AuthProfileScreenState extends State<AuthProfileScreen> {
  final _authService = AuthService();
  final _supabase = Supabase.instance.client;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _isEditing = false;
  bool _profileLoaded = false;

  User? get _user => _authService.currentUser;
  String get _displayEmail => _user?.email ?? '—';

  String get _createdAt {
    final raw = _user?.createdAt;
    if (raw == null) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final uid = _user?.id;
    if (uid == null) return;
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', uid)
          .maybeSingle();
      if (data != null && mounted) {
        _nameController.text = data['full_name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _bioController.text = data['bio'] ?? '';
      }
    } catch (_) {
      // таблица может ещё не существовать — молча игнорируем
    } finally {
      if (mounted) setState(() => _profileLoaded = true);
    }
  }

  Future<void> _saveProfile() async {
    final uid = _user?.id;
    if (uid == null) return;
    setState(() => _isSaving = true);
    try {
      await _supabase.from('profiles').upsert({
        'id': uid,
        'full_name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      if (!mounted) return;
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Профиль сохранён'),
          ]),
          backgroundColor: AppColors.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сохранения: $e'),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      await _authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка выхода. Попробуйте ещё раз.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Выйти из аккаунта?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Вы будете перенаправлены на экран входа.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _logout();
            },
            child: const Text('Выйти',
                style: TextStyle(
                    color: AppColors.errorColor, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) return const LoginScreen();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HEADER ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryDark, AppColors.primary, Color(0xFF1AAFAF)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 32,
                left: 24,
                right: 24,
              ),
              child: FadeInDown(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: const Color(0xFFE0F2F1),
                            child: Text(
                              _nameController.text.isNotEmpty
                                  ? _nameController.text[0].toUpperCase()
                                  : (_displayEmail.isNotEmpty ? _displayEmail[0].toUpperCase() : '?'),
                              style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => _isEditing = true),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  color: AppColors.accent, shape: BoxShape.circle),
                              child: const Icon(Icons.edit_rounded,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text
                          : _displayEmail,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            user.emailConfirmedAt != null
                                ? Icons.verified_user_rounded
                                : Icons.info_outline_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            user.emailConfirmedAt != null
                                ? 'Email подтверждён'
                                : 'Email не подтверждён',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── EMAIL (read-only) ────────────────────────────────
                FadeInUp(
                  delay: const Duration(milliseconds: 80),
                  child: _SectionLabel('Аккаунт'),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: _InfoTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: _displayEmail,
                    trailing: IconButton(
                      icon: const Icon(Icons.copy_rounded,
                          size: 16, color: AppColors.textHint),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _displayEmail));
                        ScaffoldMessenger.of(context).showSnackBar(
                          _snack('Email скопирован'),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInUp(
                  delay: const Duration(milliseconds: 120),
                  child: _InfoTile(
                    icon: Icons.calendar_today_rounded,
                    label: 'Дата регистрации',
                    value: _createdAt,
                  ),
                ),

                const SizedBox(height: 28),

                // ── EDITABLE FIELDS ──────────────────────────────────
                FadeInUp(
                  delay: const Duration(milliseconds: 140),
                  child: Row(
                    children: [
                      const Expanded(child: _SectionLabel('Профиль')),
                      if (!_isEditing)
                        TextButton.icon(
                          onPressed: () => setState(() => _isEditing = true),
                          icon: const Icon(Icons.edit_rounded, size: 15),
                          label: const Text('Изменить'),
                          style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 160),
                  child: _EditableCard(
                    isEditing: _isEditing,
                    children: [
                      _EditRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Имя',
                        controller: _nameController,
                        enabled: _isEditing,
                        hint: 'Введите имя',
                        onChanged: (_) => setState(() {}),
                      ),
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                      _EditRow(
                        icon: Icons.phone_outlined,
                        label: 'Телефон',
                        controller: _phoneController,
                        enabled: _isEditing,
                        hint: '+996 ...',
                        keyboardType: TextInputType.phone,
                      ),
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                      _EditRow(
                        icon: Icons.short_text_rounded,
                        label: 'О себе',
                        controller: _bioController,
                        enabled: _isEditing,
                        hint: 'Расскажите о себе...',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                // ── SAVE / CANCEL ────────────────────────────────────
                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  FadeInUp(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _isEditing = false);
                              _loadProfile(); // отменить изменения
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.divider),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Отмена',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: _isSaving ? null : _saveProfile,
                            icon: _isSaving
                                ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.save_rounded, size: 18),
                            label: Text(_isSaving ? 'Сохранение...' : 'Сохранить'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // ── LOGOUT ───────────────────────────────────────────
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _showLogoutDialog,
                      icon: _isLoading
                          ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.errorColor))
                          : const Icon(Icons.logout_rounded,
                          color: AppColors.errorColor),
                      label: const Text('Выйти из аккаунта',
                          style: TextStyle(
                              color: AppColors.errorColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppColors.errorColor.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Center(
                  child: Text('TourConnect v2.0.0',
                      style: TextStyle(
                          color: AppColors.textHint, fontSize: 12)),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SnackBar _snack(String msg) => SnackBar(
    content: Text(msg),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
  );
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  const _InfoTile(
      {required this.icon,
        required this.label,
        required this.value,
        this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _EditableCard extends StatelessWidget {
  final bool isEditing;
  final List<Widget> children;
  const _EditableCard({required this.isEditing, required this.children});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isEditing
            ? Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _EditRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const _EditRow({
    required this.icon,
    required this.label,
    required this.controller,
    required this.enabled,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        crossAxisAlignment:
        maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 10 : 0),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: enabled
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: enabled ? AppColors.primary : AppColors.textHint,
                  size: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: enabled ? hint : null,
                    hintStyle: const TextStyle(
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w400),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}