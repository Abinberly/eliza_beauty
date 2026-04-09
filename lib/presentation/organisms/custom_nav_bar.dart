import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/presentation/molecules/nav_bar_item.dart';
import 'package:eliza_beauty/presentation/organisms/nav_bar_painter.dart';
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

  final List<Map<String, dynamic>> _navItems = [
    {'label': AppConstants.home, 'icon': Icons.home_filled},
    {'label': AppConstants.search, 'icon': Icons.search},
    // {'label': AppConstants.cart, 'icon': Icons.shopping_cart},
    {'label': AppConstants.account, 'icon': Icons.person},
  ];

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
    if (widget.currentIndex != oldWidget.currentIndex) {
      _animation = Tween<double>(
        begin: _previousIndex,
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
      _previousIndex = widget.currentIndex.toDouble();
    }
  }

  void _onItemTapped(int index) {
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
                    itemCount: _navItems.length,
                  ),
                ),
              );
            },
          ),

          // Navigation Items
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_navItems.length, (index) {
              return Expanded(
                child: NavBarItem(
                  label: _navItems[index]['label'],
                  icon: _navItems[index]['icon'],
                  imageUrl: _navItems[index]['imageUrl'],
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
              double itemWidth = width / _navItems.length;
              double leftPosition =
                  (_animation.value * itemWidth) + (itemWidth / 2) - 28;

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
                      child: _navItems[widget.currentIndex]['imageUrl'] != null
                          ? CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(
                                _navItems[widget.currentIndex]['imageUrl'],
                              ),
                            )
                          : Icon(
                              _navItems[widget.currentIndex]['icon'],
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
