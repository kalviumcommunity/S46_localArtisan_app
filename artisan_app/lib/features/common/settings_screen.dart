import 'package:flutter/material.dart';
import 'package:backend/services/firestore_service.dart';
import 'package:backend/models/user_model.dart';
import '../../core/colors.dart';

class SettingsScreen extends StatefulWidget {
  final AppUser user;
  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, bool> _notifications;
  late Map<String, bool> _privacy;
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notifications = Map<String, bool>.from(widget.user.notificationSettings);
    _privacy = Map<String, bool>.from(widget.user.privacySettings);
  }

  Future<void> _updateSettings() async {
    setState(() => _isSaving = true);
    try {
      final updatedUser = widget.user.copyWith(
        notificationSettings: _notifications,
        privacySettings: _privacy,
      );
      await _firestoreService.updateUserProfile(updatedUser);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isSaving 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildSectionTitle('Notifications'),
              _buildSwitchItem('Order Updates', _notifications['orderUpdates'] ?? false, (val) {
                setState(() => _notifications['orderUpdates'] = val);
                _updateSettings();
              }),
              _buildSwitchItem('Promotions', _notifications['promotions'] ?? false, (val) {
                setState(() => _notifications['promotions'] = val);
                _updateSettings();
              }),
              _buildSwitchItem('New Messages', _notifications['newMessages'] ?? false, (val) {
                setState(() => _notifications['newMessages'] = val);
                _updateSettings();
              }),
              
              const SizedBox(height: 32),
              _buildSectionTitle('Privacy'),
              _buildSwitchItem('Show Profile in Search', _privacy['showProfile'] ?? false, (val) {
                setState(() => _privacy['showProfile'] = val);
                _updateSettings();
              }),
              _buildSwitchItem('Share Analytics', _privacy['shareAnalytics'] ?? false, (val) {
                setState(() => _privacy['shareAnalytics'] = val);
                _updateSettings();
              }),

              const SizedBox(height: 48),
              TextButton(
                onPressed: () => _showDeleteAccountDialog(context),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: Text(title.toUpperCase(), style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildSwitchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This action is permanent and cannot be undone. All your data will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // Implementation would involve AuthService delete user logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion requested.')));
            }, 
            child: const Text('Delete', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}
