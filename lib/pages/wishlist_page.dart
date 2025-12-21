import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Data Dummy Barang Favorit
  List<Map<String, dynamic>> wishlistItems = [
    {
      "name": "Sepatu Lari Pria Import",
      "price": "Rp 150.000",
      "image": "https://img.lazcdn.com/g/p/2b26740520795b6cc4a47a247a30f2b4.jpg_720x720q80.jpg", 
    },
    {
      "name": "Headset Bluetooth Gaming",
      "price": "Rp 85.000",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYLN2Idizgl-iqMyPzl_qXL5dE9-6sJnRQxA&s",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: wishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text("Belum ada produk favorit", style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cari Barang", style: TextStyle(color: Color(0xFFEE4D2D))),
                  )
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            item['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (ctx, error, stack) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['price'],
                              style: const TextStyle(
                                  color: Color(0xFFEE4D2D), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // Tombol Hapus & Keranjang
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                wishlistItems.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Dihapus dari favorit")),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFEE4D2D)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Masuk keranjang!")),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
