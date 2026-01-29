import 'package:flutter/material.dart';
import '../../core/colors.dart';


class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                   Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: theme.primaryColor.withAlpha(10),
                       borderRadius: BorderRadius.circular(16),
                     ),
                     child: Icon(Icons.shopping_bag_rounded, color: theme.primaryColor),
                   ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order #4829', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Handmade Ceramic Floor Vase', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ),
                  const Text('₹ 2,400', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text('Live Tracking', style: theme.textTheme.titleMedium),
            const SizedBox(height: 32),
            
            const TrackingStep(
              title: 'Order Placed',
              subtitle: '24 Jan, 10:30 AM',
              description: 'We have received your order and notified the artisan.',
              isCompleted: true,
            ),
            const TrackingStep(
              title: 'Order Accepted',
              subtitle: '24 Jan, 11:15 AM',
              description: 'Arun Kumar has accepted your order and is preparing it.',
              isCompleted: true,
            ),
            const TrackingStep(
              title: 'Ready for Collection',
              subtitle: 'Estimated: Today, 4:00 PM',
              description: 'Your items will be ready for pickup at the artisan studio.',
              isActive: true,
            ),
            const TrackingStep(
              title: 'Completed',
              subtitle: 'Pending pickup',
              description: 'Confirm collection once you receive your handmade treasures.',
              isLast: true,
            ),
            
            const SizedBox(height: 40),
            // Artisan Mini Profile
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.primaryColor.withAlpha(20)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Arun Kumar', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Artisan • 2.5 km away', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.message_rounded, size: 20, color: theme.primaryColor),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.directions_rounded, size: 20, color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class TrackingStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;

  const TrackingStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.isCompleted = false,
    this.isActive = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted || isActive ? theme.primaryColor : Colors.grey[200],
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: theme.primaryColor.withAlpha(100), width: 6) : null,
                ),
                child: Center(
                  child: isCompleted 
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCompleted ? theme.primaryColor : Colors.grey[200],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isActive || isCompleted ? AppColors.textPrimary : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isActive ? theme.primaryColor : Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: isCompleted || isActive ? Colors.grey[600] : Colors.grey[400],
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
                if (!isLast) const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

