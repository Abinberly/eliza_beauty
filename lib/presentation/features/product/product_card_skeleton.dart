import 'package:flutter/material.dart';
import '../../components/common/indicators/skeleton_loader.dart';

/// Skeleton loader for product cards
class ProductCardSkeleton extends StatelessWidget {

  const ProductCardSkeleton({
    super.key,
    this.margin,
  });
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: SkeletonLoader(
              height: 180,
              borderRadius: BorderRadius.zero,
            ),
          ),
          
          // Content skeleton
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                SkeletonLoader(
                  borderRadius: BorderRadius.circular(4),
                ),
                
                const SizedBox(height: 4),
                
                // Price skeleton
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SkeletonLoader(
                        width: 80,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(width: 8),
                      SkeletonLoader(
                        width: 60,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Rating skeleton
                SkeletonLoader(
                  width: 100,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                
                const SizedBox(height: 16),
                
                // Button skeleton
                SkeletonLoader(
                  width: double.infinity,
                  height: 45,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for similar product cards (smaller version)
class SimilarProductCardSkeleton extends StatelessWidget {

  const SimilarProductCardSkeleton({
    super.key,
    this.margin,
  });
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 160,
      height: 280,
      margin: margin,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SkeletonLoader(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          
          // Content skeleton
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  SkeletonLoader(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  
                  const SizedBox(height: 2),
                  
                  // Price skeleton
                  Row(
                    children: [
                      SkeletonLoader(
                        width: 50,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(width: 4),
                      SkeletonLoader(
                        width: 35,
                        height: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 2),
                  
                  // Rating skeleton
                  SkeletonLoader(
                    width: 70,
                    height: 10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  
                  const Spacer(),
                  
                  // Button skeleton
                  SkeletonLoader(
                    width: double.infinity,
                    height: 28,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for search item cards (horizontal layout)
class SearchItemCardSkeleton extends StatelessWidget {

  const SearchItemCardSkeleton({
    super.key,
    this.margin,
  });
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: SkeletonLoader(
              width: 120,
              height: 120,
              borderRadius: BorderRadius.zero,
            ),
          ),
          
          // Content skeleton
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  SkeletonLoader(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price skeleton
                  Row(
                    children: [
                      SkeletonLoader(
                        width: 70,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(width: 8),
                      SkeletonLoader(
                        width: 50,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating skeleton
                  SkeletonLoader(
                    width: 90,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  
                  const Spacer(),
                  
                  // Button skeleton
                  SkeletonLoader(
                    width: double.infinity,
                    height: 36,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
