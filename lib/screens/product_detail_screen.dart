import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imageController = PageController();
  int _currentImage = 0;
  String? _selectedSize;
  int? _selectedColorIndex;

  static const double _actionBarHeight = 88;
  static const double _floatingNavClearance = 96;

  final List<String> _sizes = const ['S', 'M', 'L', 'XL'];
  final List<_ColorOption> _colors = const [
    _ColorOption(color: Colors.black, name: 'Black'),
    _ColorOption(color: Colors.white, name: 'White'),
    _ColorOption(color: Color(0xFF9CA3AF), name: 'Grey'),
  ];

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _onAddToCart(BuildContext context) {
    context.read<CartProvider>().addToCart(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final isFavorite = context.watch<ProductProvider>().isFavorite(product.id);
    final relatedProducts = context
        .read<ProductProvider>()
        .products
        .where((p) => p.category == product.category && p.id != product.id)
        .take(6)
        .toList();

    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final scrollBottomPadding =
        _actionBarHeight + _floatingNavClearance + bottomSafeArea;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: scrollBottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: PageView.builder(
                        controller: _imageController,
                        onPageChanged: (index) {
                          setState(() => _currentImage = index);
                        },
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: theme.colorScheme.surface,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: theme.colorScheme.surface,
                              child: Icon(
                                SolarIconsOutline.gallery,
                                size: 64,
                                color: theme.colorScheme.onSurface.withAlpha(100),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: _PageIndicator(
                    count: 1,
                    currentIndex: _currentImage,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _RatingStars(rating: product.rating),
                          const SizedBox(width: 8),
                          Text(
                            '${product.rating}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount} reviews)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (product.originalPrice != null)
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(120),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Size'),
                      const SizedBox(height: 12),
                      _SizeSelector(
                        sizes: _sizes,
                        selectedSize: _selectedSize,
                        onSelected: (size) {
                          setState(() => _selectedSize = size);
                        },
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Color'),
                      const SizedBox(height: 12),
                      _ColorSelector(
                        colors: _colors,
                        selectedIndex: _selectedColorIndex,
                        onSelected: (index) {
                          setState(() => _selectedColorIndex = index);
                        },
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Description'),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(200),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Reviews'),
                      const SizedBox(height: 12),
                      _ReviewsSummary(
                        rating: product.rating,
                        reviewCount: product.reviewCount,
                      ),
                    ],
                  ),
                ),
                if (relatedProducts.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionTitle(title: 'You may also like'),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: relatedProducts.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final related = relatedProducts[index];
                        return SizedBox(
                          width: 180,
                          child: ProductCard(
                            product: related,
                            onTap: () => Navigator.of(context).pushReplacementNamed(
                              '/product-detail',
                              arguments: related,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: scrollBottomPadding),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                height: _actionBarHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.onSurface.withAlpha(20),
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _FavoriteButton(
                      isFavorite: isFavorite,
                      onPressed: () {
                        context.read<ProductProvider>().toggleFavorite(product.id);
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: product.inStock ? () => _onAddToCart(context) : null,
                        icon: const Icon(SolarIconsOutline.bag),
                        label: Text(
                          product.inStock ? 'Add to Cart' : 'Out of Stock',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withAlpha(60),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const _RatingStars({
    required this.rating,
  }) : size = 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final IconData icon;
        if (rating >= starValue - 0.25) {
          icon = SolarIconsOutline.star;
        } else if (rating >= starValue - 0.75) {
          icon = SolarIconsOutline.star;
        } else {
          icon = SolarIconsOutline.starsLine;
        }
        return Icon(
          icon,
          size: size,
          color: theme.colorScheme.onSurface,
        );
      }),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSelected;

  const _SizeSelector({
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 12,
      children: sizes.map((size) {
        final isSelected = size == selectedSize;
        return InkWell(
          onTap: () => onSelected(size),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withAlpha(40),
              ),
            ),
            child: Text(
              size,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorOption {
  final Color color;
  final String name;

  const _ColorOption({
    required this.color,
    required this.name,
  });
}

class _ColorSelector extends StatelessWidget {
  final List<_ColorOption> colors;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  const _ColorSelector({
    required this.colors,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 16,
      children: colors.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = index == selectedIndex;
        return InkWell(
          customBorder: const CircleBorder(),
          onTap: () => onSelected(index),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: option.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : option.color == Colors.white
                        ? theme.colorScheme.onSurface.withAlpha(40)
                        : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: isSelected
                ? Icon(
                    SolarIconsOutline.checkCircle,
                    size: 20,
                    color: option.color == Colors.black
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _ReviewsSummary extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const _ReviewsSummary({
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RatingStars(rating: rating),
                    const SizedBox(height: 4),
                    Text(
                      'Based on $reviewCount reviews',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rating / 5,
              minHeight: 8,
              backgroundColor: theme.colorScheme.onSurface.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _FavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isFavorite
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: isFavorite
                ? Colors.transparent
                : theme.colorScheme.onSurface.withAlpha(40),
          ),
        ),
        child: Icon(
          isFavorite ? SolarIconsOutline.heart : SolarIconsOutline.heart,
          color: isFavorite
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
