import 'dart:io' as io;
import 'package:flutter/material.dart';
import '../user_manager.dart';
import 'product_upload_page.dart';

class StoreManagementPage extends StatefulWidget {
  const StoreManagementPage({super.key});

  @override
  State<StoreManagementPage> createState() => _StoreManagementPageState();
}

class _StoreManagementPageState extends State<StoreManagementPage> {
  Widget buildImageWidget(String url,
      {BoxFit fit = BoxFit.cover, double? width, double? height}) {
    try {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return Image.network(url, fit: fit, width: width, height: height);
      } else {
        final path =
            url.startsWith('file://') ? url.replaceFirst('file://', '') : url;
        final file = io.File(path);
        if (file.existsSync()) {
          return Image.file(file, fit: fit, width: width, height: height);
        } else {
          return Image.network(
            'https://via.placeholder.com/300?text=No+Image',
            fit: fit,
            width: width,
            height: height,
          );
        }
      }
    } catch (e) {
      return Image.network(
        'https://via.placeholder.com/300?text=Image+Error',
        fit: fit,
        width: width,
        height: height,
      );
    }
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              UserManager.removeProductFromStore(index);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _editProduct(int index) {
    // For simplicity, navigate to ProductUploadPage with edit mode
    // In a real app, you'd have a separate edit page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductUploadPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserManager.currentUser;
    final products = user.storeProducts ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(user.storeName ?? 'Toko Saya',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFEE4D2D),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('Belum ada produk. Tambahkan produk pertama Anda!'),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: buildImageWidget(product.image,
                        width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product.name),
                    subtitle: Text(product.price),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editProduct(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProduct(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductUploadPage()),
          );
        },
        backgroundColor: const Color(0xFFEE4D2D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
