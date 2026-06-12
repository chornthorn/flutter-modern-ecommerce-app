import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    _controller = TextEditingController(text: provider.searchQuery);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final provider = context.read<ProductProvider>();
    provider.setSearchQuery(query);
    if (query.trim().isNotEmpty) {
      provider.addRecentSearch(query);
    }
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productProvider = context.watch<ProductProvider>();
    final recentSearches = productProvider.recentSearches;
    final query = productProvider.searchQuery.trim();
    final results = query.isEmpty ? <void>[] : productProvider.filteredProducts;
    final showRecents = query.isEmpty && recentSearches.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppSearchBar(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          onChanged: productProvider.setSearchQuery,
          onClear: () => productProvider.setSearchQuery(''),
        ),
        actions: [
          if (query.isNotEmpty)
            TextButton(
              onPressed: () => _performSearch(_controller.text),
              child: const Text('Search'),
            ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (showRecents)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent searches',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: productProvider.clearRecentSearches,
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: recentSearches.map((term) {
                          return _RecentChip(
                            term: term,
                            onTap: () {
                              _controller.text = term;
                              _controller.selection = TextSelection.collapsed(
                                offset: term.length,
                              );
                              _performSearch(term);
                            },
                            onDeleted: () {
                              productProvider.removeRecentSearch(term);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            if (query.isNotEmpty && results.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptySearchState(),
              )
            else if (query.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = productProvider.filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/product-detail',
                          arguments: product,
                        ),
                      );
                    },
                    childCount: productProvider.filteredProducts.length,
                  ),
                ),
              ),
            if (query.isEmpty && recentSearches.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptySearchState(),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _RecentChip extends StatelessWidget {
  final String term;
  final VoidCallback onTap;
  final VoidCallback onDeleted;

  const _RecentChip({
    required this.term,
    required this.onTap,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 16,
                color: theme.colorScheme.onSurface.withAlpha(140),
              ),
              const SizedBox(width: 6),
              Text(
                term,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.onSurface.withAlpha(140),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: theme.colorScheme.onSurface.withAlpha(60),
            ),
            const SizedBox(height: 16),
            Text(
              'Start typing to search',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find products by name, category or description.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(140),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
