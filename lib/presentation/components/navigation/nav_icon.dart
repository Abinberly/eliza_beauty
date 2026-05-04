import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NavIcon extends StatelessWidget {

  const NavIcon({super.key, this.icon, this.imageUrl, required this.color});
  final IconData? icon;
  final String? imageUrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CircleAvatar(
        radius: 12,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
      );
    }
    return Icon(icon, color: color, size: 24);
  }
}