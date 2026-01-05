import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../user_manager.dart';
import '../pages/models/product.dart';
import 'store_management_page.dart';

class ProductUploadPage extends StatefulWidget {
  const ProductUploadPage({super.key});

  @override
  State<ProductUploadPage> createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sizesController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  List<File> _productImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _productImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _productImages.isNotEmpty) {
      // Parse sizes from comma-separated string
      List<String> sizes = _sizesController.text
          .split(',')
          .map((size) => size.trim())
          .where((size) => size.isNotEmpty)
          .toList();

      // Create product
      Product newProduct = Product(
        name: _productNameController.text,
        image: _productImages.first.path, // Use first image as main image
        price: 'Rp ${_priceController.text}',
        sold: '0',
        description: _descriptionController.text,
        sizes: sizes,
        discount: _discountController.text.isNotEmpty
            ? _discountController.text
            : null,
        storeName: UserManager.currentUser.storeName!,
      );

      // Add to store
      UserManager.addProductToStore(newProduct);

      // Navigate to StoreManagementPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StoreManagementPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Harap lengkapi semua field dan upload minimal 1 foto produk')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Upload Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFEE4D2D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Upload Produk Pertama Anda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Nama Produk
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama produk' : null,
              ),
              const SizedBox(height: 20),

              // Harga
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga (contoh: 50000)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Masukkan harga' : null,
              ),
              const SizedBox(height: 20),

              // Deskripsi
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Produk',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan deskripsi produk' : null,
              ),
              const SizedBox(height: 20),

              // Ukuran/Varian
              TextFormField(
                controller: _sizesController,
                decoration: const InputDecoration(
                  labelText:
                      'Ukuran/Varian (pisahkan dengan koma, contoh: S,M,L)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan ukuran/varian produk' : null,
              ),
              const SizedBox(height: 20),

              // Diskon (Opsional)
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(
                  labelText: 'Diskon (opsional, contoh: 10%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),

              // Foto Produk
              const Text('Foto Produk',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _productImages.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _productImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(_productImages[index],
                                  width: 100, height: 100, fit: BoxFit.cover),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(Icons.add_photo_alternate,
                              size: 50, color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Upload Produk',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
