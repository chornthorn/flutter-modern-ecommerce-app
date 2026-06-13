import 'package:flutter/material.dart';

import 'models/order.dart';
import 'models/product.dart';
import 'screens/addresses_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/order_success_screen.dart';
import 'screens/payment_methods_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/welcome':
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case '/onboarding':
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case '/':
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
      case '/search':
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
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
      case '/favorites':
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
          settings: settings,
        );
      case '/checkout':
        return MaterialPageRoute(
          builder: (_) => const CheckoutScreen(),
          settings: settings,
        );
      case '/order-success':
        return MaterialPageRoute(
          builder: (_) => const OrderSuccessScreen(),
          settings: settings,
        );
      case '/order-history':
        return MaterialPageRoute(
          builder: (_) => const OrderHistoryScreen(),
          settings: settings,
        );
      case '/order-detail':
        final order = settings.arguments;
        if (order is Order) {
          return MaterialPageRoute(
            builder: (_) => OrderDetailScreen(order: order),
            settings: settings,
          );
        }
        return _errorRoute(settings, 'Missing or invalid Order argument');
      case '/orders':
        return MaterialPageRoute(
          builder: (_) => const OrderHistoryScreen(),
          settings: settings,
        );
      case '/addresses':
        return MaterialPageRoute(
          builder: (_) => const AddressesScreen(),
          settings: settings,
        );
      case '/payment-methods':
        return MaterialPageRoute(
          builder: (_) => const PaymentMethodsScreen(),
          settings: settings,
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
      case '/forgot-password':
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
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
