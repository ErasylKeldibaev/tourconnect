import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: const Color(0xFFE8EAED),
          highlightColor: const Color(0xFFF5F5F5),
          child: Container(height: height, width: width, color: Colors.white),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          color: const Color(0xFFE8EAED),
          child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        ),
      ),
    );
  }
}