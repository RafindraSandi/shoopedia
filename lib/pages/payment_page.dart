import 'package:flutter/material.dart';
import '../keranjang_page.dart'; // For CartItem
import 'address_page.dart'; // For AddressPage
import '../address_manager.dart'; // For AddressManager

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

  @override
  void initState() {
    super.initState();
    selectedAddress = AddressManager.primaryAddress;
  }

  int get totalAmount {
    if (widget.selectedItems == null) return 0;
    return widget.selectedItems!
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _addressSection(),
          const SizedBox(height: 10),
          _productSection(),
          const SizedBox(height: 10),
          _voucherSection(),
          _simpleTile("Pesan untuk Penjual", "Tinggalkan pesan"),
          _shippingSection(),
          const SizedBox(height: 10),
          _paymentMethodSection(),
          const SizedBox(height: 10),
          _paymentDetailSection(),
          const SizedBox(height: 90),
        ],
      ),
      bottomNavigationBar: _bottomCheckoutBar(),
    );
  }

  // ================= SECTIONS =================

  Widget _addressSection() {
    return GestureDetector(
      onTap: () => _showAddressSelection(),
      child: _card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: Color(0xFFEE4D2D)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAddress != null
                        ? "${selectedAddress!.fullName} (+62) ${selectedAddress!.phoneNumber}"
                        : "Pilih Alamat Pengiriman",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedAddress?.fullAddress ??
                        "Belum ada alamat yang dipilih",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  void _showAddressSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pilih Alamat Pengiriman",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (AddressManager.addresses.isEmpty)
              const Text("Belum ada alamat tersimpan")
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AddressManager.addresses.length,
                  itemBuilder: (context, index) {
                    final address = AddressManager.addresses[index];
                    return RadioListTile<Address>(
                      title: Text(address.fullName),
                      subtitle: Text(address.fullAddress),
                      value: address,
                      groupValue: selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = value;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context); // Close the selection sheet
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddressPage()),
                );
                setState(() {
                  selectedAddress = AddressManager.primaryAddress;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Kelola Alamat"),
              style: ElevatedButton.styleFrom(
                backgroundColor: shopeeOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productSection() {
    if (widget.selectedItems == null || widget.selectedItems!.isEmpty) {
      return _card(
        child: const Center(
          child: Text("Tidak ada produk yang dipilih"),
        ),
      );
    }
    return _card(
      child: Column(
        children: widget.selectedItems!.map((item) {
          return Column(
            children: [
              Row(
                children: [
                  Text(
                    item.shopName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: item.imagePath.startsWith('http')
                            ? NetworkImage(item.imagePath)
                            : AssetImage(item.imagePath) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rp${formatPrice(item.price)}",
                          style: const TextStyle(
                            color: shopeeOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text("x${item.quantity}"),
                ],
              ),
              if (widget.selectedItems!.last != item) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _voucherSection() {
    return _simpleTile("Voucher Toko", "Gunakan / masukkan kode");
  }

  Widget _shippingSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Opsi Pengiriman",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text("Reguler"),
          SizedBox(height: 4),
          Text(
            "Gratis Ongkir • Estimasi 18-20 Des",
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodSection() {
    return GestureDetector(
      onTap: () => _showPaymentMethodPicker(),
      child: _card(
        child: Column(
          children: [
          const Text(
            "Metode Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                  _selectedPaymentMethod, 
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  // =================================================================
  // 🔥 FUNGSI BARU 1: POPUP METODE PEMBAYARAN
  // =================================================================
  void _showPaymentMethodPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              // ... Pilihan ShopeePay ...
              ListTile(
                title: const Text("Transfer Bank (Virtual Account)"),
                onTap: () {
                  Navigator.pop(context); 
                  _showBankSelectionPicker(); // Lanjut ke pilih bank
                },
              ),
              // ... Pilihan COD ...
            ],
          ),
        );
      },
    );
  }

  // =================================================================
  // 🔥 FUNGSI BARU 2: POPUP PILIH BANK
  // =================================================================
  void _showBankSelectionPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              _bankOption("Bank BCA", "BCA"),
              _bankOption("Bank Mandiri", "Mandiri"),
              _bankOption("Bank BNI", "BNI"),
              _bankOption("Bank BRI", "BRI"),
            ],
          ),
        );
      },
    );
  }

  // Helper kecil untuk membuat list bank
  Widget _bankOption(String bankName, String shortName) {
    return ListTile(
      title: Text(bankName),
      onTap: () {
        setState(() {
          _selectedPaymentMethod = "Transfer Bank - $shortName";
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _paymentDetailSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rincian Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _priceRow("Total Produk", "Rp${totalAmount}"),
          _priceRow("Total Ongkos Kirim", "Rp0"),
          const Divider(),
          _priceRow(
            "Total Pembayaran",
            "Rp${totalAmount}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _bottomCheckoutBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Total Pembayaran"),
              Text(
                "Rp${formatPrice(totalAmount)}",
                style: const TextStyle(
                  color: shopeeOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: shopeeOrange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {},
            child: const Text("Buat Pesanan"),
          ),
        ],
      ),
    );
  }

  // ================= REUSABLE =================

  Widget _simpleTile(String title, String subtitle) {
    return _card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Row(
            children: [
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String price, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            price,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? shopeeOrange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

