import 'package:flutter/material.dart';
import 'models/product.dart';
import '../keranjang_page.dart';
import '../cart_manager.dart';
import 'payment_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "";

  // Sample reviews data
  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Ahmad Rahman',
      'rating': 5,
      'comment': 'Produk bagus, sesuai deskripsi. Pengiriman cepat!',
      'date': '2024-01-15'
    },
    {
      'name': 'Siti Nurhaliza',
      'rating': 4,
      'comment': 'Kualitas baik, tapi packaging bisa lebih baik.',
      'date': '2024-01-10'
    },
    {
      'name': 'Budi Santoso',
      'rating': 5,
      'comment': 'Recomended seller! Produk original dan harga terjangkau.',
      'date': '2024-01-08'
    },
    {
      'name': 'Maya Sari',
      'rating': 3,
      'comment': 'Produk ok, tapi ada sedikit cacat kecil.',
      'date': '2024-01-05'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Detail Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // arahkan ke keranjang_page
            },
          ),
        ],
      ),

      // ===== BODY =====
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            Image.network(
              widget.product.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              },
            ),

            const SizedBox(height: 12),

            // Harga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.product.price,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            // Nama Produk
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Terjual
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${widget.product.sold} Terjual",
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const Divider(height: 32),

            // Pilih Ukuran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Pilih Ukuran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                children: widget.product.sizes.map((size) {
                  return ChoiceChip(
                    label: Text(size),
                    selected: selectedSize == size,
                    onSelected: (_) {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const Divider(height: 32),

            // Deskripsi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Deskripsi Produk",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.product.description),
            ),

            const Divider(height: 32),

            // Penilaian Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Penilaian Produk",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Rating
                  Row(
                    children: [
                      const Text(
                        "Rating Keseluruhan: ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          double averageRating = reviews.isNotEmpty
                              ? reviews
                                      .map((r) => r['rating'] as int)
                                      .reduce((a, b) => a + b) /
                                  reviews.length
                              : 0.0;
                          return Icon(
                            index < averageRating.floor()
                                ? Icons.star
                                : index < averageRating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        reviews.isNotEmpty
                            ? "${(reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) / reviews.length).toStringAsFixed(1)} (${reviews.length} ulasan)"
                            : "Belum ada ulasan",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Individual Reviews
                  ...reviews.map((review) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  review['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                      5,
                                      (index) => Icon(
                                            index < review['rating']
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review['comment'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review['date'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ===== BOTTOM BAR =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.green),
                  onPressed: () {
                    // Navigate to chat with seller
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chat dengan penjual')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text("Keranjang"),
                    onPressed: () {
                      // Add product to cart
                      // Parse price by removing "Rp" and "."
                      final priceString = widget.product.price
                          .replaceAll('Rp', '')
                          .replaceAll('.', '');
                      final price = int.parse(priceString);
                      final cartItem = CartItem(
                        shopName: "Shopeedia Store",
                        title: widget.product.name,
                        price: price,
                        quantity: 1,
                        stockLeft: 10, // Default stock
                        variant:
                            selectedSize.isNotEmpty ? selectedSize : "Default",
                        imagePath: widget.product.image,
                        selected: false,
                      );

                      CartManager.addToCart(cartItem);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Produk ditambahkan ke keranjang')),
                      );

                      // Navigate to cart page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KeranjangPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      // Parse price by removing "Rp" and "."
                      final priceString = widget.product.price
                          .replaceAll('Rp', '')
                          .replaceAll('.', '');
                      final price = int.parse(priceString);

                      // Create cart item for immediate purchase
                      final cartItem = CartItem(
                        shopName: "Shopeedia Store",
                        title: widget.product.name,
                        price: price,
                        quantity: 1,
                        stockLeft: 10, // Default stock
                        variant:
                            selectedSize.isNotEmpty ? selectedSize : "Default",
                        imagePath: widget.product.image,
                        selected: true, // Mark as selected for checkout
                      );

                      // Navigate directly to payment page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentPage(selectedItems: [cartItem]),
                        ),
                      );
                    },
                    child: const Text("Beli Sekarang"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
