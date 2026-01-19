import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy Tracking
    final List<Map<String, String>> history = [
      {"date": "20 Jan 14:30", "status": "Paket telah diterima oleh Ybs.", "active": "true"},
      {"date": "20 Jan 09:00", "status": "Paket dibawa kurir (Budi - 0812xx) menuju lokasimu.", "active": "false"},
      {"date": "19 Jan 23:00", "status": "Paket telah sampai di Gudang Sortir Jakarta (JKT_HUB).", "active": "false"},
      {"date": "19 Jan 18:00", "status": "Paket sedang dikirim ke Hub Transit.", "active": "false"},
      {"date": "19 Jan 10:00", "status": "Penjual telah menyerahkan paket ke kurir.", "active": "false"},
      {"date": "19 Jan 09:30", "status": "Pengirim telah mengatur pengiriman.", "active": "false"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lacak Paket"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Resi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("No. Resi:", style: TextStyle(color: Colors.grey)),
                    Row(
                      children: const [
                        Text("SPX1234567890", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                        Icon(Icons.copy, size: 14, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Kurir:", style: TextStyle(color: Colors.grey)),
                    Text("Shopeedia Express", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // Timeline Builder
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final isFirst = index == 0;
              final isLast = index == history.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom Waktu
                  SizedBox(
                    width: 50,
                    child: Text(
                      item['date']!.split(' ')[1], // Ambil jamnya aja
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Garis & Dot Timeline
                  Column(
                    children: [
                      Container(
                        width: 2,
                        height: 20,
                        color: isFirst ? Colors.transparent : Colors.grey[300],
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isFirst ? const Color(0xFFEE4D2D) : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 50, // Panjang garis ke bawah
                        color: isLast ? Colors.transparent : Colors.grey[300],
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),

                  // Konten Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18), // Biar sejajar sama dot
                        Text(
                          item['status']!,
                          style: TextStyle(
                            color: isFirst ? const Color(0xFFEE4D2D) : Colors.black87,
                            fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          item['date']!.split(' ')[0], // Tanggal
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
