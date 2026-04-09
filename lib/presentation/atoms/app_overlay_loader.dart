import 'package:flutter/material.dart';

class AppOverlayLoader extends StatelessWidget {
  const AppOverlayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}