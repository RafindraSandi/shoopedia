import 'package:flutter/material.dart';
import '../order_manager.dart';
import '../products_data.dart';
import '../keranjang_page.dart';
import '../cart_manager.dart'; // PENTING: Tambahkan ini
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.list_alt, size: 80, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            "Tidak ada pesanan $title",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
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

          const Divider(height: 1),

          // Produk-produk dalam order
          ...order.items.map((item) {
            return Column(
              children: [
                // Produk Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imagePath,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text("Variasi: ${item.variant}",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("x${item.quantity}"),
                                Text(
                                  formatPrice(item.price),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol Aksi Per Produk (Beli Lagi / Nilai)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildOrderButtons(order.status, item, order),
                  ),
                ),
                
                if (order.items.last != item) const Divider(),
              ],
            );
          }),

          // Info Total Order
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${order.items.length} Produk",
                    style: const TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    const Text("Total Pesanan: "),
                    Text(
                      formatPrice(order.totalPrice),
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // LOGIC TOMBOL
  // ===================================================================
  
  // FUNGSI BARU: Logic Beli Lagi
  void _buyAgain(CartItem item) {
    // 1. Buat item baru untuk keranjang
    final newItem = CartItem(
      shopName: item.shopName,
      title: item.title,
      price: item.price,
      quantity: 1, // Default beli 1
      variant: item.variant,
      imagePath: item.imagePath,
      stockLeft: 99,
      selected: true, // Langsung centang
    );

    // 2. Masukkan ke CartManager
    CartManager.addToCart(newItem);

    // 3. Info & Navigasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk dimasukkan ke Keranjang")),
    );
    
    // Opsional: Langsung pindah ke halaman keranjang
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const KeranjangPage())
    );
  }

  void _navigateToProductDetail(CartItem item) {
      // Find the corresponding product from Dummy Data
      final product = ProductsData.products.firstWhere(
        (p) => p.name == item.title,
        orElse: () => ProductsData.products[0], // fallback
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: product),
        ),
      );
  }

  void _cancelOrder(Order order) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Batalkan Pesanan"),
            content: const Text(
                "Apakah Anda yakin ingin membatalkan pesanan ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Tidak"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    OrderManager.orders.remove(order);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Pesanan berhasil dibatalkan")),
                  );
                },
                child: const Text("Ya, Batalkan"),
              ),
            ],
          );
        },
      );
  }

  // Rating Dialog
  void _showRatingDialog(CartItem item) {
    int selectedRating = 5;
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
                    Text(item.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < selectedRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () => setState(() => selectedRating = index + 1),
                        );
                      }),
                    ),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Tulis ulasan...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ulasan terkirim! Terima kasih.")),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  child: const Text("Kirim", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ===================================================================
  // Build Tombol Berdasarkan Status
  // ===================================================================
  List<Widget> _buildOrderButtons(String status, CartItem item, Order order) {
    switch (status) {
      case "Dikemas":
        return [
          // Tombol Hubungi Penjual (Opsional)
          OutlinedButton(
            onPressed: () => _navigateToProductDetail(item),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade400)),
            child: const Text("Lihat Produk"),
          ),
          const SizedBox(width: 8),
          // Tombol Batalkan
          OutlinedButton(
            onPressed: () => _cancelOrder(order),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade400)),
            child: const Text("Batalkan"),
          ),
        ];
        
      case "Dikirim":
        return [
          ElevatedButton(
            onPressed: () {
              // Simulasi Pesanan Diterima -> Pindah status ke Selesai
              setState(() {
                order.status = "Selesai";
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: const Text("Pesanan Diterima", style: TextStyle(color: Colors.white)),
          ),
        ];
        
      case "Selesai":
        return [
          // TOMBOL BELI LAGI (YANG SUDAH DIPERBAIKI)
          OutlinedButton(
            onPressed: () => _buyAgain(item), // Panggil fungsi _buyAgain
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: mainColor),
              foregroundColor: mainColor,
            ),
            child: const Text("Beli Lagi"),
          ),
          const SizedBox(width: 8),
          // Tombol Nilai
          ElevatedButton(
            onPressed: () => _showRatingDialog(item),
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: const Text("Nilai", style: TextStyle(color: Colors.white)),
          ),
        ];
        
      default:
        return [];
    }
  }

  String formatPrice(int price) {
    return "Rp${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
  }
}
