import 'package:eliza_beauty/presentation/atoms/category_capsule.dart';
import 'package:eliza_beauty/presentation/providers/shop/shop_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryListBar extends ConsumerWidget {
  const CategoryListBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedSlug = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) => SizedBox(
        height: 54,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CategoryCapsule(
                label: category.name,
                isSelected: selectedSlug == category.slug,
                onTap: () => ref.read(selectedCategoryProvider.notifier).select(category.slug),
              ),
            );
          },
        ),
      ),
      loading: () => const SizedBox(),
      error: (err, _) => Text(''),
    );
  }
}