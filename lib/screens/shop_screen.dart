import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/cart_badge.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  _SortOption _sortOption = _SortOption.featured;

  @override
  void initState() {
    super.initState();
    _searchController.text = context.read<ProductProvider>().searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CategoryItem> _categoryItems(List<Category> categories) {
    return [
      const _CategoryItem(id: null, name: 'All', iconName: 'apps'),
      ...categories.map(
        (c) => _CategoryItem(id: c.id, name: c.name, iconName: c.iconName),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productProvider = context.watch<ProductProvider>();
    final products = _sortedProducts(productProvider.filteredProducts);
    final categories = productProvider.categories;
    final selectedCategoryId = productProvider.selectedCategoryId;

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shop',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const CartBadge(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return TextField(
                      controller: _searchController,
                      onChanged: productProvider.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(SolarIconsOutline.magnifier),
                        suffixIcon: value.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(SolarIconsOutline.closeSquare),
                                onPressed: () {
                                  _searchController.clear();
                                  productProvider.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Categories',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categoryItems(categories).length,
                  itemBuilder: (context, index) {
                    final items = _categoryItems(categories);
                    final item = items[index];
                    return CategoryChip(
                      category: item.toCategory(),
                      isSelected: item.id == selectedCategoryId,
                      onTap: () => productProvider.selectCategory(item.id),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _PromoBanner(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${products.length} Products',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                    _SortDropdown(
                      value: _sortOption,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _sortOption = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        SolarIconsOutline.magnifier,
                        size: 64,
                        color: theme.colorScheme.onSurface.withAlpha(100),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/product-detail',
                          arguments: product,
                        ),
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Product> _sortedProducts(List<Product> products) {
    final list = List<Product>.from(products);
    switch (_sortOption) {
      case _SortOption.featured:
        return list;
      case _SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
        return list;
      case _SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
        return list;
      case _SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        return list;
    }
  }
}

enum _SortOption {
  featured('Featured'),
  priceLow('Price: Low to High'),
  priceHigh('Price: High to Low'),
  rating('Top Rated');

  final String label;
  const _SortOption(this.label);
}

class _SortDropdown extends StatelessWidget {
  final _SortOption value;
  final ValueChanged<_SortOption?> onChanged;

  const _SortDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(30),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_SortOption>(
          value: value,
          icon: const Icon(SolarIconsOutline.altArrowDown, size: 18),
          style: theme.textTheme.bodySmall,
          borderRadius: BorderRadius.circular(12),
          items: _SortOption.values.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String? id;
  final String name;
  final String iconName;

  const _CategoryItem({
    required this.id,
    required this.name,
    required this.iconName,
  });

  Category toCategory() => Category(
        id: id ?? 'all',
        name: name,
        iconName: iconName,
      );
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summer Sale',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Up to 50% off on selected items',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              SolarIconsOutline.altArrowRight,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
