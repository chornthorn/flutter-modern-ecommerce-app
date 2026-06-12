import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get itemMap => Map.unmodifiable(_items);

  List<CartItem> get items => List.unmodifiable(_items.values);

  int get itemCount => _items.values.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    return _items.values.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id] = CartItem(
        product: product,
        quantity: _items[product.id]!.quantity + 1,
      );
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  void updateQuantity(String productId, int quantity) {
    if (!_items.containsKey(productId)) return;

    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId] = CartItem(
        product: _items[productId]!.product,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
