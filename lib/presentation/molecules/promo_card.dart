import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoCard extends StatelessWidget {
  final String imagePath;

  const PromoCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      // padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFC7CDCD),
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
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.6),
                  ],
                  stops: const [
                    0.0,
                    1.0,
                  ], 
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    "LIMITED EDITION",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Main Headline
                RichText(
                  text:  TextSpan(
                    style: GoogleFonts.inter(
                      color: Color(0xFF1A1A1A),
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                    children: [
                      TextSpan(text: "A New Era of\n"),
                      TextSpan(
                        text: "Comfort",
                        style: GoogleFonts.inter(color: Color(0xFF2361E9)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Description text
                 SizedBox(
                  width: 250,
                  child: Text(
                    "Minimalist aesthetics meet peak functional performance in our latest curated series.",
                    style: GoogleFonts.inter(
                      color: Color(0xFF4A4A4A),
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                ),

                const Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
