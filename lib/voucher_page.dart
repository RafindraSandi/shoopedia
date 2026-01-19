import 'package:flutter/material.dart';

// Simpan data voucher secara global sederhana (bisa dipindah ke voucher_manager.dart nanti)
class VoucherData {
  static Set<String> claimedVouchers = {}; // Menyimpan ID voucher yg diklaim
}

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voucher Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildVoucherItem(
            id: "ONGKIR10",
            title: "Gratis Ongkir",
            subtitle: "Min. belanja Rp0",
            colors: [const Color(0xFFFFA726), const Color(0xFFFF9800)],
            icon: Icons.local_shipping,
          ),
          _buildVoucherItem(
            id: "DISKON50",
            title: "Diskon 50%",
            subtitle: "Min. belanja Rp50.000",
            colors: [const Color(0xFF42A5F5), const Color(0xFF2196F3)],
            icon: Icons.discount,
          ),
          _buildVoucherItem(
            id: "CASHBACK10",
            title: "Cashback Rp10.000",
            subtitle: "Min. belanja Rp100.000",
            colors: [const Color(0xFFEF5350), const Color(0xFFE53935)],
            icon: Icons.monetization_on,
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherItem({
    required String id,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required IconData icon,
  }) {
    bool isClaimed = VoucherData.claimedVouchers.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isClaimed ? [Colors.grey, Colors.grey.shade400] : colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isClaimed
                ? null // Disable tombol jika sudah diklaim
                : () {
                    setState(() {
                      VoucherData.claimedVouchers.add(id);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voucher berhasil diklaim!')),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: isClaimed ? Colors.grey : colors.last,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(isClaimed ? "Diklaim" : "Klaim"),
          ),
        ],
      ),
    );
  }
}
