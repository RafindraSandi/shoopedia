import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/product.dart';
import '../keranjang_page.dart';
import '../cart_manager.dart';
import '../wishlist_manager.dart';
import 'payment_page.dart';
import 'chat_detail_page.dart';
import '../products_data.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "";

  // Formatter Rupiah
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  // Helper Gambar
  Widget buildImageWidget(String url,
      {BoxFit fit = BoxFit.cover, double? width, double? height}) {
    try {
      if (url.startsWith('http')) {
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
        'https://via.placeholder.com/300?text=Error',
        fit: fit,
        width: width,
        height: height,
      );
    }
  }

  // UPDATE: Hitung harga diskon pakai Integer
  int _calculateDiscountedPriceInt(int originalPrice, int discountPercent) {
    double discountAmount = originalPrice * (discountPercent / 100);
    return originalPrice - discountAmount.toInt();
  }

  // Ambil data terbaru (untuk sinkronisasi review jika ada update)
  Product get currentProduct {
    return ProductsData.products.firstWhere(
      (p) => p.name == widget.product.name,
      orElse: () => widget.product,
    );
  }

  // Logic Tambah ke Cart (Bisa dipakai tombol keranjang & beli sekarang)
  void _processAddToCart({bool isDirectBuy = false}) {
    // 1. Validasi Ukuran
    if (widget.product.sizes.isNotEmpty && selectedSize.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih ukuran terlebih dahulu!')),
      );
      return;
    }

    // 2. Buat Object CartItem
    // UPDATE: Tidak perlu parsing int karena product.price sudah int
    final cartItem = CartItem(
      shopName: widget.product.storeName, // Pakai nama toko asli
      title: widget.product.name,
      price: widget.product.price, 
      quantity: 1,
      stockLeft: 10, // Default stock dummy
      variant: selectedSize.isEmpty ? "Standard" : selectedSize,
      imagePath: widget.product.image,
      selected: isDirectBuy, // Kalau beli langsung, otomatis dicentang
    );

    // 3. Masukkan ke Manager
    CartManager.addToCart(cartItem);

    if (isDirectBuy) {
      // Direct Buy -> Payment Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(selectedItems: [cartItem]),
        ),
      );
    } else {
      // Add Cart -> Feedback & Navigate
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil masuk keranjang')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KeranjangPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = widget.product.discount > 0;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Detail Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link produk disalin!')),
              );
            },
          ),
          // TOMBOL WISHLIST (Menggunakan Manager)
          IconButton(
            icon: Icon(
              WishlistManager.isInWishlist(widget.product)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: WishlistManager.isInWishlist(widget.product)
                  ? Colors.red
                  : null,
            ),
            onPressed: () {
              setState(() {
                WishlistManager.toggleWishlist(widget.product);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(WishlistManager.isInWishlist(widget.product)
                      ? 'Ditambahkan ke Favorit'
                      : 'Dihapus dari Favorit'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const KeranjangPage()));
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
            buildImageWidget(
              widget.product.image,
              width: double.infinity,
              height: 350, // Sedikit lebih tinggi biar bagus
              fit: BoxFit.cover,
            ),

            // Harga & Diskon
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasDiscount) ...[
                    Text(
                      currencyFormatter.format(widget.product.price),
                      style: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          currencyFormatter.format(_calculateDiscountedPriceInt(
                              widget.product.price, widget.product.discount)),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEE4D2D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(2)
                          ),
                          child: Text(
                            "-${widget.product.discount}%",
                            style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ] else
                    Text(
                      currencyFormatter.format(widget.product.price),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEE4D2D),
                      ),
                    ),

                  const SizedBox(height: 10),
                  
                  // Nama Produk
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Rating & Terjual
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text("4.8", style: TextStyle(color: Colors.grey[800])),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 14, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(widget.product.sold,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            // Pilih Ukuran
            if (widget.product.sizes.isNotEmpty)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pilih Variasi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: widget.product.sizes.map((size) {
                        return ChoiceChip(
                          label: Text(size),
                          selected: selectedSize == size,
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                              color: selectedSize == size 
                                  ? const Color(0xFFEE4D2D) 
                                  : Colors.grey[300]!
                            )
                          ),
                          labelStyle: TextStyle(
                            color: selectedSize == size 
                                ? const Color(0xFFEE4D2D) 
                                : Colors.black,
                          ),
                          checkmarkColor: const Color(0xFFEE4D2D),
                          onSelected: (_) {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // Informasi Toko
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.store, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.storeName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text("Online 5 menit lalu",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEE4D2D)),
                    ),
                    child: const Text("Kunjungi Toko",
                        style: TextStyle(color: Color(0xFFEE4D2D))),
                  )
                ],
              ),
            ),

            // Deskripsi
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Deskripsi Produk",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Text(widget.product.description,
                      style: const TextStyle(height: 1.5)),
                ],
              ),
            ),

            // Penilaian Produk
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 80), // Margin bawah biar gak ketutup tombol
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Penilaian Produk",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  
                  if (currentProduct.reviews.isEmpty)
                    const Text("Belum ada penilaian.", style: TextStyle(color: Colors.grey))
                  else
                    ...currentProduct.reviews.map((review) => Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, size: 20, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(review.name, style: const TextStyle(fontSize: 13)),
                                  Row(
                                    children: List.generate(5, (index) => Icon(
                                      index < review.rating ? Icons.star : Icons.star_border,
                                      color: Colors.amber, size: 14
                                    )),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(review.comment, style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text(review.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                      ],
                    )),
                ],
              ),
            ),
          ],
        ),
      ),

      // ===== BOTTOM BAR =====
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ],
        ),
        child: Row(
          children: [
            // Tombol Chat
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                        shopName: widget.product.storeName,
                        avatarUrl: widget.product.image,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.chat_bubble_outline, color: Color(0xFFEE4D2D)),
                    Text("Chat", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            Container(width: 1, color: Colors.grey[300], margin: const EdgeInsets.symmetric(vertical: 10)),
            
            // Tombol Keranjang (Add)
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () => _processAddToCart(isDirectBuy: false),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_shopping_cart, color: Color(0xFFEE4D2D)),
                    Text("Keranjang", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            
            // Tombol Beli (Merah Full)
            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFFEE4D2D),
                child: InkWell(
                  onTap: () => _processAddToCart(isDirectBuy: true),
                  child: const Center(
                    child: Text(
                      "Beli Sekarang",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
