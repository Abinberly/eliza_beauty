import 'package:flutter/material.dart';

/// Base skeleton loader widget with shimmer animation
class SkeletonLoader extends StatefulWidget {

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? theme.colorScheme.surface;

    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
                end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
                colors: [
                  baseColor,
                  highlightColor,
                  baseColor,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Skeleton loader for text with customizable lines
class SkeletonText extends StatelessWidget {

  const SkeletonText({
    super.key,
    this.lines = 3,
    this.lineHeight = 16.0,
    this.spacing = 8.0,
    this.lastLineWidth,
    this.borderRadius,
  });
  final int lines;
  final double lineHeight;
  final double spacing;
  final double? lastLineWidth;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
          child: SkeletonLoader(
            height: lineHeight,
            width: index == lines - 1 && lastLineWidth != null
                ? lastLineWidth
                : double.infinity,
            borderRadius: borderRadius ?? BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Skeleton loader for circular avatars
class SkeletonAvatar extends StatelessWidget {

  const SkeletonAvatar({
    super.key,
    this.size = 40.0,
    this.shape = const CircleBorder(),
  });
  final double size;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

/// Skeleton loader for rectangular containers
class SkeletonBox extends StatelessWidget {

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      margin: margin,
    );
  }
}
