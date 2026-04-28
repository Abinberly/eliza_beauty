import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoCard extends StatelessWidget {
  final String imagePath;

  const PromoCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: AppColors.gradientWhite,
          borderRadius: BorderRadius.circular(40),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.gradientWhite.withValues(alpha: 0.2),
                      AppColors.gradientWhite.withValues(alpha: 0.6),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mustardYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.limitedEdition,
                          style: GoogleFonts.inter(
                            color: AppColors.gradientWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Main Headline
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        color: AppColors.appTitle,
                        fontWeight: .w600,
                        fontSize: 40,
                      ),
                      children: [
                        TextSpan(text: l10n.newEraHeadline),

                        TextSpan(
                          text: l10n.comfort,
                          style: GoogleFonts.poppins(
                            color: AppColors.gradientBlue,
                            fontWeight: .w600,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Description text
                  SizedBox(
                    width: 250,
                    child: Text(
                      l10n.heroDescription,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
