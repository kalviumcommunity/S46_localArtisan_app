import 'package:flutter/material.dart';
import 'package:backend/services/firestore_service.dart';
import '../../core/colors.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final String userId;
  const PaymentMethodsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.userPaymentMethodsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final methods = snapshot.data ?? [];
          if (methods.isEmpty) {
            return const Center(child: Text('No payment methods saved.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      method['type'] == 'UPI' ? Icons.account_balance_wallet_outlined : Icons.credit_card_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(method['title'] ?? 'Payment Method', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(method['details'] ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPaymentDialog(context),
        label: const Text('Add Method'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Add Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title (e.g. My PhonePe)')),
            TextField(controller: detailsController, decoration: const InputDecoration(labelText: 'UPI ID or Card Hint')),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await FirestoreService().addPaymentMethod(userId, {
                  'title': titleController.text,
                  'details': detailsController.text,
                  'type': titleController.text.contains('UPI') ? 'UPI' : 'Card',
                  'createdAt': DateTime.now().toIso8601String(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
              child: const Text('Save Method'),
            ),
          ],
        ),
      ),
    );
  }
}
