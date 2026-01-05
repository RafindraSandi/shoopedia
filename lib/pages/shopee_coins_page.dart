import 'package:flutter/material.dart';
import 'shopeediaPay_page.dart';

class ShopeeCoinsPage extends StatefulWidget {
  const ShopeeCoinsPage({super.key});

  @override
  State<ShopeeCoinsPage> createState() => _ShopeeCoinsPageState();
}

class _ShopeeCoinsPageState extends State<ShopeeCoinsPage> {
  // Simulasi data koin
  int _totalCoins = 2500;
  bool _hasCheckedIn = false;

  void _doCheckIn() {
    if (_hasCheckedIn) return; // Cegah klik 2 kali

    setState(() {
      _totalCoins += 100; // Tambah 100 koin
      _hasCheckedIn = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Check-in berhasil! Kamu dapat +100 Koin"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:
            const Text("Koin Shopeedia", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFC107), // Kuning Emas
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // BAGIAN 1: HEADER KOIN BESAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFFFC107),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Icon(Icons.monetization_on,
                    size: 60, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  "$_totalCoins",
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const Text("Koin Tersedia",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),

                const SizedBox(height: 25),

                // TOMBOL CHECK-IN HARIAN
                ElevatedButton(
                  onPressed: _hasCheckedIn ? null : _doCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange[800],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: Text(
                    _hasCheckedIn ? "Sudah Check-in" : "Check-in Harian (+100)",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 15),

                // TOMBOL KE SHOOPEDIAPAY
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ShopeediaPayPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE4D2D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Ke ShopeediaPay",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              ],
            ),
          ),

          // BAGIAN 2: RIWAYAT PENGGUNAAN
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text("Riwayat Koin",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (_hasCheckedIn)
                  _buildHistoryItem("Check-in Harian", "+100", Colors.green),
                _buildHistoryItem("Belanja - Kabel Data", "+50", Colors.green),
                _buildHistoryItem("Tukar Voucher Ongkir", "-500", Colors.red),
                _buildHistoryItem("Main Game Shopeedia", "+20", Colors.green),
                _buildHistoryItem("Koin Kadaluwarsa", "-10", Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFFF8E1),
            child: Icon(Icons.history, color: Colors.orange),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 14)),
          ),
          Text(amount,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
