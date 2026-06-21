import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../data/dummy_data.dart';
import '../../models/agency_model.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';

class AgenciesScreen extends StatelessWidget {
  final City city;

  const AgenciesScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final cityAgencies = agencies.where((agency) => agency.cityId == city.id).toList()
      ..sort((a, b) {
        if (a.isVerified != b.isVerified) return a.isVerified ? -1 : 1;
        final rating = b.rating.compareTo(a.rating);
        if (rating != 0) return rating;
        return b.reviewCount.compareTo(a.reviewCount);
      });
    final verifiedCount = cityAgencies.where((agency) => agency.isVerified).length;
    final totalTours = cityAgencies.fold<int>(0, (sum, agency) => sum + agency.toursCount);
    final averageRating = cityAgencies.isEmpty
        ? 0.0
        : cityAgencies.fold<double>(0, (sum, agency) => sum + agency.rating) / cityAgencies.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '${city.name} guides',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: cityAgencies.isEmpty
          ? const _EmptyAgencies()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              physics: const BouncingScrollPhysics(),
              children: [
                _AgencyIntro(city: city),
                const SizedBox(height: 14),
                _AgencySummary(
                  agencyCount: cityAgencies.length,
                  verifiedCount: verifiedCount,
                  toursCount: totalTours,
                  averageRating: averageRating,
                ),
                const SizedBox(height: 18),
                const _SectionTitle(
                  title: 'Trusted local operators',
                  subtitle: 'Compare reviews, tour count, and contact quickly.',
                ),
                const SizedBox(height: 12),
                for (var index = 0; index < cityAgencies.length; index++)
                  FadeInUp(
                    delay: Duration(milliseconds: 70 * index),
                    child: _AgencyCard(
                      agency: cityAgencies[index],
                      onContact: () => _showContactSheet(context, cityAgencies[index]),
                    ),
                  ),
              ],
            ),
    );
  }

  void _showContactSheet(BuildContext context, Agency agency) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AgencyContactSheet(agency: agency),
    );
  }
}

class _AgencyIntro extends StatelessWidget {
  final City city;

  const _AgencyIntro({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AppImage(
              imageUrl: city.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan ${city.name} with locals',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Use agencies for routes, transfers, guides, and booking requests.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _AgencySummary extends StatelessWidget {
  final int agencyCount;
  final int verifiedCount;
  final int toursCount;
  final double averageRating;

  const _AgencySummary({
    required this.agencyCount,
    required this.verifiedCount,
    required this.toursCount,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Agencies',
              value: '$agencyCount',
              icon: Icons.business_center_rounded,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Verified',
              value: '$verifiedCount',
              icon: Icons.verified_rounded,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Tours',
              value: '$toursCount',
              icon: Icons.route_rounded,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Rating',
              value: averageRating.toStringAsFixed(1),
              icon: Icons.star_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.76),
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _AgencyCard extends StatelessWidget {
  final Agency agency;
  final VoidCallback onContact;

  const _AgencyCard({
    required this.agency,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AppImage(
                    imageUrl: agency.imageUrl,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              agency.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.15,
                              ),
                            ),
                          ),
                          if (agency.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.verified_rounded, color: AppColors.successColor, size: 20),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoPill(
                            icon: Icons.star_rounded,
                            label:
                                '${agency.rating} (${AppUtils.formatReviewCount(agency.reviewCount)})',
                            color: AppColors.starColor,
                          ),
                          _InfoPill(
                            icon: Icons.route_rounded,
                            label: '${agency.toursCount} tours',
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: Text(
              agency.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyPhone(context),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Copy phone'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.divider),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onContact,
                    icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                    label: const Text('Contact'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyPhone(BuildContext context) {
    Clipboard.setData(ClipboardData(text: agency.phone));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${agency.phone} copied'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgencyContactSheet extends StatelessWidget {
  final Agency agency;

  const _AgencyContactSheet({required this.agency});

  String get _requestText =>
      'Hi ${agency.name}, I would like to plan a trip. Please send available tours and prices.';

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AppImage(
                    imageUrl: agency.imageUrl,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agency.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        agency.phone,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ContactAction(
              icon: Icons.phone_rounded,
              title: 'Phone',
              subtitle: agency.phone,
              onTap: () => _copy(context, agency.phone, 'Phone copied'),
            ),
            const SizedBox(height: 10),
            _ContactAction(
              icon: Icons.description_rounded,
              title: 'Prepared request',
              subtitle: _requestText,
              onTap: () => _copy(context, _requestText, 'Request copied'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _copy(context, _requestText, 'Request copied'),
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copy request'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String value, String message) {
    final messenger = ScaffoldMessenger.of(context);

    Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.selectionClick();
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _ContactAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.copy_rounded, color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}

class _EmptyAgencies extends StatelessWidget {
  const _EmptyAgencies();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.business_center_outlined, size: 38, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            const Text(
              'No agencies in this city',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check nearby destinations for guided tours and travel support.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
