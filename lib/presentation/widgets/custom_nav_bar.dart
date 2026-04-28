import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/widgets/nav_bar_item.dart';
import 'package:eliza_beauty/presentation/widgets/nav_bar_painter.dart';
import 'package:eliza_beauty/presentation/providers/app/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavBar extends ConsumerStatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  ConsumerState<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends ConsumerState<CustomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousIndex = 0.0;
  String? _lastLocale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentLocale = ref.read(appLocaleProvider).valueOrNull?.languageCode;
    final bool localeChanged =
        _lastLocale != null && _lastLocale != currentLocale;

    if (widget.currentIndex != oldWidget.currentIndex) {
      _animation = Tween<double>(
        begin: _previousIndex,
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
      _previousIndex = widget.currentIndex.toDouble();
    } else if (localeChanged) {
      _previousIndex = widget.currentIndex.toDouble();
    }
    _lastLocale = currentLocale;
  }

  void _onItemTapped(int index) {
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final locale = ref.watch(appLocaleProvider).valueOrNull;
    final String langCode = locale?.languageCode ?? 'en';
    final bool isRtl = langCode == 'ar';

    final List<Map<String, dynamic>> navItems = [
      {'label': context.l10n.home, 'icon': Icons.home_filled},
      {'label': context.l10n.search, 'icon': Icons.search},
      {'label': context.l10n.account, 'icon': Icons.person},
    ];

    return Container(
      height: 120,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: .none,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return RepaintBoundary(
                child: CustomPaint(
                  size: Size(width, 100),
                  painter: NavBarPainter(
                    position: _animation.value,
                    itemCount: navItems.length,
                    isRtl: isRtl,
                  ),
                ),
              );
            },
          ),

          // Navigation Items
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(navItems.length, (index) {
              return Expanded(
                child: NavBarItem(
                  label: navItems[index]['label'],
                  icon: navItems[index]['icon'],
                  imageUrl: navItems[index]['imageUrl'],
                  isSelected: widget.currentIndex == index,
                  onTap: () => _onItemTapped(index),
                ),
              );
            }),
          ),

          // Floating Active Icon
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double itemWidth = width / navItems.length;
              double adjustedPosition = isRtl
                  ? (navItems.length - 1 - _animation.value)
                  : _animation.value;
              double leftPosition =
                  (adjustedPosition * itemWidth) + (itemWidth / 2) - 28;

              final int safeIndex =
                  widget.currentIndex >= 0 &&
                      widget.currentIndex < navItems.length
                  ? widget.currentIndex
                  : 0;

              return Positioned(
                bottom: 45,
                left: leftPosition,
                child: RepaintBoundary(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.activeIconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: navItems[safeIndex]['imageUrl'] != null
                          ? CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(
                                navItems[safeIndex]['imageUrl'],
                              ),
                            )
                          : Icon(
                              navItems[safeIndex]['icon'],
                              color: Colors.white,
                              size: 28,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
