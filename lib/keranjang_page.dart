import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cart_manager.dart';
import 'pages/voucher_page.dart';
import 'pages/payment_page.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final Color mainColor = const Color(0xFFEE4D2D);
  final currency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    // Load data dari Manager
    cartItems = List.from(CartManager.cartItems);
  }

  // FIX: Hapus logic "Switch No Product Selected", ganti pakai getter dynamic
  bool get isAnySelected => cartItems.any((c) => c.selected);
  bool get allSelected =>
      cartItems.isNotEmpty && cartItems.every((c) => c.selected);

  // Helper image (Gue rapihin dikit)
  Widget _imageFromPath(String path, {BoxFit fit = BoxFit.cover}) {
    if (path.isEmpty) {
       return Image.network('https://via.placeholder.com/200?text=No+Img', fit: fit);
    }
    try {
      if (path.startsWith('http')) {
        return Image.network(path, fit: fit);
      } else {
        // Handle file path (bersihin prefix file:// jika ada)
        final cleanPath = path.replaceFirst('file://', '');
        final file = io.File(cleanPath);
        if (file.existsSync()) {
          return Image.file(file, fit: fit);
        }
      }
    } catch (e) {
      debugPrint("Error loading image: $e");
    }
    return Image.network('https://via.placeholder.com/200?text=Error', fit: fit);
  }

  int computeTotalSelected() {
    int total = 0;
    for (final item in cartItems) {
      if (item.selected) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  void _toggleSelectAll(bool? value) {
    final v = value ?? false;
    setState(() {
      for (var item in cartItems) {
        item.selected = v;
      }
    });
  }

  // UPDATE: Tambah konfirmasi sebelum hapus
  void _confirmRemoveSelected() {
    if (!isAnySelected) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: const Text("Produk yang dipilih akan dihapus dari keranjang."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _removeSelected(); // Action hapus beneran
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _removeSelected() {
    setState(() {
      cartItems.removeWhere((c) => c.selected);
      _syncToManager(); // Sync balik ke global manager
    });
  }

  void _checkout() {
    final selected = cartItems.where((c) => c.selected).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pilih produk terlebih dahulu")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(selectedItems: selected),
      ),
    );
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      final item = cartItems[index];
      final newQty = item.quantity + delta;
      
      // Cek stok dan minimal 1
      int maxStock = item.stockLeft > 0 ? item.stockLeft : 9999;
      
      if (newQty >= 1 && newQty <= maxStock) {
        item.quantity = newQty;
        _syncToManager(); // FIX: Jangan lupa sync perubahan qty ke Manager
      } else if (newQty > maxStock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Stok hanya tersedia $maxStock"), duration: const Duration(seconds: 1)),
        );
      }
    });
  }

  // Fungsi helper buat sync ke CartManager
  void _syncToManager() {
    CartManager.cartItems.clear();
    CartManager.cartItems.addAll(cartItems);
  }

  String _formatPrice(int price) => currency.format(price);

  @override
  Widget build(BuildContext context) {
    final total = computeTotalSelected();
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(children: [
          const Text("Keranjang Saya"),
          const SizedBox(width: 8),
          Text("(${cartItems.length})",
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ]),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: isAnySelected ? _confirmRemoveSelected : null,
            child: Text("Hapus", 
              style: TextStyle(color: isAnySelected ? Colors.red : Colors.grey)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        const SizedBox(height: 12),
                        const Text("Keranjang kosong",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                          onPressed: () {
                             // Navigator.pop(context); // Atau arahkan ke Home
                          }, 
                          child: const Text("Belanja Sekarang"),
                        )
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    // ItemCount + 1 untuk header voucher
                    itemCount: cartItems.length + 1, 
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      // HEADER VOUCHER (Index 0)
                      if (index == 0) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(Icons.confirmation_num_outlined,
                                  color: Colors.orange),
                              const SizedBox(width: 10),
                              const Expanded(
                                  child: Text("Voucher Shoopedia",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VoucherPage()),
                                  );
                                },
                                child: const Text("Pilih Voucher"),
                              ),
                            ],
                          ),
                        );
                      }

                      // ITEM LIST (Index > 0)
                      final itemIndex = index - 1;
                      final item = cartItems[itemIndex];
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Checkbox
                                Checkbox(
                                  activeColor: mainColor,
                                  value: item.selected,
                                  onChanged: (v) {
                                    setState(() {
                                      item.selected = v ?? false;
                                    });
                                  },
                                ),
                                
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: _imageFromPath(item.imagePath),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                
                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 15)),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(4)),
                                        child: Text("Varian: ${item.variant}", 
                                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(_formatPrice(item.price),
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            // Qty Control (Baris bawah)
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                                  onPressed: () {
                                    // Hapus single item
                                    setState(() {
                                       cartItems.removeAt(itemIndex);
                                       _syncToManager();
                                    });
                                  },
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => _changeQuantity(itemIndex, -1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Icon(Icons.remove, size: 16),
                                        ),
                                      ),
                                      Text("${item.quantity}", 
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      InkWell(
                                        onTap: () => _changeQuantity(itemIndex, 1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Icon(Icons.add, size: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          
          // BOTTOM STICKY BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1),
                  blurRadius: 10
                )
              ]
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Checkbox(
                    activeColor: mainColor,
                    value: allSelected,
                    onChanged: (cartItems.isEmpty) ? null : _toggleSelectAll,
                  ),
                  const Text("Semua"),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Total", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        currency.format(total),
                        style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: (total > 0) ? _checkout : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                          "Checkout (${cartItems.where((c) => c.selected).length})"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE:
// Class 'CartItem' HARUSNYA ada di file 'cart_manager.dart'.
// Kalau file cart_manager.dart belum ada modelnya, baru boleh pakai class di bawah ini.
// Kalau sudah ada, HAPUS code di bawah ini biar gak error.

/*
class CartItem {
  String shopName;
  String title;
  int price;
  int quantity;
  int stockLeft;
  String variant;
  String imagePath;
  bool selected;

  CartItem({
    required this.shopName,
    required this.title,
    required this.price,
    this.quantity = 1,
    this.stockLeft = 9999,
    this.variant = '',
    this.imagePath = '',
    this.selected = false,
  });
}
*/
