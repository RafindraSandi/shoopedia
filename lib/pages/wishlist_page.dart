import 'package:flutter/material.dart';
import '../wishlist_manager.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: WishlistManager.wishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text("Belum ada produk favorit",
                      style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cari Barang",
                        style: TextStyle(color: Color(0xFFEE4D2D))),
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
              itemCount: WishlistManager.wishlistItems.length,
              itemBuilder: (context, index) {
                final item = WishlistManager.wishlistItems[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1), blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: Image.network(
                            item.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (ctx, error, stack) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.price,
                              style: const TextStyle(
                                  color: Color(0xFFEE4D2D),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // Tombol Hapus & Keranjang
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                WishlistManager.removeFromWishlist(item.name);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Dihapus dari favorit")),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined,
                                color: Color(0xFFEE4D2D)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Masuk keranjang!")),
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
