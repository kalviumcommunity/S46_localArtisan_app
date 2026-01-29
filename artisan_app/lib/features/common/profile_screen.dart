import 'package:flutter/material.dart';
import '../../core/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
          ),
        ],
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
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                   Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.primaryColor.withAlpha(50), width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Kowsika Kumar', style: theme.textTheme.titleLarge),
                  Text('Artisan • Joined Jan 2026', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMiniStat('Orders', '42'),
                      Container(width: 1, height: 24, color: Colors.grey[200], margin: const EdgeInsets.symmetric(horizontal: 20)),
                      _buildMiniStat('Reviews', '124'),
                      Container(width: 1, height: 24, color: Colors.grey[200], margin: const EdgeInsets.symmetric(horizontal: 20)),
                      _buildMiniStat('Followers', '1.2k'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            _buildSection(context, 'Account Management', [
              _buildSettingItem(Icons.person_outline_rounded, 'Personal Information', () {}),
              _buildSettingItem(Icons.payment_rounded, 'Payment Methods', () {}),
              _buildSettingItem(Icons.location_on_outlined, 'Saved Addresses', () {}),
            ]),
            
            const SizedBox(height: 24),
            
            _buildSection(context, 'App Settings', [
              _buildSettingItem(Icons.notifications_none_rounded, 'Notification Preferences', () {}),
              _buildSettingItem(Icons.security_rounded, 'Privacy & Security', () {}),
              _buildSettingItem(Icons.help_outline_rounded, 'Help & Support', () {}),
            ]),
            
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('Log Out'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red.withAlpha(50)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
      ],
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
    );
  }
}
