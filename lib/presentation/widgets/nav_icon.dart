import 'package:flutter/material.dart';

class NavIcon extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final Color color;

  const NavIcon({super.key, this.icon, this.imageUrl, required this.color});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CircleAvatar(
        radius: 12,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }
    return Icon(icon, color: color, size: 24);
  }
}