import 'package:flutter/material.dart';

import 'models/product.dart';
import 'screens/cart_screen.dart';
import 'screens/main_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_list_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
      case '/product-list':
        return MaterialPageRoute(
          builder: (_) => const ProductListScreen(),
          settings: settings,
        );
      case '/product-detail':
        final product = settings.arguments;
        if (product is Product) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
            settings: settings,
          );
        }
        return _errorRoute(settings, 'Missing or invalid Product argument');
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );
      default:
        return _errorRoute(settings, 'Route not found');
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
      settings: settings,
    );
  }
}
