import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkMode = false;
  String _selectedLanguage = 'Русский';

  void _showLanguagePicker() {
    final languages = ['Русский', 'English', 'Кыргызча', 'Deutsch'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Язык приложения',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 8),
            ...languages.map((lang) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(lang,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
              trailing: _selectedLanguage == lang
                  ? const Icon(Icons.check_rounded,
                  color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = lang);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.travel_explore_rounded,
                  color: Colors.white, size: 36),
            ),
            const SizedBox(height: 16),
            const Text('TourConnect',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Версия 2.0.0',
                style: TextStyle(color: AppColors.textHint, fontSize: 13)),
            const SizedBox(height: 12),
            const Text(
              'Приложение для путешественников — находите города, места и туры по всему миру.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрыть',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── HEADER ─────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primary,
                          Color(0xFF1AAFAF),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color(0xFFE0F2F1),
                                  child: Icon(Icons.person_rounded,
                                      size: 42, color: AppColors.primary),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      color: AppColors.accent,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.edit_rounded,
                                      color: Colors.white, size: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('Jane Traveler',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('✈️ Путешественник ур. 5',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── STATS ───────────────────────────────────────
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        child: _StatsRow(provider: provider),
                      ),

                      const SizedBox(height: 28),

                      // ── НАСТРОЙКИ ───────────────────────────────────
                      FadeInUp(
                        delay: const Duration(milliseconds: 80),
                        child: const _SectionTitle('Настройки'),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: _SettingsCard(
                          children: [
                            _SwitchTile(
                              icon: Icons.notifications_outlined,
                              iconColor: AppColors.accent,
                              label: 'Уведомления',
                              subtitle: 'Скидки, новые туры и места',
                              value: _notificationsEnabled,
                              onChanged: (v) =>
                                  setState(() => _notificationsEnabled = v),
                            ),
                            const _Divider(),
                            _SwitchTile(
                              icon: Icons.location_on_outlined,
                              iconColor: AppColors.catSightseeing,
                              label: 'Геолокация',
                              subtitle: 'Для поиска мест рядом',
                              value: _locationEnabled,
                              onChanged: (v) =>
                                  setState(() => _locationEnabled = v),
                            ),
                            const _Divider(),
                            _SwitchTile(
                              icon: Icons.dark_mode_outlined,
                              iconColor: AppColors.catHistory,
                              label: 'Тёмная тема',
                              subtitle: 'Переключить оформление',
                              value: _darkMode,
                              onChanged: (v) =>
                                  setState(() => _darkMode = v),
                            ),
                            const _Divider(),
                            _NavTile(
                              icon: Icons.language_rounded,
                              iconColor: AppColors.catNature,
                              label: 'Язык',
                              value: _selectedLanguage,
                              onTap: _showLanguagePicker,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── АККАУНТ ─────────────────────────────────────
                      FadeInUp(
                        delay: const Duration(milliseconds: 140),
                        child: const _SectionTitle('Аккаунт'),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        delay: const Duration(milliseconds: 160),
                        child: _SettingsCard(
                          children: [
                            _NavTile(
                              icon: Icons.person_outline_rounded,
                              iconColor: AppColors.primary,
                              label: 'Редактировать профиль',
                              onTap: () {},
                            ),
                            const _Divider(),
                            _NavTile(
                              icon: Icons.lock_outline_rounded,
                              iconColor: AppColors.catSightseeing,
                              label: 'Изменить пароль',
                              onTap: () {},
                            ),
                            const _Divider(),
                            _NavTile(
                              icon: Icons.shield_outlined,
                              iconColor: AppColors.catHistory,
                              label: 'Безопасность',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── ПОДДЕРЖКА ───────────────────────────────────
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: const _SectionTitle('Поддержка'),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        delay: const Duration(milliseconds: 220),
                        child: _SettingsCard(
                          children: [
                            _NavTile(
                              icon: Icons.help_outline_rounded,
                              iconColor: AppColors.successColor,
                              label: 'Центр помощи',
                              onTap: () {},
                            ),
                            const _Divider(),
                            _NavTile(
                              icon: Icons.chat_bubble_outline_rounded,
                              iconColor: AppColors.catFood,
                              label: 'Написать нам',
                              onTap: () {},
                            ),
                            const _Divider(),
                            _NavTile(
                              icon: Icons.privacy_tip_outlined,
                              iconColor: AppColors.textSecondary,
                              label: 'Политика конфиденциальности',
                              onTap: () {},
                            ),
                            const _Divider(),
                            _NavTile(
                              icon: Icons.info_outline_rounded,
                              iconColor: AppColors.textSecondary,
                              label: 'О приложении',
                              onTap: _showAboutDialog,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── ОПАСНАЯ ЗОНА ─────────────────────────────────
                      FadeInUp(
                        delay: const Duration(milliseconds: 260),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.errorColor.withValues(alpha: 0.25)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3))
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 2),
                                leading: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color:
                                    AppColors.errorColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.logout_rounded,
                                      color: AppColors.errorColor, size: 20),
                                ),
                                title: const Text('Выйти из аккаунта',
                                    style: TextStyle(
                                        color: AppColors.errorColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: AppColors.errorColor),
                                onTap: () {},
                              ),
                              const Divider(
                                  height: 1,
                                  indent: 60,
                                  color: AppColors.divider),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 2),
                                leading: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color:
                                    AppColors.errorColor.withValues(alpha: 0.07),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.delete_outline_rounded,
                                      color: AppColors.errorColor
                                          .withValues(alpha: 0.7),
                                      size: 20),
                                ),
                                title: Text('Удалить аккаунт',
                                    style: TextStyle(
                                        color: AppColors.errorColor
                                            .withValues(alpha: 0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: AppColors.errorColor
                                        .withValues(alpha: 0.5)),
                                onTap: () {},
                              ),
                            ],
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary),
  );
}

class _StatsRow extends StatelessWidget {
  final TravelProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem('12', 'Посещено', Icons.flag_rounded, AppColors.primary),
          _vDivider(),
          _StatItem('45', 'Отзывов', Icons.rate_review_rounded, AppColors.accent),
          _vDivider(),
          _StatItem(
              '${provider.totalFavoritesCount}',
              'Сохранено',
              Icons.favorite_rounded,
              Colors.redAccent),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
      width: 1, height: 48, color: AppColors.divider);
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatItem(this.value, this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 60, color: AppColors.divider);
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textPrimary)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontSize: 11, color: AppColors.textHint)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.textPrimary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value!,
                style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.textHint),
        ],
      ),
      onTap: onTap,
    );
  }
}