import 'package:eliza_beauty/presentation/providers/shop/image_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductImageGallery extends ConsumerStatefulWidget {
  final List<String> images;
  const ProductImageGallery({super.key, required this.images});

  @override
  ConsumerState<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends ConsumerState<ProductImageGallery> {
  late PageController _pageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _scrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedImageIndexProvider.notifier).select(0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    
    const itemWidth = 80.0;
    const spacing = 12.0;
    const totalItemWidth = itemWidth + spacing;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = (index * totalItemWidth) - (screenWidth / 2) + (itemWidth / 2);
    
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    ref.read(selectedImageIndexProvider.notifier).select(index);
    _scrollToIndex(index);
  }

  void _onThumbnailTap(int index) {
    ref.read(selectedImageIndexProvider.notifier).select(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollToIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedImageIndexProvider);

    return Column(
      children: [
        SizedBox(
          height: 450,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 100,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onThumbnailTap(index),
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedIndex == index ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(widget.images[index], fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
