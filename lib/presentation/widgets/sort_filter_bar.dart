import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eliza_beauty/presentation/providers/shop/product_search_provider.dart';

class SortFilterBar extends ConsumerWidget {
  const SortFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productSearchControllerProvider);
    final notifier = ref.read(productSearchControllerProvider.notifier);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            l10n.productCount(state.total),
            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: state.sortBy,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: 'title',
                child: Text(
                  l10n.sortByName,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: .normal),
                ),
              ),
              DropdownMenuItem(
                value: 'price',
                child: Text(
                  l10n.sortByPrice,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: .normal),
                ),
              ),
              DropdownMenuItem(
                value: 'rating',
                child: Text(
                  l10n.sortByRating,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: .normal),
                ),
              ),
            ],
            onChanged: (val) {
              if (val != null) notifier.updateSort(val, state.order);
            },
          ),
          IconButton(
            icon: Icon(
              state.order == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
              size: 20,
            ),
            onPressed: () {
              final newOrder = state.order == 'asc' ? 'desc' : 'asc';
              notifier.updateSort(state.sortBy, newOrder);
            },
          ),
        ],
      ),
    );
  }
}
