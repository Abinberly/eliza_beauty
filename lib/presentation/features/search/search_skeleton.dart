import 'package:flutter/material.dart';
import '../../components/common/indicators/skeleton_loader.dart';
import '../product/product_card_skeleton.dart';

/// Skeleton loader for search bar
class SearchBarSkeleton extends StatelessWidget {

  const SearchBarSkeleton({
    super.key,
    this.padding,
  });
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: SkeletonBox(
        height: 48,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

/// Skeleton loader for search filters
class SearchFiltersSkeleton extends StatelessWidget {

  const SearchFiltersSkeleton({
    super.key,
    this.padding,
  });
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Sort dropdown skeleton
          Expanded(
            flex: 2,
            child: SkeletonBox(
              height: 36,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          // Sort order button skeleton
          SkeletonBox(
            width: 40,
            height: 36,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for search results header
class SearchResultsHeaderSkeleton extends StatelessWidget {

  const SearchResultsHeaderSkeleton({
    super.key,
    this.padding,
  });
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Results count skeleton
          SkeletonBox(
            width: 100,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          // View toggle skeleton
          Row(
            children: [
              SkeletonBox(
                width: 32,
                height: 32,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(width: 8),
              SkeletonBox(
                width: 32,
                height: 32,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for search results grid
class SearchResultsGridSkeleton extends StatelessWidget {

  const SearchResultsGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.padding,
  });
  final int itemCount;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const SimilarProductCardSkeleton();
        },
      ),
    );
  }
}

/// Skeleton loader for search results list
class SearchResultsListSkeleton extends StatelessWidget {

  const SearchResultsListSkeleton({
    super.key,
    this.itemCount = 4,
    this.padding,
  });
  final int itemCount;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const SearchItemCardSkeleton();
        },
      ),
    );
  }
}

/// Skeleton loader for search suggestions
class SearchSuggestionsSkeleton extends StatelessWidget {

  const SearchSuggestionsSkeleton({
    super.key,
    this.itemCount = 5,
    this.padding,
  });
  final int itemCount;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Suggestions header skeleton
          SkeletonBox(
            width: 120,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          // Suggestions list skeleton
          ...List.generate(
            itemCount,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // Search icon skeleton
                  const SkeletonAvatar(
                    size: 20,
                    shape: CircleBorder(),
                  ),
                  const SizedBox(width: 12),
                  // Suggestion text skeleton
                  Expanded(
                    child: SkeletonBox(
                      height: 16,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(4),
                    ),
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

/// Skeleton loader for recent searches
class RecentSearchesSkeleton extends StatelessWidget {

  const RecentSearchesSkeleton({
    super.key,
    this.itemCount = 4,
    this.padding,
  });
  final int itemCount;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches header skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(
                width: 100,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
              SkeletonBox(
                width: 60,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Recent searches list skeleton
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              itemCount,
              (index) => SkeletonBox(
                width: 80 + (index * 20) % 60, // Variable widths
                height: 32,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Complete search page skeleton
class SearchPageSkeleton extends StatelessWidget {
  const SearchPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          // Search bar skeleton
          SearchBarSkeleton(),
          SizedBox(height: 16),
          // Search filters skeleton
          SearchFiltersSkeleton(),
          SizedBox(height: 16),
          // Recent searches skeleton
          RecentSearchesSkeleton(),
          SizedBox(height: 24),
          // Search suggestions skeleton
          SearchSuggestionsSkeleton(),
          SizedBox(height: 24),
          // Search results header skeleton
          SearchResultsHeaderSkeleton(),
          SizedBox(height: 16),
          // Search results skeleton
          SearchResultsListSkeleton(),
        ],
      ),
    );
  }
}
