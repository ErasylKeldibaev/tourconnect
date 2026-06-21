import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/constants/app_colors.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double borderRadius;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final optimizedImageUrl = _optimizedImageUrl();

    if (optimizedImageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _ImageFallback(height: height, width: width),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: optimizedImageUrl,
        height: height,
        width: width,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 180),
        fadeOutDuration: const Duration(milliseconds: 120),
        useOldImageOnUrlChange: true,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8EAED), Color(0xFFF8FAFC)],
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) =>
            _ImageFallback(height: height, width: width),
      ),
    );
  }

  String _optimizedImageUrl() {
    if (imageUrl.trim().isEmpty) return '';
    final uri = Uri.tryParse(imageUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return '';
    }
    if (uri.host != 'images.unsplash.com') {
      return imageUrl.trim();
    }

    final query = Map<String, String>.from(uri.queryParameters)
      ..putIfAbsent('auto', () => 'format')
      ..putIfAbsent('fit', () => 'crop')
      ..putIfAbsent('q', () => '85')
      ..putIfAbsent('w', () => '1200');

    return uri.replace(queryParameters: query).toString();
  }
}

class _ImageFallback extends StatelessWidget {
  final double? height;
  final double? width;

  const _ImageFallback({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: const Icon(
        Icons.travel_explore_rounded,
        color: Colors.white70,
        size: 34,
      ),
    );
  }
}
