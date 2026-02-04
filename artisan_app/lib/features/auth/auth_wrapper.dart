import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:backend/services/firestore_service.dart';
import 'package:backend/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../customer/customer_home.dart';
import '../artisan/artisan_dashboard.dart';
import '../onboarding/onboarding_screen.dart';
import 'login_screen.dart';
import 'role_selection_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _showOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Temporarily forcing onboarding to show for user verification
      _showOnboarding = true; 
      // Original logic: _showOnboarding = !(prefs.getBool('onboarding_seen') ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_showOnboarding!) {
      return const OnboardingScreen();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          
          if (user == null) {
            return const LoginScreen();
          } else {
            return FutureBuilder<AppUser?>(
              future: FirestoreService().getUserProfile(user.uid),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.connectionState == ConnectionState.done) {
                  if (profileSnapshot.hasData && profileSnapshot.data != null) {
                    final role = profileSnapshot.data!.role;
                    // In your model, if role is converted from String, make sure it's correct
                    // Assuming the model handles the mapping correctly
                    if (role == UserRole.artisan) {
                      return const ArtisanDashboard();
                    } else {
                      return const CustomerHome();
                    }
                  }
                  
                  // If profile doesn't exist or role is not set, show Role Selection Screen
                  return const RoleSelectionScreen();
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          }
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
