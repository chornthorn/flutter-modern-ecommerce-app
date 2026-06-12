import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/product_provider.dart';
import '../widgets/cart_badge.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  String _resolveTitle(List<Category> categories, String? selectedCategoryId, String searchQuery) {
    if (searchQuery.trim().isNotEmpty) {
      return 'Search: $searchQuery';
    }
    if (selectedCategoryId != null) {
      return '${categories
              .firstWhere(
                (category) => category.id == selectedCategoryId,
                orElse: () => Category(id: '', name: 'Products', iconName: ''),
              )
              .name} Products';
    }
    return 'All Products';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productProvider = context.watch<ProductProvider>();
    final filteredProducts = productProvider.filteredProducts;
    final categories = productProvider.categories;
    final selectedCategoryId = productProvider.selectedCategoryId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _resolveTitle(categories, selectedCategoryId, productProvider.searchQuery),
        ),
        actions: const [CartBadge()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: productProvider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: productProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          productProvider.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CategoryChip(
                    category: const Category(id: 'all', name: 'All', iconName: 'apps'),
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
          const SizedBox(height: 8),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
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
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/product-detail',
                          arguments: product,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
