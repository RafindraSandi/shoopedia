import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'store_info_form_page.dart';

class VerificationFormPage extends StatefulWidget {
  const VerificationFormPage({super.key});

  @override
  State<VerificationFormPage> createState() => _VerificationFormPageState();
}

class _VerificationFormPageState extends State<VerificationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _jenisUsaha;
  File? _ktpImage;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _ktpImage = File(image.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _ktpImage != null &&
        _jenisUsaha != null) {
      // Navigate to StoreInfoFormPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StoreInfoFormPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Harap lengkapi semua field dan upload foto KTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verifikasi Data Diri',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFEE4D2D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Verifikasi Data Diri untuk Menjadi Penjual',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Jenis Usaha
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jenis Usaha',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white,
                value: _jenisUsaha,
                items: const [
                  DropdownMenuItem(
                      value: 'perorangan', child: Text('Perorangan')),
                  DropdownMenuItem(
                      value: 'perusahaan', child: Text('Perusahaan (CV, PT)')),
                ],
                onChanged: (value) {
                  setState(() {
                    _jenisUsaha = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih jenis usaha' : null,
              ),
              const SizedBox(height: 20),

              // Foto KTP
              const Text('Foto KTP',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _ktpImage != null
                      ? Image.file(_ktpImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.camera_alt,
                              size: 50, color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20),

              // Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama lengkap' : null,
              ),
              const SizedBox(height: 20),

              // NIK
              TextFormField(
                controller: _nikController,
                decoration: const InputDecoration(
                  labelText: 'NIK',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Masukkan NIK' : null,
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Lanjutkan',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
