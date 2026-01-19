import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';
import '../user_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Color mainColor = const Color(0xFFEE4D2D);

  // =======================================================
  // DIALOG HELPERS
  // =======================================================
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
              SizedBox(height: 8),
              Text(
                  '• Bagaimana cara menambah voucher?\n  Pergi ke menu Voucher di halaman utama'),
              SizedBox(height: 8),
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

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kebijakan Privasi'),
        content: const SingleChildScrollView(
          child: Text(
              "Kami menjaga privasi data Anda dengan serius. Data yang dikumpulkan hanya digunakan untuk keperluan transaksi dan peningkatan layanan Shoopedia. Kami tidak membagikan data pribadi kepada pihak ketiga tanpa izin."),
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

  // =======================================================
  // FUNGSI LOGOUT (YANG DIPERBAIKI)
  // =======================================================
  Future<void> _handleLogout() async {
    // 1. Hapus Dialog Konfirmasi dulu
    Navigator.pop(context);

    // 2. Hapus Sesi dari HP (PENTING!)
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user'); // Hapus kunci sesi agar tidak auto-login

    // 3. Reset data user di memori aplikasi
    UserManager.logout();

    if (!mounted) return;

    // 4. Pindah ke Halaman Login dan hapus semua history halaman sebelumnya
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: _handleLogout, // Panggil fungsi logout yang sudah diperbaiki
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
          // ==================================================
          // BAGIAN AKUN
          // ==================================================
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
                // NOTE: Untuk Edit Profil & Alamat, pastikan file halaman sudah dibuat
                // Jika belum, kode ini akan error saat dijalankan (import tidak ditemukan)
                // Sementara saya arahkan pop() atau comment navigasinya
                ListTile(
                  leading: Icon(Icons.person, color: mainColor),
                  title: const Text('Edit Profil'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                     // Navigasi ke Edit Profil (pastikan file ada)
                     // Navigator.push(...); 
                     Navigator.pop(context); // Sementara kembali
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.location_on, color: mainColor),
                  title: const Text('Alamat Pengiriman'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressPage()));
                    // Comment dulu kalau file belum siap
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.credit_card, color: mainColor),
                  title: const Text('Metode Pembayaran'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentPage()));
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ==================================================
          // BAGIAN INFO & BANTUAN
          // ==================================================
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
                  onTap: _showHelpCenter, // Panggil Dialog
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip, color: Colors.orange),
                  title: const Text('Kebijakan Privasi'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showPrivacyPolicy, // Panggil Dialog
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

          // ==================================================
          // TOMBOL LOGOUT
          // ==================================================
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
              title: const Text('Keluar Akun', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: _confirmLogout, // Panggil konfirmasi logout
            ),
          ),

          const SizedBox(height: 20),

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
