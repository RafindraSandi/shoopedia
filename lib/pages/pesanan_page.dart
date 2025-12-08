import 'package:flutter/material.dart';

class PesananPage extends StatefulWidget {
  final int initialTab;
  const PesananPage({super.key, this.initialTab = 0});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage>
    with SingleTickerProviderStateMixin {
  final Color mainColor = const Color(0xFFEE4D2D);

  late TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: widget.initialTab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Belum Bayar"),
            Tab(text: "Dikemas"),
            Tab(text: "Dikirim"),
            Tab(text: "Selesai"),
            Tab(text: "Pengembalian"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildEmptyTab("Belum Bayar"),
          buildOrderList("Dikemas"),
          buildOrderList("Dikirim"),
          buildOrderList("Selesai"),
          buildEmptyTab("Pengembalian"),
        ],
      ),
    );
  }

  // ===================================================================
  // Tab Kosong
  // ===================================================================
  Widget buildEmptyTab(String title) {
    return Center(
      child: Text(
        "Tidak ada pesanan $title",
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // ===================================================================
  // List Pesanan (contoh dummy)
  // ===================================================================
  Widget buildOrderList(String status) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        orderCard(
          toko: "Glad2Glow Official Store",
          status: status,
          gambar: "https://www.beautyhaul.com/assets/uploads/products/thumbs/800x800/G2G_Pomegranate_Clay_Stick1.jpg",
          nama: "[DISKON 60%] Glad2Glow Clay Stick 3PC",
          total: "Rp206.961",
          qty: 3,
        ),
        const SizedBox(height: 12),
        orderCard(
          toko: "Rightbox.id Official Shop",
          status: status,
          gambar: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/114/MTA-166669970/eba_eba_kaos_kaki_oldschool_hitam_2_line_white_full01_npsyzed3.jpg",
          nama: "Kaos Kaki Oldschool Motif Hitam",
          total: "Rp36.962",
          qty: 2,
        ),
      ],
    );
  }

  // ===================================================================
  // Kartu Pesanan
  // ===================================================================
  Widget orderCard({
    required String toko,
    required String status,
    required String gambar,
    required String nama,
    required String total,
    required int qty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          // Header toko
          ListTile(
            leading: const Icon(Icons.store, color: Colors.red),
            title:
                Text(toko, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(
              status,
              style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
            ),
          ),

          // Produk
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    gambar,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("x$qty"),
              ],
            ),
          ),

          const Divider(),

          // Total harga
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total $qty produk: $total",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Tombol
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: const Text("Beli Lagi"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                  ),
                  onPressed: () {},
                  child: const Text("Nilai"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
