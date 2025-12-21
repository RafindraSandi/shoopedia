import 'package:flutter/material.dart';
import 'models/product.dart';      // Mengambil dari folder yang sama (pages/models)
import '../keranjang_page.dart';   // Mundur satu folder ke lib/
import '../cart_manager.dart';     // Mundur satu folder ke lib/
import 'payment_page.dart';        // File ini ada di folder yang sama (pages/)

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "";

  // Data ulasan dummy
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KeranjangPage()),
              );
            },
          ),
        ],
      ),
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
                  color: Color(0xFFEE4D2D), // Warna Shopee
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
            if (widget.product.sizes.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
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
            ],

            // Deskripsi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Deskripsi Produk",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.product.description),
            ),
            
            const SizedBox(height: 100), // Ruang bawah
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text("Keranjang"),
                onPressed: () {
                  // Logika Tambah ke Keranjang
                  final priceString = widget.product.price
                      .replaceAll('Rp', '')
                      .replaceAll('.', '');
                  final price = int.tryParse(priceString) ?? 0;
                  
                  final cartItem = CartItem(
                    shopName: "Shopeedia Store",
                    title: widget.product.name,
                    price: price,
                    quantity: 1,
                    stockLeft: 99,
                    variant: selectedSize.isNotEmpty ? selectedSize : "Standard",
                    imagePath: widget.product.image,
                    selected: false,
                  );

                  CartManager.addToCart(cartItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produk masuk keranjang!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Logika Beli Langsung
                  final priceString = widget.product.price
                      .replaceAll('Rp', '')
                      .replaceAll('.', '');
                  final price = int.tryParse(priceString) ?? 0;

                  final cartItem = CartItem(
                    shopName: "Shopeedia Store",
                    title: widget.product.name,
                    price: price,
                    quantity: 1,
                    stockLeft: 99,
                    variant: selectedSize.isNotEmpty ? selectedSize : "Standard",
                    imagePath: widget.product.image,
                    selected: true,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(selectedItems: [cartItem]),
                    ),
                  );
                },
                child: const Text("Beli Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
