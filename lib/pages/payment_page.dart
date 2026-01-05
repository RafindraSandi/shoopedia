import 'package:flutter/material.dart';
import '../keranjang_page.dart'; // For CartItem
import 'address_page.dart'; // For AddressPage
import '../address_manager.dart'; // For AddressManager
import 'pesanan_page.dart'; // For PesananPage
import '../order_manager.dart'; // For OrderManager

class PaymentPage extends StatefulWidget {
  final List<CartItem>? selectedItems;

  const PaymentPage({super.key, this.selectedItems});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const shopeeOrange = Color(0xFFEE4D2D);
  Address? selectedAddress;
  String selectedVoucher = "";
  String sellerMessage = "";
  String selectedShipping = "Reguler";
  bool useShopeediaPay = false;
  String selectedPaymentMethod =
      "cod"; // cod, transfer_bca, transfer_bri, transfer_bni, dana, gopay, shopeedia_pay
  bool useCoins = false;
  int shippingCost = 0;
  int shopeediaPayBalance = 1540000; // Rp 1.540.000
  int availableCoins = 2500;
  int coinsToUse = 0;

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
      backgroundColor: Colors.grey[100],
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
          GestureDetector(
            onTap: () => _showSellerMessageDialog(),
            child: _card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pesan untuk Penjual"),
                  Row(
                    children: [
                      Text(
                        sellerMessage.isEmpty
                            ? "Tinggalkan pesan"
                            : "Pesan tersimpan",
                        style: TextStyle(
                          color: sellerMessage.isEmpty
                              ? Colors.black54
                              : shopeeOrange,
                          fontWeight: sellerMessage.isEmpty
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _shippingSection(),
          const SizedBox(height: 10),
          _paymentMethodSection(),
          const SizedBox(height: 10),
          _coinRedemptionSection(),
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
      backgroundColor: Colors.white,
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
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Kelola Alamat",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: shopeeOrange,
                foregroundColor: Colors.white,
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
                        if (item.variant.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "Ukuran: ${item.variant}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
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
    return GestureDetector(
      onTap: () => _showVoucherSelection(),
      child: _card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Voucher Toko"),
            Row(
              children: [
                Text(
                  selectedVoucher.isEmpty
                      ? "Gunakan / masukkan kode"
                      : selectedVoucher,
                  style: TextStyle(
                    color:
                        selectedVoucher.isEmpty ? Colors.black54 : shopeeOrange,
                    fontWeight: selectedVoucher.isEmpty
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVoucherSelection() {
    final availableVouchers = [
      {
        "title": "Diskon 10%",
        "description": "Min. pembelian Rp50.000",
        "validity": "Berlaku sampai 31 Desember 2024",
        "icon": Icons.discount,
        "color": Colors.green
      },
      {
        "title": "Diskon 15%",
        "description": "Min. pembelian Rp100.000",
        "validity": "Berlaku sampai 31 Desember 2024",
        "icon": Icons.discount,
        "color": Colors.blue
      },
      {
        "title": "Gratis Ongkir",
        "description": "Min. pembelian Rp75.000",
        "validity": "Berlaku sampai 31 Desember 2024",
        "icon": Icons.local_shipping,
        "color": Colors.orange
      },
      {
        "title": "Cashback 5%",
        "description": "Min. pembelian Rp25.000",
        "validity": "Berlaku sampai 31 Desember 2024",
        "icon": Icons.account_balance_wallet,
        "color": Colors.purple
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pilih Voucher Toko",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableVouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = availableVouchers[index];
                    final voucherTitle = voucher['title'] as String;
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedVoucher = voucherTitle;
                          });
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Radio<String>(
                                value: voucherTitle,
                                groupValue: selectedVoucher,
                                onChanged: (value) {
                                  setState(() {
                                    selectedVoucher = value!;
                                  });
                                  Navigator.pop(context);
                                },
                                activeColor: shopeeOrange,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: voucher['color'] as Color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  voucher['icon'] as IconData,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      voucher['title'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      voucher['description'] as String,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      voucher['validity'] as String,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 10,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedVoucher = "";
                      });
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Hapus Voucher"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: shopeeOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Konfirmasi"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSellerMessageDialog() {
    final TextEditingController messageController =
        TextEditingController(text: sellerMessage);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Pesan untuk Penjual"),
        content: TextField(
          controller: messageController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Tinggalkan pesan untuk penjual...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                sellerMessage = messageController.text.trim();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: shopeeOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Widget _shippingSection() {
    return GestureDetector(
      onTap: () => _showShippingSelection(),
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Opsi Pengiriman",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedShipping,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getShippingDetails(selectedShipping),
                        style:
                            const TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getShippingDetails(String shippingType) {
    switch (shippingType) {
      case "Express":
        return "Rp15.000 • Estimasi 1-2 Hari";
      case "Reguler":
        return "Gratis Ongkir • Estimasi 3-5 Hari";
      case "Hemat":
        return "Rp5.000 • Estimasi 5-7 Hari";
      default:
        return "Gratis Ongkir • Estimasi 3-5 Hari";
    }
  }

  void _showShippingSelection() {
    final shippingOptions = [
      {"name": "Express", "cost": 15000, "eta": "1-2 Hari"},
      {"name": "Reguler", "cost": 0, "eta": "3-5 Hari"},
      {"name": "Hemat", "cost": 5000, "eta": "5-7 Hari"},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pilih Opsi Pengiriman",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: shippingOptions.length,
                itemBuilder: (context, index) {
                  final option = shippingOptions[index];
                  final name = option["name"] as String;
                  final cost = option["cost"] as int;
                  final eta = option["eta"] as String;

                  return RadioListTile<String>(
                    title: Text(name),
                    subtitle: Text(
                      cost == 0
                          ? "Gratis Ongkir • Estimasi $eta"
                          : "Rp${formatPrice(cost)} • Estimasi $eta",
                    ),
                    value: name,
                    groupValue: selectedShipping,
                    onChanged: (value) {
                      setState(() {
                        selectedShipping = value!;
                        shippingCost = cost;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodSection() {
    return GestureDetector(
      onTap: () => _showPaymentMethodSelection(),
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPaymentMethodName(selectedPaymentMethod),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if (selectedPaymentMethod == "shopeedia_pay")
                        Text(
                          "Saldo: Rp${formatPrice(shopeediaPayBalance)}",
                          style: const TextStyle(
                              color: Colors.green, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinRedemptionSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Koin Shopeedia",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(
                value: useCoins,
                onChanged: (value) {
                  setState(() {
                    useCoins = value;
                    if (value) {
                      coinsToUse = availableCoins;
                    } else {
                      coinsToUse = 0;
                    }
                  });
                },
                activeColor: shopeeOrange,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Koin tersedia: $availableCoins",
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                useCoins
                    ? "Koin digunakan: $coinsToUse"
                    : "Tidak menggunakan koin",
                style: TextStyle(
                  color: useCoins ? shopeeOrange : Colors.black54,
                  fontSize: 12,
                  fontWeight: useCoins ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (useCoins) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "1 koin = 1 rupiah",
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Sisa koin: ${availableCoins - coinsToUse}",
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _paymentDetailSection() {
    int finalTotal = totalAmount + shippingCost;
    int coinDiscount = useCoins ? coinsToUse * 1 : 0;
    int discountedTotal = finalTotal - coinDiscount;
    if (discountedTotal < 0) discountedTotal = 0;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rincian Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _priceRow("Total Produk", "Rp${formatPrice(totalAmount)}"),
          _priceRow("Total Ongkos Kirim", "Rp${formatPrice(shippingCost)}"),
          if (coinDiscount > 0)
            _priceRow("Diskon Koin", "-Rp${formatPrice(coinDiscount)}",
                isDiscount: true),
          const Divider(),
          _priceRow(
            "Total Pembayaran",
            "Rp${formatPrice(discountedTotal)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _bottomCheckoutBar() {
    int finalTotal = totalAmount + shippingCost;
    int coinDiscount = useCoins ? coinsToUse * 1 : 0;
    int discountedTotal = finalTotal - coinDiscount;
    if (discountedTotal < 0) discountedTotal = 0;

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
                "Rp${formatPrice(discountedTotal)}",
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
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              // Create order
              OrderManager.createOrder(
                selectedItems: widget.selectedItems!,
                address: selectedAddress?.fullAddress ?? 'Alamat tidak dipilih',
                paymentMethod: _getPaymentMethodName(selectedPaymentMethod),
              );

              // Navigate to PesananPage with Dikemas tab
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PesananPage(initialTab: 1)),
              );
            },
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

  Widget _priceRow(String label, String price,
      {bool isTotal = false, bool isDiscount = false}) {
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
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? shopeeOrange : Colors.black),
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

  // ================= PAYMENT METHODS =================

  String _getPaymentMethodName(String method) {
    switch (method) {
      case "cod":
        return "Bayar di Tempat (COD)";
      case "transfer_bca":
        return "Transfer Bank BCA";
      case "transfer_bri":
        return "Transfer Bank BRI";
      case "transfer_bni":
        return "Transfer Bank BNI";
      case "dana":
        return "DANA";
      case "gopay":
        return "GoPay";
      case "shopeedia_pay":
        return "ShopeediaPay";
      default:
        return "Bayar di Tempat (COD)";
    }
  }

  void _showPaymentMethodSelection() {
    final paymentMethods = [
      {
        "id": "cod",
        "name": "Bayar di Tempat (COD)",
        "icon": Icons.location_on,
        "color": Colors.blue,
        "description": "Bayar saat barang diterima"
      },
      {
        "id": "transfer_bca",
        "name": "Transfer Bank BCA",
        "icon": Icons.account_balance,
        "color": Colors.red,
        "description": "Transfer ke rekening BCA"
      },
      {
        "id": "transfer_bri",
        "name": "Transfer Bank BRI",
        "icon": Icons.account_balance,
        "color": Colors.blue.shade800,
        "description": "Transfer ke rekening BRI"
      },
      {
        "id": "transfer_bni",
        "name": "Transfer Bank BNI",
        "icon": Icons.account_balance,
        "color": Colors.blue.shade900,
        "description": "Transfer ke rekening BNI"
      },
      {
        "id": "dana",
        "name": "DANA",
        "icon": Icons.account_balance_wallet,
        "color": Colors.blue.shade600,
        "description": "Pembayaran via DANA"
      },
      {
        "id": "gopay",
        "name": "GoPay",
        "icon": Icons.account_balance_wallet,
        "color": Colors.green,
        "description": "Pembayaran via GoPay"
      },
      {
        "id": "shopeedia_pay",
        "name": "ShopeediaPay",
        "icon": Icons.payment,
        "color": shopeeOrange,
        "description": "Saldo: Rp${formatPrice(shopeediaPayBalance)}"
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = paymentMethods[index];
                    final methodId = method['id'] as String;
                    final methodName = method['name'] as String;
                    final methodIcon = method['icon'] as IconData;
                    final methodColor = method['color'] as Color;
                    final methodDesc = method['description'] as String;

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = methodId;
                          });
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio<String>(
                                value: methodId,
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value!;
                                  });
                                  Navigator.pop(context);
                                },
                                activeColor: shopeeOrange,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: methodColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  methodIcon,
                                  color: methodColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      methodName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      methodDesc,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: shopeeOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Konfirmasi"),
            ),
          ],
        ),
      ),
    );
  }
}
