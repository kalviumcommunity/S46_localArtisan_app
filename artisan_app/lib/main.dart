import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'core/theme.dart';
import 'features/customer/customer_home.dart';
import 'features/customer/order_tracking.dart';
import 'features/customer/product_details.dart';
import 'features/common/notifications_screen.dart';
import 'features/common/profile_screen.dart';
import 'features/artisan/artisan_profile_setup.dart';
import 'features/artisan/artisan_dashboard.dart';
import 'features/artisan/product_management.dart';
import 'features/auth/auth_wrapper.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/role_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const AuthWrapper(),
      routes: {
        // Onboarding
        '/onboarding': (context) => const OnboardingScreen(),

        // Auth Flow
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
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

