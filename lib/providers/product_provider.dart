import 'package:flutter/foundation.dart' hide Category;

import '../data/mock_data.dart';
import '../models/category.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = List.unmodifiable(mockProducts);
  final List<Category> _categories = List.unmodifiable(mockCategories);
  final Set<String> _favoriteIds = <String>{};

  String? _selectedCategoryId;
  String _searchQuery = '';

  List<Product> get products => _products;

  List<Category> get categories => _categories;

  String? get selectedCategoryId => _selectedCategoryId;

  String get searchQuery => _searchQuery;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  List<Product> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == null || product.category == _selectedCategoryId;
      final normalizedQuery = _searchQuery.toLowerCase().trim();
      final matchesSearch = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Product> get featuredProducts {
    return _products.where((product) => product.rating >= 4.5 && product.inStock).toList();
  }
}
