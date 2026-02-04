import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/services/firestore_service.dart';
import 'package:backend/services/storage_service.dart';
import 'package:backend/models/product_model.dart';
import '../../core/colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  String? _selectedCategory;
  final _descriptionController = TextEditingController();
  
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final _storageService = StorageService();
  
  File? _imageFile;
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a product image')));
      return;
    }

    final user = _authService.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      // 1. Upload Image
      final imageUrl = await _storageService.uploadProductImage(
        artisanId: user.uid,
        imageFile: _imageFile!,
        productName: _nameController.text.trim(),
      );

      // imageUrl shouldn't be null if uploadProductImage rethrows, but as a safety check:
      if (imageUrl == null) throw Exception('Image upload failed without specific error');

      // 2. Save Product metadata
      final product = Product(
        id: '', // Firestore will generate ID
        artisanId: user.uid,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stockQuantity: int.tryParse(_stockController.text.trim()) ?? 0,
        category: _selectedCategory ?? 'Other',
        description: _descriptionController.text.trim(),
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addProduct(product);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString();
        bool isBillingError = errorMsg.contains('firebase_storage/unauthorized') || errorMsg.contains('upgrade your project');
        
        if (isBillingError) {
          errorMsg = 'Upload failed: Firebase Storage requires a Blaze plan (Premium).';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMsg'), 
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Use Placeholder',
              textColor: Colors.white,
              onPressed: () => _saveWithPlaceholder(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveWithPlaceholder() async {
    final user = _authService.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      // Use a high-quality relevant placeholder based on category
      String placeholderUrl = 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=500&auto=format&fit=crop'; // Default pottery
      
      if (_selectedCategory == 'Wooden Craft') {
        placeholderUrl = 'https://images.unsplash.com/photo-1610701596007-11158694de5e?q=80&w=500&auto=format&fit=crop';
      } else if (_selectedCategory == 'Handwoven Textiles') {
        placeholderUrl = 'https://images.unsplash.com/photo-1544441893-675973e31985?q=80&w=500&auto=format&fit=crop';
      } else if (_selectedCategory == 'Jewelry & Ornaments') {
        placeholderUrl = 'https://images.unsplash.com/photo-1515562141207-7aebd8b5c4ad?q=80&w=500&auto=format&fit=crop';
      }

      final product = Product(
        id: '', 
        artisanId: user.uid,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stockQuantity: int.tryParse(_stockController.text.trim()) ?? 0,
        category: _selectedCategory ?? 'Other',
        description: _descriptionController.text.trim(),
        imageUrl: placeholderUrl,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addProduct(product);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added with placeholder image!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New Listing', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.border),
                    image: _imageFile != null ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover) : null,
                  ),
                  child: _imageFile == null ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Container(
                         padding: const EdgeInsets.all(20),
                         decoration: BoxDecoration(
                           color: AppColors.primary.withOpacity(0.08),
                           shape: BoxShape.circle,
                         ),
                         child: const Icon(Icons.add_a_photo_rounded, size: 36, color: AppColors.primary),
                       ),
                      const SizedBox(height: 16),
                      const Text(
                        'Add Product Photos',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Showcase your craft from all angles',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ) : Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.edit_rounded, size: 20, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildInputField('Product Title', 'e.g. Blue Ceramic Table Lamp', controller: _nameController),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      'Price', 
                      '0.00', 
                      icon: Icons.currency_rupee_rounded, 
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      'Stock Qty', 
                      '1', 
                      icon: Icons.inventory_2_outlined,
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: FirestoreService.categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.category_outlined, size: 20, color: Colors.grey),
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInputField('Description', 'Tell the story behind this piece...', maxLines: 5, controller: _descriptionController),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Publish Listing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {IconData? icon, int maxLines = 1, TextEditingController? controller, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.grey) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}

