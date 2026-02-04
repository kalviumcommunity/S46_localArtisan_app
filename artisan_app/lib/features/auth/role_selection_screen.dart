import 'package:flutter/material.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/services/firestore_service.dart';
import 'package:backend/models/user_model.dart';
import 'package:backend/models/artisan_model.dart';
import '../../core/colors.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  Future<void> _selectRole(UserRole role) async {
    final user = _authService.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      // Fetch current profile or create a minimal one with the selected role
      AppUser? profile = await _firestoreService.getUserProfile(user.uid);
      
      if (profile == null) {
        // Create new profile if it doesn't exist (e.g., social login first time)
        profile = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          fullName: user.displayName ?? 'New User',
          role: role,
          createdAt: DateTime.now(),
        );
      } else {
        // Update existing profile's role
        profile = AppUser(
          uid: profile.uid,
          email: profile.email,
          fullName: profile.fullName,
          role: role,
          profileImageUrl: profile.profileImageUrl,
          createdAt: profile.createdAt,
        );
      }

      await _firestoreService.createUserProfile(profile);
      
      // If role is Artisan, create an initial artisan profile document
      if (role == UserRole.artisan) {
        final artisan = Artisan(
          uid: user.uid,
          shopName: '${profile.fullName}\'s Shop',
          shopDescription: 'Welcome to my handcrafted store!',
          createdAt: DateTime.now(),
        );
        await _firestoreService.createArtisanProfile(artisan);
      }
      
      if (mounted) {
        // Navigate based on selected role
        if (role == UserRole.artisan) {
          Navigator.pushReplacementNamed(context, '/artisan-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/customer-home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating role: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Join Us As...',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Choose how you want to interact with our community',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: Column(
                  children: [
                    _RoleCard(
                      title: 'Artisan',
                      description: 'I want to sell my handcrafted products and manage my storefront.',
                      icon: Icons.storefront_outlined,
                      onTap: () => _selectRole(UserRole.artisan),
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),
                    _RoleCard(
                      title: 'Customer',
                      description: 'I want to discover and buy authentic local products.',
                      icon: Icons.shopping_bag_outlined,
                      onTap: () => _selectRole(UserRole.customer),
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: AppColors.primary, size: 36),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.border,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
