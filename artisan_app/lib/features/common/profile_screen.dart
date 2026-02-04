import 'package:flutter/material.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/services/firestore_service.dart';
import 'package:backend/models/user_model.dart';
import '../../core/colors.dart';
import 'edit_profile_screen.dart';
import 'address_management_screen.dart';
import 'settings_screen.dart';

import 'payment_methods_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _handleLogout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = _authService.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }

    return StreamBuilder<AppUser?>(
      stream: _firestoreService.userProfileStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final profile = snapshot.data;
        if (profile == null) {
          return const Scaffold(body: Center(child: Text('Profile not found')));
        }

        final canPop = Navigator.of(context).canPop();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: canPop ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ) : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Summary Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.primaryColor.withAlpha(50), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primary,
                          child: profile.profileImageUrl != null 
                            ? ClipOval(child: Image.network(profile.profileImageUrl!, fit: BoxFit.cover))
                            : const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(profile.fullName, style: theme.textTheme.titleLarge),
                      Text(
                        '${profile.role == UserRole.artisan ? 'Artisan' : 'Customer'}', 
                        style: TextStyle(color: Colors.grey[500], fontSize: 13)
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Essential Actions
                _buildSection(context, 'Account', [
                  _buildSettingItem(Icons.edit_outlined, 'Edit Profile', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(user: profile)));
                  }),
                  _buildNotificationToggle(profile),
                  _buildSettingItem(Icons.help_outline_rounded, 'Help & Support', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                  }),
                ]),
                
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withAlpha(50)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationToggle(AppUser profile) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
        child: const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.textPrimary),
      ),
      title: const Text('Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Switch.adaptive(
        value: true, // TODO: Pull from settings model
        onChanged: (val) {},
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(title, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
    );
  }
}
