import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alamat Pengiriman")),
      body: const Center(child: Text("Halaman Alamat")),
    );
  }
}
