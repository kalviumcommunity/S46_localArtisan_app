import 'package:flutter/material.dart';
import 'package:backend/services/firestore_service.dart';
import 'package:backend/models/address_model.dart';
import '../../core/colors.dart';

class AddressManagementScreen extends StatelessWidget {
  final String userId;
  const AddressManagementScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Addresses', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<Address>>(
        stream: firestoreService.userAddressesStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final addresses = snapshot.data ?? [];
          if (addresses.isEmpty) {
            return const Center(child: Text('No addresses saved yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
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
                    const Icon(Icons.location_on_outlined, color: AppColors.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(address.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${address.street}, ${address.city}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => firestoreService.deleteAddress(userId, address.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(context),
        label: const Text('Add Address'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final labelController = TextEditingController();
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final zipController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text('Add New Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(controller: labelController, decoration: const InputDecoration(labelText: 'Label (e.g. Home)')),
              TextFormField(controller: streetController, decoration: const InputDecoration(labelText: 'Street')),
              TextFormField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
              TextFormField(controller: zipController, decoration: const InputDecoration(labelText: 'Zip Code')),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await FirestoreService().addAddress(userId, Address(
                      id: '',
                      label: labelController.text,
                      street: streetController.text,
                      city: cityController.text,
                      state: '',
                      zipCode: zipController.text,
                    ));
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
