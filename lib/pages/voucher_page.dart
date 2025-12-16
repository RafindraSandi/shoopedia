import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  void initState() {
    super.initState();
    _loadClaimStatus();
  }

  Future<void> _loadClaimStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final voucherIds = ['ongkir', 'diskon20', 'cashback10'];
    
    setState(() {
      for (var id in voucherIds) {
        String? lastClaimTimeStr = prefs.getString('voucher_$id');
        
        if (lastClaimTimeStr != null) {
          DateTime lastClaimTime = DateTime.parse(lastClaimTimeStr);
          DateTime now = DateTime.now();
          Duration difference = now.difference(lastClaimTime);
          if (difference.inHours < 24) {
            _claimStatus[id] = true;
          } else {
            _claimStatus[id] = false;
          }
        } else {
          _claimStatus[id] = false;
        }
      }
    });
  }

  Future<void> _claimVoucher(String id, String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voucher_$id', DateTime.now().toIso8601String());
    setState(() {
      _claimStatus[id] = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil klaim $title! Kembali lagi besok."),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voucher Saya", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // VOUCHER 1
          VoucherCard(
            id: "ongkir", // ID Unik
            title: "Gratis Ongkir",
            description: "Min. belanja Rp50.000",
            icon: Icons.local_shipping,
            colors: const [Color(0xFFFFA726), Color(0xFFFF9800)],
            shadowColor: Colors.orange,
            btnColor: Colors.orange,
            isClaimed: _claimStatus['ongkir'] ?? false, // Cek status
            onClaim: () => _claimVoucher('ongkir', 'Gratis Ongkir'), // Aksi
          ),

          // VOUCHER 2
          VoucherCard(
            id: "diskon20",
            title: "Diskon 20%",
            description: "Maks. potongan Rp25.000",
            icon: Icons.discount,
            colors: const [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
            shadowColor: Colors.purple,
            btnColor: Colors.purple,
            isClaimed: _claimStatus['diskon20'] ?? false,
            onClaim: () => _claimVoucher('diskon20', 'Diskon 20%'),
          ),

          // VOUCHER 3
          VoucherCard(
            id: "cashback10",
            title: "Cashback Rp10.000",
            description: "Min. belanja Rp100.000",
            icon: Icons.account_balance_wallet,
            colors: const [Color(0xFF4CAF50), Color(0xFF388E3C)],
            shadowColor: Colors.green,
            btnColor: Colors.green,
            isClaimed: _claimStatus['cashback10'] ?? false,
            onClaim: () => _claimVoucher('cashback10', 'Cashback'),
          ),
        ],
      ),
    );
  }
}

// 🔥 PERBAIKAN: Widget dipisah agar kodingan di atas tidak panjang
class VoucherCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> colors;
  final Color shadowColor;
  final Color btnColor;
  final bool isClaimed; // Status apakah sudah diklaim
  final VoidCallback onClaim; // Fungsi ketika tombol ditekan

  const VoucherCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.colors,
    required this.shadowColor,
    required this.btnColor,
    required this.isClaimed,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Jika sudah diklaim, warnanya jadi abu-abu (Grey)
          colors: isClaimed ? [Colors.grey, Colors.grey.shade600] : colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isClaimed ? Colors.grey.withOpacity(0.3) : shadowColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
                // 🔥 BARU: Tampilkan info kapan bisa klaim lagi
                if (isClaimed)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Tunggu 24 Jam",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 10,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          
          // 🔥 PERBAIKAN: Tombol berubah warna dan teks
          ElevatedButton(
            onPressed: isClaimed ? null : onClaim, // Kalau claimed, tombol mati (null)
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              // Warna teks berubah jadi abu jika disable
              foregroundColor: isClaimed ? Colors.grey : btnColor, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(isClaimed ? "Diklaim" : "Klaim"),
          ),
        ],
      ),
    );
