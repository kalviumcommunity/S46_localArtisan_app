import 'package:flutter/material.dart';
import '../../core/colors.dart';


class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: theme.primaryColor.withAlpha(10),
                       shape: BoxShape.circle,
                     ),
                     child: Icon(Icons.add_a_photo_outlined, size: 40, color: theme.primaryColor),
                   ),
                  const SizedBox(height: 16),
                  Text(
                    'Add Product Image',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG, JPG up to 10MB',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Product Title', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(hintText: 'e.g. Handmade Ceramic Vase'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      const TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixIcon: Icon(Icons.currency_rupee_rounded, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Pottery',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Description', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write a detailed description of your product...',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('List Product'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

