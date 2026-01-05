import 'package:flutter/material.dart';
import '../user_manager.dart';
import 'product_upload_page.dart';

class StoreInfoFormPage extends StatefulWidget {
  const StoreInfoFormPage({super.key});

  @override
  State<StoreInfoFormPage> createState() => _StoreInfoFormPageState();
}

class _StoreInfoFormPageState extends State<StoreInfoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeDescriptionController =
      TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Set user as seller
      UserManager.becomeSeller(
          _storeNameController.text, _storeDescriptionController.text);

      // Navigate to ProductUploadPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductUploadPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Informasi Toko', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFEE4D2D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Isi Informasi Toko Anda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Nama Toko
              TextFormField(
                controller: _storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama toko' : null,
              ),
              const SizedBox(height: 20),

              // Deskripsi Toko
              TextFormField(
                controller: _storeDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Toko',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan deskripsi toko' : null,
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Buat Toko',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
