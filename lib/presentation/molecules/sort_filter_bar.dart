import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/product_search_provider.dart';

class SortFilterBar extends ConsumerWidget {
  const SortFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productSearchControllerProvider);
    final notifier = ref.read(productSearchControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "${state.total} Products",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: state.sortBy,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: 'title',
                child: Text(
                  'Name',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: .normal),
                ),
              ),
              DropdownMenuItem(
                value: 'price',
                child: Text(
                  'Price',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: .normal),
                ),
              ),
              DropdownMenuItem(
                value: 'rating',
                child: Text(
                  'Rating',
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
