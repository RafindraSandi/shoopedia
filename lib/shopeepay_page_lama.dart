import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopeediaPayPage extends StatelessWidget {
  const ShopeediaPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna Utama
    const Color primaryOrange = Color(0xFFEE4D2D);
    const Color secondaryOrange = Color(0xFFFF7337);

    // Formatter Rupiah
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Gunakan CustomScrollView agar header bisa menyatu dengan list
      body: CustomScrollView(
        slivers: [
          // APP BAR & HEADER SALDO
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: primaryOrange,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("ShopeediaPay",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryOrange, secondaryOrange],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Icon(Icons.account_balance_wallet,
                          color: Colors.white, size: 40),
                      const SizedBox(height: 10),
                      Text("Saldo Kamu",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14)),
                      const SizedBox(height: 5),
                      Text(
                        currencyFormatter.format(1540000),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // MENU GRID (FLOATING)
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -30), // Naikkan ke atas sedikit
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMenuButton(Icons.add_card, "Isi Saldo", Colors.blue),
                    _buildMenuButton(Icons.qr_code_scanner, "Bayar", primaryOrange),
                    _buildMenuButton(Icons.send, "Transfer", Colors.green),
                    _buildMenuButton(Icons.receipt_long, "Minta", Colors.purple),
                  ],
                ),
              ),
            ),
          ),

          // JUDUL RIWAYAT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Riwayat Transaksi",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Lihat Semua",
                        style: TextStyle(color: primaryOrange)),
                  )
                ],
              ),
            ),
          ),

          // LIST TRANSAKSI
          SliverList(
            delegate: SliverChildListDelegate([
              _buildTransactionItem("Transfer ke BCA", "- Rp 500.000",
                  "Hari ini", Colors.black, Icons.arrow_outward),
              _buildTransactionItem("Pembayaran ShopeeFood", "- Rp 45.000",
                  "Kemarin", Colors.black, Icons.fastfood),
              _buildTransactionItem("Top Up dari BRI", "+ Rp 1.000.000",
                  "14 Des 2024", Colors.green, Icons.add),
              _buildTransactionItem("Terima Dana dari Budi", "+ Rp 50.000",
                  "12 Des 2024", Colors.green, Icons.call_received),
              _buildTransactionItem("Beli Pulsa", "- Rp 25.000", "10 Des 2024",
                  Colors.black, Icons.phone_android),
              const SizedBox(height: 50),
            ]),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Menu
  Widget _buildMenuButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Widget Item Transaksi
  Widget _buildTransactionItem(
      String title, String amount, String date, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Icon(icon, size: 20, color: Colors.grey[600]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(date,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
