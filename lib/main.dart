import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'device_preview_devices.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'router.dart';
import 'services/onboarding_service.dart';
import 'theme.dart';

bool get _enableDevicePreview => kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasCompletedOnboarding =
      await OnboardingService().hasCompletedOnboarding();
  runApp(
    DevicePreview(
      enabled: _enableDevicePreview,
      devices: previewMobileDevices,
      defaultDevice: previewDefaultDevice,
      builder: (context) => MainApp(
        hasCompletedOnboarding: hasCompletedOnboarding,
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MainApp({
    super.key,
    required this.hasCompletedOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ],
      child: MaterialApp(
        title: 'Minimal Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        initialRoute: hasCompletedOnboarding ? '/' : '/welcome',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
