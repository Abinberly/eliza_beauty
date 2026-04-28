import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  const GradientProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 250,
      height: 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 3),
        builder: (context, value, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradientWhite.withValues(alpha: 0), AppColors.gradientBlue.withValues(alpha: 0.5), AppColors.gradientWhite],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}