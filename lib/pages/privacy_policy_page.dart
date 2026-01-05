import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kebijakan Privasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kebijakan Privasi Shoopedia",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Terakhir diperbarui: 1 Januari 2025",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildSection("Informasi yang Kami Kumpulkan",
                "Kami mengumpulkan berbagai jenis informasi untuk memberikan layanan terbaik kepada Anda:\n\n• Informasi yang Anda berikan: nama lengkap, alamat email, nomor telepon, alamat pengiriman, dan detail pembayaran saat membuat akun atau melakukan transaksi.\n• Informasi penggunaan: data tentang bagaimana Anda menggunakan aplikasi, halaman yang dikunjungi, waktu akses, dan fitur yang digunakan.\n• Data perangkat: informasi tentang perangkat Anda seperti model, sistem operasi, dan pengenal unik.\n• Lokasi: data lokasi geografis jika Anda memberikan izin untuk fitur berbasis lokasi.\n• Cookies dan teknologi serupa: digunakan untuk meningkatkan pengalaman browsing Anda."),
            _buildSection("Cara Kami Menggunakan Informasi",
                "Informasi Anda digunakan untuk berbagai tujuan penting:\n\n• Memproses dan mengirimkan pesanan produk yang Anda beli.\n• Memverifikasi identitas dan mencegah penipuan.\n• Memberikan layanan pelanggan dan menjawab pertanyaan Anda.\n• Mengirim notifikasi tentang status pesanan dan pembaruan aplikasi.\n• Personalisasi pengalaman berbelanja berdasarkan preferensi Anda.\n• Mengirim penawaran khusus dan promo (dengan persetujuan Anda).\n• Meningkatkan keamanan akun dan mencegah aktivitas yang mencurigakan.\n• Mematuhi kewajiban hukum dan peraturan yang berlaku."),
            _buildSection("Berbagi Informasi dengan Pihak Ketiga",
                "Kami berkomitmen untuk melindungi privasi Anda dan tidak menjual data pribadi Anda. Namun, dalam situasi tertentu, kami dapat membagikan informasi:\n\n• Dengan penyedia layanan pengiriman (seperti JNE, SiCepat) untuk mengantar pesanan ke alamat Anda.\n• Dengan gateway pembayaran untuk memproses transaksi secara aman.\n• Dengan mitra bisnis untuk menyediakan layanan tambahan yang Anda minta.\n• Dengan otoritas hukum jika diperlukan oleh undang-undang atau untuk melindungi hak kami.\n• Dalam kasus merger atau akuisisi perusahaan, dengan penerus bisnis kami."),
            _buildSection("Keamanan Data dan Hak Pengguna",
                "Kami mengutamakan keamanan data Anda dengan menggunakan teknologi enkripsi, firewall, dan kontrol akses yang ketat. Data disimpan di server yang aman dan hanya diakses oleh personel yang berwenang.\n\nAnda memiliki hak-hak berikut:\n• Mengakses dan meninjau data pribadi yang kami simpan.\n• Memperbarui informasi yang tidak akurat atau tidak lengkap.\n• Meminta penghapusan data Anda secara permanen.\n• Menolak pemasaran langsung kapan saja.\n• Mengajukan keluhan jika Anda merasa hak privasi Anda dilanggar.\n\nUntuk menggunakan hak-hak ini, hubungi kami di privacy@shoopedia.co.id atau melalui aplikasi."),
            _buildSection("Penyimpanan dan Transfer Data",
                "Data Anda disimpan selama diperlukan untuk tujuan pengumpulan atau sesuai dengan persyaratan hukum. Data transaksi keuangan biasanya disimpan minimal 5 tahun.\n\nLayanan kami mungkin menggunakan server di luar Indonesia. Dalam hal ini, kami memastikan transfer data dilakukan dengan standar perlindungan yang memadai sesuai dengan peraturan privasi yang berlaku."),
            _buildSection("Perlindungan Anak dan Konten",
                "Aplikasi ini tidak ditujukan untuk pengguna di bawah 18 tahun. Kami tidak secara sengaja mengumpulkan data dari anak di bawah umur. Jika kami mengetahui telah mengumpulkan data anak tanpa izin orang tua, data tersebut akan segera dihapus."),
            _buildSection("Perubahan Kebijakan Privasi",
                "Kebijakan privasi ini dapat diperbarui untuk mencerminkan perubahan dalam praktik kami atau persyaratan hukum. Perubahan signifikan akan diberitahukan melalui:\n\n• Notifikasi dalam aplikasi\n• Email ke alamat yang terdaftar\n• Pengumuman di situs web resmi\n\nVersi terbaru selalu tersedia di halaman pengaturan aplikasi."),
            _buildSection("Hubungi Kami",
                "Jika Anda memiliki pertanyaan tentang kebijakan privasi ini atau ingin menggunakan hak privasi Anda, hubungi tim privasi kami:\n\nEmail: privacy@shoopedia.co.id\nTelepon: (021) 5091-2000\nAlamat: Lowokwaru, Malang, Jawa Timur\n\nKami berkomitmen untuk menjawab pertanyaan Anda dalam waktu 30 hari kerja."),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Saya Mengerti & Setuju",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEE4D2D)),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
                fontSize: 14, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
