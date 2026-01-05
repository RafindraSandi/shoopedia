import 'package:flutter/material.dart';
import '../order_manager.dart';
import '../products_data.dart';
import '../keranjang_page.dart';
import 'product_detail_page.dart';
import 'models/product.dart';

class PesananPage extends StatefulWidget {
  final int initialTab;
  const PesananPage({super.key, this.initialTab = 0});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage>
    with SingleTickerProviderStateMixin {
  final Color mainColor = const Color(0xFFEE4D2D);

  late TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: widget.initialTab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Dikemas"),
            Tab(text: "Dikirim"),
            Tab(text: "Selesai"),
            Tab(text: "Pengembalian"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList("Dikemas"),
          buildOrderList("Dikirim"),
          buildOrderList("Selesai"),
          buildOrderList("Pengembalian"),
        ],
      ),
    );
  }

  // ===================================================================
  // Tab Kosong
  // ===================================================================
  Widget buildEmptyTab(String title) {
    return Center(
      child: Text(
        "Tidak ada pesanan $title",
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // ===================================================================
  // List Pesanan
  // ===================================================================
  Widget buildOrderList(String status) {
    final orders = OrderManager.getOrdersByStatus(status);

    if (orders.isEmpty) {
      return buildEmptyTab(status);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: orderCardFromOrder(order),
        );
      },
    );
  }

  // ===================================================================
  // Kartu Pesanan
  // ===================================================================
  Widget orderCard({
    required String toko,
    required String status,
    required String gambar,
    required String nama,
    required String total,
    required int qty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          // Header toko
          ListTile(
            leading: const Icon(Icons.store, color: Colors.red),
            title:
                Text(toko, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(
              status,
              style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
            ),
          ),

          // Produk
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    gambar,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("x$qty"),
              ],
            ),
          ),

          const Divider(),

          // Total harga
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total $qty produk: $total",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Tombol
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _buildOrderButtons(status),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // Kartu Pesanan dari Order
  // ===================================================================
  Widget orderCardFromOrder(Order order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          // Header order
          ListTile(
            leading: const Icon(Icons.store, color: Colors.red),
            title: Text(
              "Order #${order.id}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              order.status,
              style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
            ),
          ),

          // Produk-produk dalam order dengan total dan tombol per produk
          ...order.items.map((item) {
            return Column(
              children: [
                // Produk
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imagePath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("x${item.quantity}"),
                    ],
                  ),
                ),

                // Total harga per produk
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: ${formatPrice(item.price * item.quantity)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Tombol per produk
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    mainAxisAlignment: order.status == "Selesai"
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.end,
                    children: _buildOrderButtons(order.status, item, order),
                  ),
                ),

                if (order.items.last != item) const Divider(),
              ],
            );
          }),

          // Return status for Pengembalian (di bawah semua produk)
          if (order.status == "Pengembalian" && order.returnStatus != null) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Status Pengembalian",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    order.returnStatus!,
                    style: TextStyle(
                      color: order.returnStatus == "Sukses"
                          ? Colors.green
                          : mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===================================================================
  // Show Rating Dialog
  // ===================================================================
  void _showRatingDialog(CartItem item) {
    int selectedRating = 0;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Beri Penilaian"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product info
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Star rating
                    const Text("Rating:",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Comment field
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Tulis ulasan Anda (opsional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: selectedRating > 0
                      ? () {
                          // Find the corresponding product index
                          final productIndex = ProductsData.products.indexWhere(
                            (p) =>
                                p.name == item.title &&
                                p.image == item.imagePath,
                          );

                          if (productIndex == -1) {
                            // Fallback search by name only
                            final fallbackIndex =
                                ProductsData.products.indexWhere(
                              (p) => p.name == item.title,
                            );
                            if (fallbackIndex == -1) {
                              // If still not found, use first product as fallback
                              final fallbackProduct = ProductsData.products[0];
                              final updatedProduct =
                                  fallbackProduct.addReview(Review(
                                name: "Pengguna",
                                rating: selectedRating,
                                comment: commentController.text.trim().isEmpty
                                    ? "Produk bagus!"
                                    : commentController.text.trim(),
                                date: DateTime.now().toString().split(' ')[0],
                              ));
                              ProductsData.products[0] = updatedProduct;
                            } else {
                              final product =
                                  ProductsData.products[fallbackIndex];
                              final updatedProduct = product.addReview(Review(
                                name: "Pengguna",
                                rating: selectedRating,
                                comment: commentController.text.trim().isEmpty
                                    ? "Produk bagus!"
                                    : commentController.text.trim(),
                                date: DateTime.now().toString().split(' ')[0],
                              ));
                              ProductsData.products[fallbackIndex] =
                                  updatedProduct;
                            }
                          } else {
                            final product = ProductsData.products[productIndex];
                            final updatedProduct = product.addReview(Review(
                              name: "Pengguna",
                              rating: selectedRating,
                              comment: commentController.text.trim().isEmpty
                                  ? "Produk bagus!"
                                  : commentController.text.trim(),
                              date: DateTime.now().toString().split(' ')[0],
                            ));
                            ProductsData.products[productIndex] =
                                updatedProduct;
                          }

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Terima kasih atas penilaian Anda!")),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE4D2D),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Kirim"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ===================================================================
  // Build Order Buttons
  // ===================================================================
  List<Widget> _buildOrderButtons(String status,
      [CartItem? item, Order? order]) {
    void _navigateToProductDetail() {
      if (item != null) {
        // Find the corresponding product
        final product = ProductsData.products.firstWhere(
          (p) => p.name == item.title && p.image == item.imagePath,
          orElse: () => ProductsData.products.firstWhere(
            (p) => p.name == item.title,
            orElse: () => ProductsData.products[0], // fallback
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      }
    }

    void _cancelOrder() {
      if (order != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Batalkan Pesanan"),
              content: const Text(
                  "Apakah Anda yakin ingin membatalkan pesanan ini?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text("Tidak"),
                ),
                TextButton(
                  onPressed: () {
                    // Remove the order from the list
                    setState(() {
                      OrderManager.orders.remove(order);
                    });
                    Navigator.of(context).pop(); // Close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Pesanan berhasil dibatalkan")),
                    );
                  },
                  child: const Text("Ya"),
                ),
              ],
            );
          },
        );
      }
    }

    switch (status) {
      case "Dikemas":
        return [
          OutlinedButton(
            onPressed: _navigateToProductDetail,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text("Beli Lagi"),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: _cancelOrder,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text("Batalkan Pesanan"),
          ),
        ];
      case "Dikirim":
        return [
          OutlinedButton(
            onPressed: _navigateToProductDetail,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text("Beli Lagi"),
          ),
        ];
      case "Selesai":
        return [
          OutlinedButton(
            onPressed: _navigateToProductDetail,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text("Beli Lagi"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (item != null) {
                _showRatingDialog(item);
              }
            },
            child: const Text("Nilai"),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text("Pengembalian"),
          ),
        ];
      case "Pengembalian":
        return []; // No buttons for Pengembalian
      default:
        return [
          OutlinedButton(
            onPressed: _navigateToProductDetail,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text("Beli Lagi"),
          ),
        ];
    }
  }

  // ===================================================================
  // Helper Methods
  // ===================================================================
  String formatPrice(int price) {
    return "Rp${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
  }
}
