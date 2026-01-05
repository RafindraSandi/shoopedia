import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'coin_page.dart';

class ShopeediaPayPage extends StatefulWidget {
  const ShopeediaPayPage({super.key});

  @override
  State<ShopeediaPayPage> createState() => _ShopeediaPayPageState();
}

class _ShopeediaPayPageState extends State<ShopeediaPayPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // Handle the captured image here
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil diambil')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka kamera')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Warna oranye khas ShopeePay
    const Color payColor = Color(0xFFEE4D2D);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("ShopeediaPay",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: payColor,
        foregroundColor: Colors.white, // Warna teks/ikon putih
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // BAGIAN 1: HEADER SALDO & MENU UTAMA
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: payColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Tampilan Saldo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Colors.white, size: 30),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Saldo Kamu",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12)),
                        const Text("Rp 1.540.000",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Menu Aksi (Grid 4 Tombol)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMenuButton(Icons.add_card, "Isi Saldo"),
                    _buildMenuButton(Icons.qr_code_scanner, "Bayar",
                        onTap: _openCamera),
                    _buildMenuButton(Icons.send, "Transfer"),
                    _buildMenuButton(Icons.monetization_on, "Koin", onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShopeeCoinsPage()),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          // BAGIAN 2: RIWAYAT TRANSAKSI
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text("Riwayat Transaksi",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Daftar Transaksi Dummy
                _buildTransactionItem("Transfer ke BCA", "- Rp 500.000",
                    "Hari ini", Colors.black),
                _buildTransactionItem("Pembayaran ShopeeFood", "- Rp 45.000",
                    "Kemarin", Colors.black),
                _buildTransactionItem("Top Up dari BRI", "+ Rp 1.000.000",
                    "14 Des 2024", Colors.green),
                _buildTransactionItem("Terima Dana dari Budi", "+ Rp 50.000",
                    "12 Des 2024", Colors.green),
                _buildTransactionItem(
                    "Beli Pulsa", "- Rp 25.000", "10 Des 2024", Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Menu Atas (Putih Transparan)
  Widget _buildMenuButton(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget Item List Transaksi
  Widget _buildTransactionItem(
      String title, String amount, String date, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(amount,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
