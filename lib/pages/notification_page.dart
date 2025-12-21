import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy Notifikasi
    final List<Map<String, dynamic>> notifications = [
      {
        "type": "order",
        "title": "Paket sedang dikirim",
        "subtitle": "Pesanan #SP123456 sedang dibawa kurir menuju lokasimu.",
        "date": "Hari ini 14:00",
        "isRead": false,
      },
      {
        "type": "promo",
        "title": "Flash Sale 12.12 Dimulai!",
        "subtitle": "Diskon hingga 90% untuk produk elektronik. Cek sekarang!",
        "date": "Kemarin",
        "isRead": true,
      },
      {
        "type": "info",
        "title": "Keamanan Akun",
        "subtitle": "Kami mendeteksi login baru di perangkat Windows.",
        "date": "10 Des",
        "isRead": true,
      },
      {
        "type": "order",
        "title": "Pesanan Selesai",
        "subtitle": "Terima kasih telah berbelanja di Official Store.",
        "date": "08 Des",
        "isRead": true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          IconData icon;
          Color iconColor;

          // Logika Ikon berdasarkan tipe
          switch (notif['type']) {
            case 'order':
              icon = Icons.local_shipping_outlined;
              iconColor = Colors.blue;
              break;
            case 'promo':
              icon = Icons.discount_outlined;
              iconColor = const Color(0xFFEE4D2D); // Shopee Orange
              break;
            default:
              icon = Icons.info_outline;
              iconColor = Colors.grey;
          }

          return Container(
            color: notif['isRead'] ? Colors.white : const Color(0xFFFFF8E1), // Kuning tipis kalau belum baca
            child: ListTile(
              leading: Icon(icon, color: iconColor, size: 30),
              title: Text(
                notif['title'],
                style: TextStyle(
                  fontWeight: notif['isRead'] ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notif['subtitle'], maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(notif['date'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              onTap: () {
                // Aksi ketika diklik (bisa diarahkan ke halaman pesanan)
              },
            ),
          );
        },
      ),
    );
  }
}
