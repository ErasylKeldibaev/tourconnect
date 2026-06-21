import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/travel_provider.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      final profile = await _authService.getProfile();
      if (!mounted) return;

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final strings = AppStrings(context.read<TravelProvider>().languageCode);
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.logoutQuestion),
        content: Text(strings.logoutBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text(strings.logOut),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;
    await _authService.logout();
  }

  String get _email {
    return _authService.currentUser?.email ?? 'No email';
  }

  String get _fullName {
    final name = _profile?['full_name'];
    if (name == null || name.toString().trim().isEmpty) {
      return 'TourConnect User';
    }
    return name.toString();
  }

  String get _phone {
    final phone = _profile?['phone'];
    if (phone == null || phone.toString().trim().isEmpty) {
      return 'No phone';
    }
    return phone.toString();
  }

  String get _bio {
    final bio = _profile?['bio'];
    if (bio == null || bio.toString().trim().isEmpty) {
      return 'Add a short travel bio to personalize your profile.';
    }
    return bio.toString();
  }

  String? get _avatarUrl {
    final avatar = _profile?['avatar_url'];
    if (avatar == null || avatar.toString().trim().isEmpty) return null;
    return avatar.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (!_authService.isLoggedIn) {
      return const _GuestProfileView();
    }

    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final strings = AppStrings(provider.languageCode);
        return Scaffold(
          backgroundColor: AppColors.background,
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadProfile,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      _buildHeader(strings),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStatsRow(provider, strings),
                              const SizedBox(height: 24),
                              _buildProfileInfo(strings),
                              const SizedBox(height: 32),
                              Text(
                                strings.account,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildMenuSection([
                                _MenuItem(
                                  Icons.person_outline_rounded,
                                  strings.editProfile,
                                  AppColors.primary,
                                  () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const EditProfileScreen(),
                                      ),
                                    );
                                    _loadProfile();
                                  },
                                ),
                                _MenuItem(
                                  Icons.notifications_outlined,
                                  strings.notifications,
                                  AppColors.accent,
                                  () => _showInfoSheet(
                                    title: 'Notifications',
                                    icon: Icons.notifications_active_rounded,
                                    color: AppColors.accent,
                                    body:
                                        'Trip reminders, saved-place alerts, and booking updates will appear here when connected to live notifications.',
                                    actionLabel: 'Copy preference note',
                                    copyText:
                                        'TourConnect notification preferences: trip reminders, saved-place alerts, booking updates.',
                                  ),
                                ),
                                _MenuItem(
                                  Icons.language_rounded,
                                  strings.language,
                                  AppColors.catSightseeing,
                                  _showLanguageSheet,
                                ),
                                _MenuItem(
                                  Icons.dark_mode_outlined,
                                  strings.appearance,
                                  AppColors.catHistory,
                                  () => _showInfoSheet(
                                    title: 'Appearance',
                                    icon: Icons.palette_outlined,
                                    color: AppColors.catHistory,
                                    body:
                                        'TourConnect uses a clean light travel interface. Theme switching can be connected here without changing the profile flow.',
                                    actionLabel: 'Copy theme note',
                                    copyText:
                                        'TourConnect appearance preference: light theme with future dark mode.',
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 24),
                              Text(
                                strings.support,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildMenuSection([
                                _MenuItem(
                                  Icons.help_outline_rounded,
                                  strings.helpCenter,
                                  AppColors.successColor,
                                  () => _showInfoSheet(
                                    title: 'Help Center',
                                    icon: Icons.support_agent_rounded,
                                    color: AppColors.successColor,
                                    body:
                                        'For now, support requests can include your email, saved trips count, and a short description of the issue.',
                                    actionLabel: 'Copy support template',
                                    copyText:
                                        'Support request for TourConnect\nEmail: $_email\nIssue:',
                                  ),
                                ),
                                _MenuItem(
                                  Icons.privacy_tip_outlined,
                                  strings.privacyPolicy,
                                  AppColors.textSecondary,
                                  () => _showInfoSheet(
                                    title: 'Privacy Policy',
                                    icon: Icons.privacy_tip_rounded,
                                    color: AppColors.textSecondary,
                                    body:
                                        'Profile data is used to personalize your account. Saved trips, favorites, and local drafts stay tied to your app profile or local device storage.',
                                    actionLabel: 'Copy privacy summary',
                                    copyText:
                                        'TourConnect privacy summary: profile data personalizes the account; saved trips and drafts are stored for app experience.',
                                  ),
                                ),
                                _MenuItem(
                                  Icons.info_outline_rounded,
                                  strings.aboutApp,
                                  AppColors.textSecondary,
                                  () => _showInfoSheet(
                                    title: 'About TourConnect',
                                    icon: Icons.travel_explore_rounded,
                                    color: AppColors.primary,
                                    body:
                                        '${AppConfig.appName} v${AppConfig.version} helps travellers discover cities, save ideas, plan routes, and prepare booking requests.',
                                    actionLabel: 'Copy app info',
                                    copyText:
                                        '${AppConfig.appName} v${AppConfig.version}',
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 24),
                              _buildLogoutButton(strings),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  '${AppConfig.appName} v${AppConfig.version}',
                                  style: const TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildHeader(AppStrings strings) {
    return SliverAppBar(
      expandedHeight: 260,
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
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFFE0F2F1),
                        backgroundImage: _avatarUrl != null
                            ? NetworkImage(_avatarUrl!)
                            : null,
                        child: _avatarUrl == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 48,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                          _loadProfile();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  _fullName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    strings.levelExplorer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  void _showLanguageSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LanguageSheet(),
    );
  }

  void _showInfoSheet({
    required String title,
    required IconData icon,
    required Color color,
    required String body,
    required String actionLabel,
    required String copyText,
  }) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileInfoSheet(
        title: title,
        icon: icon,
        color: color,
        body: body,
        actionLabel: actionLabel,
        copyText: copyText,
      ),
    );
  }

  Widget _buildProfileInfo(AppStrings strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(Icons.email_outlined, strings.email, _email),
          const Divider(height: 24, color: AppColors.divider),
          _infoRow(Icons.phone_outlined, strings.phone, _phone),
          const Divider(height: 24, color: AppColors.divider),
          _infoRow(Icons.notes_rounded, strings.bio, _bio),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: title == 'Bio' ? 3 : 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(TravelProvider provider, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            '${provider.plannedCitiesCount}',
            strings.trips,
            Icons.route_rounded,
            AppColors.primary,
          ),
          Container(width: 1, height: 50, color: AppColors.divider),
          _statItem(
            '${provider.plannedPlacesCount}',
            strings.planned,
            Icons.event_available_rounded,
            AppColors.accent,
          ),
          Container(width: 1, height: 50, color: AppColors.divider),
          _statItem(
            '${provider.totalFavoritesCount}',
            strings.saved,
            Icons.favorite_rounded,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == items.length - 1;

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                title: Text(
                  item.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textHint,
                ),
                onTap: item.onTap,
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 60,
                  color: AppColors.divider,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(AppStrings strings) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.errorColor.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.logout_rounded,
            color: AppColors.errorColor,
            size: 20,
          ),
        ),
        title: Text(
          strings.logOut,
          style: const TextStyle(
            color: AppColors.errorColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        onTap: _logout,
      ),
    );
  }
}

class _GuestProfileView extends StatelessWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.travel_explore_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                strings.guestTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                strings.guestBody,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              _GuestBenefit(
                icon: Icons.favorite_rounded,
                title: strings.guestBenefitProfile,
                body: strings.guestBenefitProfileBody,
              ),
              _GuestBenefit(
                icon: Icons.cloud_done_rounded,
                title: strings.guestBenefitSync,
                body: strings.guestBenefitSyncBody,
              ),
              _GuestBenefit(
                icon: Icons.support_agent_rounded,
                title: strings.guestBenefitAgency,
                body: strings.guestBenefitAgencyBody,
              ),
              const SizedBox(height: 8),
              const _LanguagePreferenceCard(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  icon: const Icon(Icons.login_rounded),
                  label: Text(strings.signIn),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: Text(strings.continueExploring),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestBenefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _GuestBenefit({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
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

class _LanguagePreferenceCard extends StatelessWidget {
  const _LanguagePreferenceCard();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        HapticFeedback.selectionClick();
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => const _LanguageSheet(),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.catSightseeing.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.language_rounded,
                color: AppColors.catSightseeing,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.interfaceLanguage,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.selectedLanguage,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Consumer<TravelProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  strings.interfaceLanguage,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  strings.chooseLanguage,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _LanguageChoiceButton(
                        label: strings.english,
                        selected: provider.languageCode == 'en',
                        onTap: () async {
                          await provider.setLanguage('en');
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LanguageChoiceButton(
                        label: strings.russian,
                        selected: provider.languageCode == 'ru',
                        onTap: () async {
                          await provider.setLanguage('ru');
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LanguageChoiceButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? Colors.white : AppColors.textHint,
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String body;
  final String actionLabel;
  final String copyText;

  const _ProfileInfoSheet({
    required this.title,
    required this.icon,
    required this.color,
    required this.body,
    required this.actionLabel,
    required this.copyText,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: color, size: 25),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              body,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final messenger = ScaffoldMessenger.of(context);
                  Clipboard.setData(ClipboardData(text: copyText));
                  HapticFeedback.selectionClick();
                  Navigator.pop(context);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('$title copied'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded),
                label: Text(actionLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem(
    this.icon,
    this.label,
    this.color,
    this.onTap,
  );
}
