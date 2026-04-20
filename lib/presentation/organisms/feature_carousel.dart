import 'dart:async';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_images.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/molecules/feature_card.dart';
import 'package:eliza_beauty/presentation/molecules/promo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class FeatureCarousel extends HookConsumerWidget {
  const FeatureCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(
      initialPage: 1000,
      viewportFraction: 0.8,
    );
    final virtualPage = useState(1000);
    final currentPage = useState(0);
    final isReady = useState(false);
    const int totalItems = 5;

    // Wait for PageView to attach and have dimensions before showing
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients &&
            pageController.position.haveDimensions) {
          isReady.value = true;
        } else {
          // If not ready on first frame, try again next frame
          void check() {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (pageController.hasClients &&
                  pageController.position.haveDimensions) {
                isReady.value = true;
              } else {
                check();
              }
            });
          }
          check();
        }
      });
      return null;
    }, [pageController]);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 4), (_) {
        virtualPage.value++;
        if (pageController.hasClients) {
          pageController.animateToPage(
            virtualPage.value,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutQuart,
          );
        }
      });
      return timer.cancel;
    }, [pageController]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
                context.l10n.newNarratives,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gradientBlue,
                ),
                textAlign: .left,
              ),

              Spacer()
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
                context.l10n.editorsChoice,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Spacer(),
            ],
          ),
        ),

        SizedBox(height: 20),

        SizedBox(
          height: 380,
          child: Stack(
            children: [
              // Always build the PageView so it can attach and get dimensions
              Opacity(
                opacity: isReady.value ? 1.0 : 0.0,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: null,
                  onPageChanged: (index) {
                    virtualPage.value = index;
                    currentPage.value = index % totalItems;
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (BuildContext context, Widget? child) {
                        double value = 1.0;
                        if (pageController.position.haveDimensions) {
                          double pageOffset = pageController.page! - index;
                          value =
                              (1 - (pageOffset.abs() * 0.1)).clamp(0.0, 1.0);
                        }
                        return Transform.scale(scale: value, child: child);
                      },
                      child: _buildCarouselItem(context, index, totalItems),
                    );
                  },
                ),
              ),
              // Show shimmer on top while PageView initializes
              if (!isReady.value)
                const Positioned.fill(child: _CarouselPlaceholder()),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalItems, (index) {
            final isActive = currentPage.value == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              height: 8,
              width: isActive ? 28 : 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.lightGray,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(
    BuildContext context,
    int virtualIndex,
    int totalItems,
  ) {
    final actualIndex = virtualIndex % totalItems;
    final l10n = context.l10n;
    switch (actualIndex) {
      case 0:
        return const PromoCard(imagePath: AppImages.cardBg);
      case 1:
        return FeatureCard(
          imagePath: AppImages.atmosphereCard,
          label: l10n.atmosphereLabel,
          title: l10n.atmosphereTitle,
          subtitle: l10n.atmosphereSubtitle,
        );
      case 2:
        return FeatureCard(
          imagePath: AppImages.olfactiveCard,
          label: l10n.olfactiveLabel,
          title: l10n.olfactiveTitle,
          subtitle: l10n.olfactiveSubtitle,
        );
      case 3:
        return FeatureCard(
          imagePath: AppImages.formsCard,
          label: l10n.formsLabel,
          title: l10n.formsTitle,
          subtitle: l10n.formsSubtitle,
        );
      case 4:
        return FeatureCard(
          imagePath: AppImages.audioCard,
          label: l10n.audioLabel,
          title: l10n.audioTitle,
          subtitle: l10n.audioSubtitle,
        );
      default:
        return const SizedBox();
    }
  }
}

/// Inline shimmer placeholder that matches the carousel card size.
class _CarouselPlaceholder extends StatelessWidget {
  const _CarouselPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

