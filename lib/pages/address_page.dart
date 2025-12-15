import 'package:flutter/material.dart';
import '../address_manager.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  void _showAddressForm({Address? address, int? index}) {
    final isEditing = address != null;
    final formKey = GlobalKey<FormState>();

    final fullNameController =
        TextEditingController(text: address?.fullName ?? '');
    final phoneController =
        TextEditingController(text: address?.phoneNumber ?? '');
    final provinceController =
        TextEditingController(text: address?.province ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final districtController =
        TextEditingController(text: address?.district ?? '');
    final postalCodeController =
        TextEditingController(text: address?.postalCode ?? '');
    final streetController =
        TextEditingController(text: address?.streetName ?? '');
    final houseController =
        TextEditingController(text: address?.houseNumber ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing ? 'Edit Alamat' : 'Tambah Alamat Baru',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: provinceController,
                  decoration: const InputDecoration(
                    labelText: 'Provinsi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'Kota',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: districtController,
                  decoration: const InputDecoration(
                    labelText: 'Kecamatan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Kode Pos',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Jalan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: houseController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Rumah',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            final newAddress = Address(
                              fullName: fullNameController.text,
                              phoneNumber: phoneController.text,
                              province: provinceController.text,
                              city: cityController.text,
                              district: districtController.text,
                              postalCode: postalCodeController.text,
                              streetName: streetController.text,
                              houseNumber: houseController.text,
                            );

                            setState(() {
                              if (isEditing && index != null) {
                                AddressManager.addresses[index] = newAddress;
                              } else {
                                AddressManager.addresses.add(newAddress);
                              }
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isEditing
                                    ? 'Alamat diperbarui'
                                    : 'Alamat ditambahkan'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEE4D2D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(isEditing ? 'Update' : 'Simpan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setPrimaryAddress(int index) {
    setState(() {
      for (int i = 0; i < AddressManager.addresses.length; i++) {
        AddressManager.addresses[i].isPrimary = i == index;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alamat utama diperbarui')),
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Alamat'),
        content: const Text('Apakah Anda yakin ingin menghapus alamat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                AddressManager.addresses.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alamat dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alamat Pengiriman"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[50],
      body: AddressManager.addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada alamat',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddressForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE4D2D),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Tambah Alamat'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: AddressManager.addresses.length + 1,
              itemBuilder: (context, index) {
                if (index == AddressManager.addresses.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddressForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Alamat Baru'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE4D2D),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  );
                }

                final address = AddressManager.addresses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (address.isPrimary)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Utama',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    _showAddressForm(
                                        address: address, index: index);
                                    break;
                                  case 'set_primary':
                                    _setPrimaryAddress(index);
                                    break;
                                  case 'delete':
                                    _deleteAddress(index);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                if (!address.isPrimary)
                                  const PopupMenuItem(
                                    value: 'set_primary',
                                    child: Text('Jadikan Utama'),
                                  ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          address.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address.phoneNumber,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(address.fullAddress),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Kode Pos: ${address.postalCode}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
