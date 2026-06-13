import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

enum _SortOption {
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  rating('Rating');

  final String label;
  const _SortOption(this.label);
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  _SortOption _sortOption = _SortOption.priceLowToHigh;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _resolveTitle(
    List<Category> categories,
    String? selectedCategoryId,
    String searchQuery,
  ) {
    if (searchQuery.trim().isNotEmpty) {
      return 'Search Results';
    }
    if (selectedCategoryId != null) {
      final category = categories.firstWhere(
        (category) => category.id == selectedCategoryId,
        orElse: () => const Category(id: '', name: 'Products', iconName: ''),
      );
      return '${category.name} Products';
    }
    return 'All Products';
  }

  List<Product> _sortProducts(List<Product> products) {
    final sorted = List<Product>.from(products);
    switch (_sortOption) {
      case _SortOption.priceLowToHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case _SortOption.priceHighToLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case _SortOption.rating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return sorted;
  }

  void _clearFilters(ProductProvider provider) {
    _searchController.clear();
    provider.setSearchQuery('');
    provider.selectCategory(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productProvider = context.watch<ProductProvider>();
    final categories = productProvider.categories;
    final selectedCategoryId = productProvider.selectedCategoryId;
    final sortedProducts = _sortProducts(productProvider.filteredProducts);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _resolveTitle(
            categories,
            selectedCategoryId,
            productProvider.searchQuery,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
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
                              onPressed: () => _clearFilters(productProvider),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return CategoryChip(
                      category: const Category(
                        id: 'all',
                        name: 'All',
                        iconName: 'apps',
                      ),
                      isSelected: selectedCategoryId == null,
                      onTap: () => productProvider.selectCategory(null),
                    );
                  }
                  final category = categories[index - 1];
                  return CategoryChip(
                    category: category,
                    isSelected: category.id == selectedCategoryId,
                    onTap: () => productProvider.selectCategory(category.id),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    '${sortedProducts.length} '
                    '${sortedProducts.length == 1 ? 'product' : 'products'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<_SortOption>(
                    initialValue: _sortOption,
                    color: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) => setState(() => _sortOption = value),
                    itemBuilder: (context) {
                      return _SortOption.values.map((option) {
                        return PopupMenuItem<_SortOption>(
                          value: option,
                          child: Text(
                            option.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _sortOption.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            SolarIconsOutline.altArrowDown,
                            color: theme.colorScheme.onPrimary,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (sortedProducts.isEmpty)
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your search or filters',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (productProvider.searchQuery.isNotEmpty ||
                        selectedCategoryId != null)
                      ElevatedButton.icon(
                        onPressed: () => _clearFilters(productProvider),
                        icon: const Icon(SolarIconsOutline.listCross),
                        label: const Text('Clear filters'),
                      ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = sortedProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.of(context).pushNamed(
                        '/product-detail',
                        arguments: product,
                      ),
                    );
                  },
                  childCount: sortedProducts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
