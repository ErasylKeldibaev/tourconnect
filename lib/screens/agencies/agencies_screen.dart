import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';

class AgenciesScreen extends StatelessWidget {
  final City city;
  const AgenciesScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final cityAgencies = agencies.where((a) => a.cityId == city.id).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${city.name} — Agencies',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: cityAgencies.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.business_outlined, size: 64, color: AppColors.textHint),
        SizedBox(height: 16),
        Text('No agencies in this city', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ]))
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: cityAgencies.length,
        itemBuilder: (context, index) {
          final agency = cityAgencies[index];
          return FadeInUp(
            delay: Duration(milliseconds: 80 * index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AppImage(imageUrl: agency.imageUrl, width: 76, height: 76, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(agency.name,
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                                  if (agency.isVerified)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(color: AppColors.successColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                      child: const Row(children: [
                                        Icon(Icons.verified_rounded, color: AppColors.successColor, size: 12),
                                        SizedBox(width: 3),
                                        Text('Verified', style: TextStyle(color: AppColors.successColor, fontSize: 10, fontWeight: FontWeight.w600)),
                                      ]),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(children: [
                                const Icon(Icons.star_rounded, color: AppColors.starColor, size: 16),
                                const SizedBox(width: 4),
                                Text('${agency.rating}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                                const SizedBox(width: 4),
                                Text('(${AppUtils.formatReviewCount(agency.reviewCount)})',
                                    style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                              ]),
                              const SizedBox(height: 4),
                              Text('${agency.toursCount} tours available',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                    child: Text(agency.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: TextButton.icon(
                          onPressed: () => AppUtils.showSnackBar(context, 'Calling ${agency.phone}'),
                          icon: const Icon(Icons.phone_outlined, size: 18, color: AppColors.primary),
                          label: const Text('Call', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        )),
                        Container(width: 1, height: 48, color: AppColors.divider),
                        Expanded(child: TextButton.icon(
                          onPressed: () => AppUtils.showSnackBar(context, 'Messaging coming soon!'),
                          icon: const Icon(Icons.message_outlined, size: 18, color: AppColors.primary),
                          label: const Text('Message', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}