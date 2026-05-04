import 'package:flutter/material.dart';
import './skeleton_loader.dart';

/// Skeleton loader for category items
class CategorySkeleton extends StatelessWidget {

  const CategorySkeleton({
    super.key,
    this.margin,
    this.isHorizontal = false,
  });
  final EdgeInsets? margin;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalCategory();
    } else {
      return _buildVerticalCategory();
    }
  }

  Widget _buildHorizontalCategory() {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category image skeleton
          const SkeletonAvatar(
            size: 60,
            shape: CircleBorder(),
          ),
          const SizedBox(height: 8),
          // Category name skeleton
          SkeletonBox(
            width: 60,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCategory() {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Category image skeleton
          const SkeletonAvatar(
            size: 40,
            shape: CircleBorder(),
          ),
          const SizedBox(width: 12),
          // Category name skeleton
          Expanded(
            child: SkeletonBox(
              height: 16,
              width: double.infinity,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for category list bar
class CategoryListBarSkeleton extends StatelessWidget {

  const CategoryListBarSkeleton({
    super.key,
    this.padding,
  });
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            6, // Show 6 category skeletons
            (index) => const CategorySkeleton(
              isHorizontal: true,
              margin: EdgeInsets.only(right: 12),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton loader for category grid
class CategoryGridSkeleton extends StatelessWidget {

  const CategoryGridSkeleton({
    super.key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.padding,
  });
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6, // Show 6 category skeletons
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category image skeleton
              const SkeletonAvatar(
                size: 80,
                shape: CircleBorder(),
              ),
              const SizedBox(height: 12),
              // Category name skeleton
              SkeletonBox(
                width: 80,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              // Product count skeleton
              SkeletonBox(
                width: 60,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Skeleton loader for category section header
class CategoryHeaderSkeleton extends StatelessWidget {

  const CategoryHeaderSkeleton({
    super.key,
    this.padding,
  });
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title skeleton
          SkeletonBox(
            width: 120,
            height: 24,
            borderRadius: BorderRadius.circular(6),
          ),
          // See all skeleton
          SkeletonBox(
            width: 60,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
