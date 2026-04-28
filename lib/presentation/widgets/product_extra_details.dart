import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductExtraDetails extends StatelessWidget {
  final ProductModel product;

  const ProductExtraDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.productHighlights),
        const SizedBox(height: 12),
        _buildHighlightItem(Icons.verified_user_outlined, product.warrantyInformation),
        _buildHighlightItem(Icons.local_shipping_outlined, product.shippingInformation),
        _buildHighlightItem(Icons.assignment_return_outlined, product.returnPolicy),
        
        const SizedBox(height: 32),

        _buildSectionTitle(l10n.specifications),
        const SizedBox(height: 12),
        _buildSpecTable({
          l10n.brand : product.brand ?? "N/A",
          l10n.sku: product.sku,
          l10n.weight: "${product.weight} kg",
          l10n.dimensions: "${product.dimensions.width} x ${product.dimensions.height} x ${product.dimensions.depth} cm",
          l10n.availability: product.availabilityStatus,
        }),

        const SizedBox(height: 32),

        _buildSectionTitle(l10n.manufacturerInfo),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            l10n.manufacturerNotice(product.brand ?? "", product.sku),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase()
    );
  }

  Widget _buildHighlightItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Text(text,)
        ],
      ),
    );
  }

  Widget _buildSpecTable(Map<String, String> specs) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
      children: specs.entries.map((entry) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(entry.key, style: const TextStyle(color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        );
      }).toList(),
    );
  }
}