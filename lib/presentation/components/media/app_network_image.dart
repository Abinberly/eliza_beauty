import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A wrapper around CachedNetworkImage that shows a placeholder icon
/// when the image fails to load (e.g. no internet) and caches images.
class AppNetworkImage extends StatelessWidget {

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  /// Safely convert double to int, handling infinity/NaN values
  static int? _safeToInt(double? value) {
    if (value == null) return null;
    if (!value.isFinite || value.isNaN) return null;
    if (value < 0) return null;
    if (value > 10000) return null; // Prevent extremely large values
    return value.toInt();
  }

  /// Safely calculate icon size, handling infinity/NaN values
  static double _safeIconSize(double? height) {
    if (height == null) return 30.0;
    if (!height.isFinite || height.isNaN) return 30.0;
    if (height < 0) return 30.0;
    if (height > 1000) return 30.0; // Prevent extremely large values
    return height * 0.3;
  }

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: _safeIconSize(height),
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      memCacheWidth: _safeToInt(width),
      memCacheHeight: _safeToInt(height),
      cacheKey: imageUrl,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 200),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
