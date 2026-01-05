import 'dart:io' as io;
import 'package:flutter/material.dart';
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

  String _calculateDiscountedPrice(String originalPrice, String discount) {
    // Parse original price (remove 'Rp' and '.')
    final priceString = originalPrice.replaceAll('Rp', '').replaceAll('.', '');
    final price = int.parse(priceString);

    // Parse discount percentage (remove '%')
    final discountPercent = double.parse(discount.replaceAll('%', ''));

    // Calculate discounted price
    final discountAmount = price * (discountPercent / 100);
    final discountedPrice = price - discountAmount.toInt();

    // Format back to 'Rp xxx.xxx'
    final formattedPrice = discountedPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'Rp $formattedPrice';
  }

  // Get the current product from shared data to ensure we have the latest reviews
  Product get currentProduct {
    return ProductsData.products.firstWhere(
      (p) => p.name == widget.product.name && p.image == widget.product.image,
      orElse: () => ProductsData.products.firstWhere(
        (p) => p.name == widget.product.name,
        orElse: () => widget.product, // fallback to widget.product
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Detail Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share product functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur share akan segera hadir')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              WishlistManager.isInWishlist(widget.product.name)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: WishlistManager.isInWishlist(widget.product.name)
                  ? Colors.red
                  : null,
            ),
            onPressed: () {
              setState(() {
                if (WishlistManager.isInWishlist(widget.product.name)) {
                  WishlistManager.removeFromWishlist(widget.product.name);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dihapus dari wishlist')),
                  );
                } else {
                  WishlistManager.addToWishlist(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ditambahkan ke wishlist')),
                  );
                }
              });
            },
          ),
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
            buildImageWidget(
              widget.product.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 12),

            // Harga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: widget.product.discount != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.price,
                          style: const TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _calculateDiscountedPrice(
                              widget.product.price, widget.product.discount!),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  : Text(
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

            // Nama Toko
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.store, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    widget.product.storeName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
                    backgroundColor: Colors.grey[200],
                    selectedColor: Colors.red,
                    labelStyle: TextStyle(
                      color: selectedSize == size ? Colors.white : Colors.black,
                    ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Rating Keseluruhan: ",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              double averageRating =
                                  currentProduct.reviews.isNotEmpty
                                      ? currentProduct.reviews
                                              .map((r) => r.rating)
                                              .reduce((a, b) => a + b) /
                                          currentProduct.reviews.length
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
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentProduct.reviews.isNotEmpty
                            ? "${(currentProduct.reviews.map((r) => r.rating).reduce((a, b) => a + b) / currentProduct.reviews.length).toStringAsFixed(1)} (${currentProduct.reviews.length} ulasan)"
                            : "Belum ada ulasan",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Individual Reviews
                  ...currentProduct.reviews.map((review) => Container(
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
                                  review.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                      5,
                                      (index) => Icon(
                                            index < review.rating
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
                              review.comment,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review.date,
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
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text("Keranjang"),
                    onPressed: selectedSize.isEmpty
                        ? null
                        : () {
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
                              variant: selectedSize,
                              imagePath: widget.product.image,
                              selected: false,
                            );

                            CartManager.addToCart(cartItem);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Produk ditambahkan ke keranjang')),
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
                      foregroundColor: Colors.white,
                    ),
                    onPressed: selectedSize.isEmpty
                        ? null
                        : () {
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
                              variant: selectedSize,
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
