// keranjang_page.dart
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final Color mainColor = const Color(0xFFEE4D2D);
  final currency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  // contoh data keranjang
  List<CartItem> cartItems = [
    CartItem(
      shopName: "Saint Barkley Official",
      title: "St. Andrew Jersey White",
      price: 273600,
      quantity: 1,
      stockLeft: 3,
      variant: "XXL",
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHtRbMG12M-5bmUQ5OC6sBPNoreL4HDTi0GQ&s', // file upload local path
      selected: false,
    ),
    CartItem(
      shopName: "MILLS OFFICIAL Shop",
      title: "Mills Jersey USS Away",
      price: 274500,
      quantity: 1,
      stockLeft: 5,
      variant: "Black, XXL",
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYDgS_WeBSzaUTc4TWjIAbgvv3FaxloDDtvA&s', // another uploaded image fallback
      selected: false,
    ),
    CartItem(
      shopName: "MILLS OFFICIAL Shop",
      title: "MILLS COSMO JNE AWAY FUTSAL",
      price: 399000,
      quantity: 1,
      stockLeft: 3,
      variant: "WHITE, XXL",
      imagePath:
          'https://mills.co.id/cdn/shop/files/cosmo_jne_away_futsal_jersey_-_white_-_1470_20.png?v=1738381660', // network fallback
      selected: false,
    ),
  ];

  bool noProductSelected = false; // toggle "Tidak ada produk yang dipilih"
  bool get allSelected =>
      cartItems.isNotEmpty && cartItems.every((c) => c.selected);

  // helper: load local file or fallback to network placeholder
  Widget _imageFromPath(String path, {BoxFit fit = BoxFit.cover}) {
    try {
      if (path.startsWith('/') || path.startsWith('file://')) {
        final filePath = path.startsWith('file://')
            ? path.replaceFirst('file://', '')
            : path;
        final file = io.File(filePath);
        if (file.existsSync()) {
          return Image.file(file, fit: fit);
        } else {
          return Image.network(
              'https://via.placeholder.com/200x200?text=No+Image',
              fit: fit);
        }
      } else {
        return Image.network(path, fit: fit);
      }
    } catch (e) {
      return Image.network('https://via.placeholder.com/200x200?text=Error',
          fit: fit);
    }
  }

  // Hitung total harga item yang dipilih (digit-by-digit safe: sum programatik)
  int computeTotalSelected() {
    int total = 0;
    for (final item in cartItems) {
      if (item.selected && !noProductSelected) {
        // price * quantity
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  // Select / deselect all
  void _toggleSelectAll(bool? value) {
    final v = value ?? false;
    setState(() {
      for (var item in cartItems) {
        item.selected = v;
      }
    });
  }

  // Hapus produk yang dipilih
  void _removeSelected() {
    setState(() {
      cartItems.removeWhere((c) => c.selected);
    });
  }

  // Checkout action (simpel)
  void _checkout() {
    final selected = cartItems.where((c) => c.selected).toList();
    if (selected.isEmpty || noProductSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pilih produk terlebih dahulu")));
      return;
    }

    // Untuk demo: tunjukkan dialog ringkasan
    final total = computeTotalSelected();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Checkout"),
        content: Text(
            "Kamu akan checkout ${selected.length} produk.\nTotal: ${currency.format(total)}"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              // placeholder: hapus produk yang dibeli (untuk demo)
              setState(() {
                cartItems.removeWhere((c) => c.selected);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checkout berhasil (demo)")));
            },
            child: const Text("Bayar"),
          ),
        ],
      ),
    );
  }

  // Ubah kuantitas (min 1, max stockLeft)
  void _changeQuantity(int index, int delta) {
    setState(() {
      final item = cartItems[index];
      final newQty = item.quantity + delta;
      if (newQty >= 1 &&
          newQty <= (item.stockLeft > 0 ? item.stockLeft : 9999)) {
        item.quantity = newQty;
      }
    });
  }

  // Format harga setiap item ke string (Rp)
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
              style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ]),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.6,
        actions: [
          TextButton(
            onPressed:
                cartItems.any((c) => c.selected) ? _removeSelected : null,
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
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
                        const Icon(Icons.shopping_cart_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text("Keranjang kosong",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed:
                              () {}, // kembali ke halaman beranda atau belanja
                          child: const Text("Belanja Sekarang"),
                        )
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount:
                        cartItems.length + 1, // +1 untuk voucher / info area
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // area voucher + toggle
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.confirmation_num_outlined,
                                      color: Colors.orange),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                      child: Text("Voucher",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  TextButton(
                                    onPressed: () {
                                      // placeholder: buka dialog/method untuk masukkan kode
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("Voucher"),
                                          content: const Text(
                                              "Fitur voucher demo (implementasikan sesuai backend)"),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Tutup"))
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text("Gunakan/masukkan kode"),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Tidak ada produk yang dipilih"),
                                  Switch(
                                    value: noProductSelected,
                                    onChanged: (v) {
                                      setState(() {
                                        noProductSelected = v;
                                        if (v) {
                                          // jika toggle on, unselect semua agar total 0
                                          for (var c in cartItems) {
                                            c.selected = false;
                                          }
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }

                      final item = cartItems[index - 1];
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
                                // checkbox
                                Checkbox(
                                  value: item.selected && !noProductSelected,
                                  onChanged: noProductSelected
                                      ? null
                                      : (v) {
                                          setState(() {
                                            item.selected = v ?? false;
                                          });
                                        },
                                ),
                                const SizedBox(width: 6),
                                // image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 86,
                                    height: 86,
                                    child: _imageFromPath(item.imagePath,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // shop name + Ubah
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.orange.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: const Text("Star",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Text(item.shopName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          TextButton(
                                            onPressed: () {
                                              // placeholder: action Ubah / ganti varian
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (_) => SizedBox(
                                                  height: 220,
                                                  child: Center(
                                                      child: Text(
                                                          "Ubah varian (${item.title}) - implement UI di sini")),
                                                ),
                                              );
                                            },
                                            child: const Text("Ubah"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(item.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 6),
                                      // variant row + stock badge
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(item.variant,
                                                style: const TextStyle(
                                                    fontSize: 13)),
                                          ),
                                          const SizedBox(width: 8),
                                          if (item.stockLeft >= 0)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Text(
                                                  "Tersisa ${item.stockLeft}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54)),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // price + qty controls
                            Row(
                              children: [
                                // price
                                Text(_formatPrice(item.price),
                                    style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                // qty controls
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            _changeQuantity(index - 1, -1),
                                        icon:
                                            const Icon(Icons.remove, size: 18),
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      Text(item.quantity.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                        onPressed: () =>
                                            _changeQuantity(index - 1, 1),
                                        icon: const Icon(Icons.add, size: 18),
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // remove single item
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      cartItems.removeAt(index - 1);
                                    });
                                  },
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // bottom sticky area (select all + total + checkout)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Checkbox(
                  value: allSelected && !noProductSelected,
                  onChanged: noProductSelected ? null : _toggleSelectAll,
                ),
                const SizedBox(width: 6),
                const Text("Semua"),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currency.format(total),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        "${cartItems.where((c) => c.selected).fold<int>(0, (prev, e) => prev + e.quantity)} item dipilih",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 140,
                  height: 44,
                  child: ElevatedButton(
                    onPressed:
                        (total > 0 && !noProductSelected) ? _checkout : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (total > 0 && !noProductSelected)
                          ? mainColor
                          : Colors.grey.shade400,
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
        ],
      ),
    );
  }
}

// Model sederhana untuk item cart
class CartItem {
  String shopName;
  String title;
  int price; // dalam IDR (integer)
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
