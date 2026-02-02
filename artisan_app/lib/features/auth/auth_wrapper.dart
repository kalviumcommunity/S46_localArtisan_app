import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../customer/customer_home.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is active, check for user data
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          
          if (user == null) {
            // User is NOT logged in
            return const LoginScreen();
          } else {
            // User IS logged in
            // TODO: You could add a check here to fetch the user's role 
            // from Firestore and redirect to either CustomerHome or ArtisanDashboard
            return const CustomerHome(); 
          }
        }

        // Show a loading screen while checking connection
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
