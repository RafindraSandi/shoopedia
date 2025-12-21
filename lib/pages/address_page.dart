import 'package:flutter/material.dart';
import '../address_manager.dart'; // Mundur satu folder

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();

  void _showAddressForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 20, left: 20, right: 20
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Tambah Alamat Baru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Lengkap")),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "No. Telepon")),
              TextFormField(controller: _cityController, decoration: const InputDecoration(labelText: "Kota/Kecamatan")),
              TextFormField(controller: _streetController, decoration: const InputDecoration(labelText: "Nama Jalan, No. Rumah")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                   final newAddress = Address(
                     fullName: _nameController.text,
                     phoneNumber: _phoneController.text,
                     province: "Jawa Timur", // Default
                     city: _cityController.text,
                     district: "",
                     postalCode: "",
                     streetName: _streetController.text,
                     houseNumber: "",
                     isPrimary: AddressManager.addresses.isEmpty
                   );
                   
                   setState(() {
                     AddressManager.addresses.add(newAddress);
                   });
                   Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEE4D2D)),
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alamat Saya")),
      body: AddressManager.addresses.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: _showAddressForm,
                child: const Text("Tambah Alamat"),
              ),
            )
          : ListView.builder(
              itemCount: AddressManager.addresses.length + 1,
              itemBuilder: (ctx, i) {
                if (i == AddressManager.addresses.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(onPressed: _showAddressForm, child: const Text("Tambah Alamat Lain")),
                  );
                }
                final item = AddressManager.addresses[i];
                return ListTile(
                  title: Text(item.fullName + (item.isPrimary ? " [Utama]" : "")),
                  subtitle: Text("${item.phoneNumber}\n${item.fullAddress}"),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => AddressManager.addresses.removeAt(i)),
                  ),
                );
              },
            ),
    );
  }
}
