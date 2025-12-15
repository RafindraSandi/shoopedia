import 'package:flutter/material.dart';
import 'package:shoopedia/login_page.dart';
import 'package:shoopedia/pages/address_page.dart';
import 'package:shoopedia/pages/payment_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Color mainColor = const Color(0xFFEE4D2D);

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pusat Bantuan'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('FAQ - Pertanyaan Umum:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  '• Bagaimana cara mengubah alamat pengiriman?\n  Pergi ke menu Profil > Alamat'),
              Text(
                  '• Bagaimana cara menambah voucher?\n  Pergi ke menu Voucher di halaman utama'),
              Text(
                  '• Bagaimana cara melihat status pesanan?\n  Pergi ke menu Pesanan Saya'),
              SizedBox(height: 16),
              Text('Kontak Kami:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Email: support@shoopedia.com'),
              Text('Telepon: 021-12345678'),
              Text('Jam Operasional: 08:00 - 17:00 WIB'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keamanan Akun'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pengaturan Keamanan:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Ganti Password'),
              Text('• Aktifkan Two-Factor Authentication'),
              Text('• Kelola Perangkat Terhubung'),
              Text('• Riwayat Login'),
              SizedBox(height: 16),
              Text('Tips Keamanan:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Gunakan password yang kuat'),
              Text('• Jangan bagikan kode OTP'),
              Text('• Logout setelah selesai berbelanja'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAboutApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Shoopedia v1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text(
                  'Aplikasi e-commerce terpercaya untuk kebutuhan sehari-hari Anda.'),
              SizedBox(height: 16),
              Text('Fitur Utama:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Belanja produk berkualitas'),
              Text('• Sistem pembayaran aman'),
              Text('• Pelacakan pesanan real-time'),
              Text('• Voucher dan promo menarik'),
              Text('• Layanan pelanggan 24/7'),
              SizedBox(height: 16),
              Text('© 2024 Shoopedia. All rights reserved.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Navigate back to login page
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Akun"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Settings Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: mainColor),
                  title: const Text('Edit Profil'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to edit profile page
                    Navigator.pop(context); // Go back to profile page
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.location_on, color: mainColor),
                  title: const Text('Alamat Pengiriman'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddressPage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.credit_card, color: mainColor),
                  title: const Text('Metode Pembayaran'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Support & Info Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_center, color: Colors.blue),
                  title: const Text('Pusat Bantuan'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showHelpCenter,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.security, color: Colors.green),
                  title: const Text('Keamanan Akun'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showSecuritySettings,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.purple),
                  title: const Text('Tentang Aplikasi'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showAboutApp,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Account Actions Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Keluar Akun'),
              onTap: _logout,
            ),
          ),

          const SizedBox(height: 20),

          // App Version
          const Center(
            child: Text(
              'Versi 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
