import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/role_selection_screen.dart';
import 'features/artisan/artisan_profile_setup.dart';
import 'features/artisan/artisan_dashboard.dart';
import 'features/artisan/product_management.dart';
import 'features/customer/customer_home.dart';
import 'features/customer/order_tracking.dart';
import 'features/customer/product_details.dart';
import 'features/common/notifications_screen.dart';
import 'features/common/profile_screen.dart';

void main() {
  runApp(const LocalArtisanApp());
}

class LocalArtisanApp extends StatelessWidget {
  const LocalArtisanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Artisan Digital Storefront',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),
        
        // Artisan Flow
        '/artisan-setup': (context) => const ArtisanProfileSetup(),
        '/artisan-dashboard': (context) => const ArtisanDashboard(),
        '/add-product': (context) => const AddProductScreen(),
        
        // Customer Flow
        '/customer-home': (context) => const CustomerHome(),
        '/product-detail': (context) => const ProductDetailScreen(),
        '/order-tracking': (context) => const OrderTrackingScreen(),
        
        // Common
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

