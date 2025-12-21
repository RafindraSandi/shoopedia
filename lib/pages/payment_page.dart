import 'package:flutter/material.dart';
import '../keranjang_page.dart';   // Mundur satu folder
import '../address_manager.dart';   // Mundur satu folder
import 'address_page.dart';         // Sesama folder pages/

class PaymentPage extends StatefulWidget {
  final List<CartItem>? selectedItems;

  const PaymentPage({super.key, this.selectedItems});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const shopeeOrange = Color(0xFFEE4D2D);
  Address? selectedAddress;
  String _selectedPaymentMethod = "ShoopediaPay";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (AddressManager.addresses.isNotEmpty) {
      selectedAddress = AddressManager.primaryAddress;
    }
  }

  int get totalAmount {
    if (widget.selectedItems == null) return 0;
    return widget.selectedItems!
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  void _handleBuatPesanan() {
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon pilih alamat pengiriman")),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("Pembayaran Berhasil!"),
            ],
          ),
          content: const Text(
            "Pesanan Anda sedang diproses. Terima kasih!",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Keluar page
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _addressSection(),
              const SizedBox(height: 10),
              _productSection(),
              const SizedBox(height: 10),
              _paymentDetailSection(),
              const SizedBox(height: 100),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator(color: shopeeOrange)),
            ),
        ],
      ),
      bottomNavigationBar: _bottomCheckoutBar(),
    );
  }

  // --- WIDGETS ---
  
  Widget _addressSection() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressPage()));
        setState(() {
          if (AddressManager.addresses.isNotEmpty) {
            selectedAddress = AddressManager.primaryAddress;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            const Icon(Icons.location_on, color: shopeeOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAddress != null
                        ? "${selectedAddress!.fullName} | ${selectedAddress!.phoneNumber}"
                        : "Pilih Alamat Pengiriman",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (selectedAddress != null)
                    Text(selectedAddress!.fullAddress, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _productSection() {
    if (widget.selectedItems == null || widget.selectedItems!.isEmpty) return const SizedBox();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: widget.selectedItems!.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Image.network(item.imagePath, width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => const Icon(Icons.image, size: 60)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text("Variasi: ${item.variant}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rp${formatPrice(item.price)}"),
                          Text("x${item.quantity}"),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _paymentDetailSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rincian Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Subtotal Produk"),
            Text("Rp${formatPrice(totalAmount)}"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Biaya Layanan"),
            const Text("Rp1.000"),
          ]),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Rp${formatPrice(totalAmount + 1000)}", style: const TextStyle(color: shopeeOrange, fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ],
      ),
    );
  }

  Widget _bottomCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Total Pembayaran"),
              Text("Rp${formatPrice(totalAmount + 1000)}", style: const TextStyle(color: shopeeOrange, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleBuatPesanan,
            style: ElevatedButton.styleFrom(backgroundColor: shopeeOrange),
            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Buat Pesanan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
