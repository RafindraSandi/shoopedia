import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopeeCoinsPage extends StatefulWidget {
  const ShopeeCoinsPage({super.key});

  @override
  State<ShopeeCoinsPage> createState() => _ShopeeCoinsPageState();
}

class _ShopeeCoinsPageState extends State<ShopeeCoinsPage> {
  // Simulasi Saldo Awal
  int _totalCoins = 2500;
  bool _hasCheckedIn = false;

  // Format angka koin (2500 -> 2.500)
  final coinFormatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);

  // Data Dummy Riwayat Transaksi
  List<Map<String, dynamic>> history = [
    {"title": "Belanja - Kabel Data", "amount": 50, "type": "earn"},
    {"title": "Tukar Voucher Ongkir", "amount": -500, "type": "spend"},
    {"title": "Main Game Shopeedia", "amount": 20, "type": "earn"},
    {"title": "Koin Kadaluwarsa", "amount": -10, "type": "expire"},
  ];

  void _doCheckIn() {
    if (_hasCheckedIn) return;

    setState(() {
      _totalCoins += 100;
      _hasCheckedIn = true;
      
      // Tambahkan history check-in ke paling atas list
      history.insert(0, {
        "title": "Check-in Harian",
        "amount": 100,
        "type": "earn"
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Selamat! Kamu mendapatkan +100 Koin"),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Koin Shopeedia", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFEAA300), // Warna emas gelap untuk Appbar
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // ==================================================
          // BAGIAN 1: HEADER KOIN (Gradient Gold)
          // ==================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 40, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEAA300), Color(0xFFFFC107)], // Efek Emas
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.monetization_on_rounded, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  coinFormatter.format(_totalCoins),
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text("Koin Tersedia", 
                  style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500)),
                
                const SizedBox(height: 30),
                
                // TOMBOL CHECK-IN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _hasCheckedIn ? null : _doCheckIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFEAA300),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      _hasCheckedIn ? "Sudah Check-in Hari Ini" : "Check-in Harian (+100)",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),

          // ==================================================
          // BAGIAN 2: RIWAYAT TRANSAKSI
          // ==================================================
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length + 1, // +1 untuk Judul Header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 15, left: 5),
                      child: Text("Riwayat Koin", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    );
                  }

                  final item = history[index - 1];
                  return _buildHistoryItem(item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    bool isPositive = item['amount'] > 0;
    Color amountColor = isPositive ? const Color(0xFFEAA300) : Colors.black87;
    String prefix = isPositive ? "+" : "";

    IconData icon;
    if (item['type'] == 'earn') {
      icon = Icons.download_done; // Dapat koin
    } else if (item['type'] == 'expire') {
      icon = Icons.access_time; // Kadaluwarsa
    } else {
      icon = Icons.shopping_bag_outlined; // Belanja
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.orange.withOpacity(0.1),
            child: Icon(icon, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(getDateToday(), style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Text(
            "$prefix${item['amount']}", 
            style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16)
          ),
        ],
      ),
    );
  }

  // Helper untuk tanggal dummy
  String getDateToday() {
    DateTime now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }
}
