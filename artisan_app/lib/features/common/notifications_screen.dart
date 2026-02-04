import 'package:flutter/material.dart';
import '../../core/colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // theme not required here; using AppColors and direct Colors instead.
    final notifications = [
      {
        'title': 'Order Delivered',
        'desc': 'Order #4820 has been picked up by Sarah Chen.',
        'time': '10 mins ago',
        'icon': Icons.check_circle_rounded,
        'color': Colors.green,
      },
      {
        'title': 'New Message',
        'desc': 'Arun Kumar sent you a photo of your ceramic vase.',
        'time': '1h ago',
        'icon': Icons.message_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Price Drop',
        'desc': 'An item in your wishlist "Handmade Pot" is now 20% off!',
        'time': '5h ago',
        'icon': Icons.local_offer_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'System Update',
        'desc': 'Welcome to Local Artisan! Start exploring nearby crafts.',
        'time': '1d ago',
        'icon': Icons.info_rounded,
        'color': AppColors.primary,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(item['time'] as String, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'] as String,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
