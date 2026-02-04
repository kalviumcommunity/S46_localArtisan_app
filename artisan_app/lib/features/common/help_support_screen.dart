import 'package:flutter/material.dart';
import '../../core/colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideSection(
              title: 'Getting Started',
              items: [
                _GuideItem(
                  icon: Icons.add_business_rounded,
                  title: 'How to add products?',
                  content: 'Tap the "Add" button on your dashboard or products tab. Fill in the details, upload a clear photo, and publish your craft!',
                ),
                _GuideItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'How orders work?',
                  content: 'When a customer buys your product, you\'ll get a notification. Go to the "Orders" tab to manage and update order status.',
                ),
                _GuideItem(
                  icon: Icons.payments_outlined,
                  title: 'How earnings are calculated?',
                  content: 'Your total earnings show the sum of all orders marked as "Delivered". Payments are processed according to our seller policy.',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildGuideSection(
              title: 'Usage Instructions',
              items: [
                _GuideItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Managing your shop',
                  content: 'Keep your product descriptions detailed and prices competitive. High-quality images attract more customers!',
                ),
                _GuideItem(
                  icon: Icons.support_agent_rounded,
                  title: 'Contact Support',
                  content: 'Need more help? Email us at support@localartisan.com or visit our website for detailed documentation.',
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'v1.0.0 • Made with ❤️ for Artisans',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }
}

class _GuideItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _GuideItem({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
