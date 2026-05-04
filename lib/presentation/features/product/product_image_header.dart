import 'package:flutter/material.dart';

class ProductImageHeader extends StatelessWidget {
  const ProductImageHeader({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      color: const Color(0xFFF3F4F6),
      child: Image.network(imageUrl, fit: BoxFit.contain),
    );
  }
}
