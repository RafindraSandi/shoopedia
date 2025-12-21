import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kebijakan Privasi & Data"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menyiapkan dokumen untuk dicetak..."))
              );
            },
          )
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER DOKUMEN
              Center(
                child: Column(
                  children: [
                    Image.network(
                      "https://cdn-icons-png.flaticon.com/512/272/272446.png", // Icon Legal Dummy
                      height: 60,
                      errorBuilder: (_,__,___) => const Icon(Icons.gavel, size: 60, color: Color(0xFFEE4D2D)),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "KEBIJAKAN PRIVASI\nPT. SHOOPEDIA INDONESIA",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                      child: Text("Ref: LEG-PRIV-2025-V3.4", style: TextStyle(color: Colors.grey[700], fontSize: 10, fontFamily: 'monospace')),
                    ),
                    const SizedBox(height: 5),
                    Text("Berlaku Efektif: 1 Januari 2025", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              const Divider(height: 50, thickness: 2),

              // PASAL 1
              _buildArticle("PASAL 1", "DEFINISI DAN INTERPRETASI"),
              _buildParagraph(
                "1.1. Dalam Kebijakan Privasi ini, istilah-istilah berikut memiliki arti sebagai berikut:"
              ),
              _buildBulletList([
                "'Akun' berarti akun unik yang dibuat untuk Anda guna mengakses Layanan kami.",
                "'Afiliasi' berarti entitas yang mengendalikan, dikendalikan oleh, atau berada di bawah kendali bersama dengan suatu pihak.",
                "'Data Pribadi' adalah informasi apa pun yang terkait dengan individu yang teridentifikasi atau dapat diidentifikasi.",
                "'Platform' mengacu pada Aplikasi Shoopedia dan situs web terkait.",
                "'Penyedia Layanan' berarti setiap orang perseorangan atau badan hukum yang memproses data atas nama Perusahaan."
              ]),

              // PASAL 2
              _buildArticle("PASAL 2", "PENGUMPULAN DATA PRIBADI"),
              _buildParagraph("Kami mengumpulkan data Anda dalam beberapa cara:"),
              _buildSubHeader("2.1. Data yang Anda Berikan Secara Sukarela"),
              _buildBulletList([
                "Identitas: Nama lengkap, NIK (untuk verifikasi ShoopediaPay), tanggal lahir, jenis kelamin.",
                "Kontak: Alamat penagihan, alamat pengiriman, email, dan nomor telepon.",
                "Keuangan: Detail rekening bank dan kartu kredit (disimpan dalam format terenkripsi/masked).",
                "Biometrik: Data pengenalan wajah (Face ID) atau sidik jari jika Anda mengaktifkan fitur login biometrik."
              ]),
              _buildSubHeader("2.2. Data yang Direkam Secara Otomatis"),
              _buildBulletList([
                "Data Perangkat: Model perangkat keras, sistem operasi, pengenal perangkat unik (IMEI, Android ID, IDFA), dan informasi jaringan seluler.",
                "Data Lokasi: Lokasi geografis real-time (GPS, Wi-Fi, menara seluler) saat Anda menggunakan fitur berbasis lokasi.",
                "Data Log: Alamat IP, waktu akses, halaman yang dilihat, dan tautan yang diklik."
              ]),

              // PASAL 3
              _buildArticle("PASAL 3", "PENGGUNAAN COOKIES DAN TEKNOLOGI PELACAKAN"),
              _buildParagraph(
                "3.1. Kami menggunakan Cookies, Web Beacons, dan Pixel Tags untuk meningkatkan fungsionalitas Platform. Cookies adalah file kecil yang ditempatkan di perangkat Anda."
              ),
              _buildParagraph(
                "3.2. Kami menggunakan jenis Cookies berikut:"
              ),
              _buildBulletList([
                "Cookies Esensial: Diperlukan untuk operasional dasar (misalnya, login, keranjang belanja).",
                "Cookies Analitik: Membantu kami memahami bagaimana pengguna berinteraksi dengan Platform (Google Analytics).",
                "Cookies Iklan: Digunakan untuk menampilkan iklan yang relevan dengan minat Anda (Facebook Pixel, Google Ads)."
              ]),
              
              // PASAL 4
              _buildArticle("PASAL 4", "TUJUAN PENGGUNAAN DATA"),
              _buildParagraph("Kami memproses Data Pribadi Anda untuk tujuan berikut:"),
              _buildNumberedList([
                "Memproses dan menyelesaikan pesanan produk serta pembayaran Anda.",
                "Melakukan verifikasi identitas dan penilaian risiko kredit (Credit Scoring) untuk layanan PayLater.",
                "Menyediakan layanan pelanggan, termasuk menanggapi pertanyaan, keluhan, dan klaim garansi.",
                "Personalisasi pengalaman pengguna, termasuk rekomendasi produk berdasarkan riwayat pencarian.",
                "Mengirimkan komunikasi pemasaran (newsletter, promo) jika Anda telah menyetujuinya.",
                "Mencegah, mendeteksi, dan menyelidiki potensi aktivitas terlarang, penipuan, atau pelanggaran keamanan.",
                "Mematuhi kewajiban hukum yang berlaku di Republik Indonesia (cth: pelaporan pajak, audit)."
              ]),

              // PASAL 5
              _buildArticle("PASAL 5", "PENGUNGKAPAN KEPADA PIHAK KETIGA"),
              _buildParagraph(
                "Kami tidak menjual data Anda. Namun, kami dapat membagikan data Anda kepada:"
              ),
              _buildSubHeader("5.1. Mitra Logistik & Pengiriman"),
              _buildParagraph("Nama, telepon, dan alamat Anda dibagikan kepada kurir (JNE, SiCepat, Gosend, GrabExpress) semata-mata untuk pengantaran paket."),
              
              _buildSubHeader("5.2. Penyedia Layanan Pembayaran"),
              _buildParagraph("Data transaksi dibagikan ke Bank dan Gateway Pembayaran untuk validasi transfer dan pencegahan fraud."),
              
              _buildSubHeader("5.3. Otoritas Hukum"),
              _buildParagraph("Kami dapat mengungkapkan data jika diperintahkan oleh pengadilan, kepolisian, atau instansi pemerintah yang berwenang."),

              // PASAL 6
              _buildArticle("PASAL 6", "PENYIMPANAN DAN KEAMANAN DATA"),
              _buildParagraph(
                "6.1. Kami menggunakan standar keamanan industri (enkripsi SSL/TLS, Firewall, dan kontrol akses fisik) untuk melindungi data Anda."
              ),
              _buildParagraph(
                "6.2. Data Anda disimpan di pusat data yang aman. Sesuai dengan peraturan perundang-undangan di Indonesia, kami menyimpan data transaksi keuangan minimal 5 (lima) tahun, atau selama diperlukan untuk memenuhi tujuan pengumpulan data."
              ),
              _buildParagraph(
                "6.3. Meskipun kami berusaha sebaik mungkin, tidak ada metode transmisi melalui internet yang 100% aman. Anda bertanggung jawab untuk menjaga kerahasiaan kata sandi dan kode OTP Anda."
              ),

              // PASAL 7
              _buildArticle("PASAL 7", "HAK-HAK PENGGUNA (SUBJEK DATA)"),
              _buildParagraph("Anda memiliki hak-hak berikut terkait data Anda:"),
              _buildBulletList([
                "Hak Akses: Meminta salinan data pribadi yang kami simpan tentang Anda.",
                "Hak Koreksi: Meminta perbaikan data yang tidak akurat atau tidak lengkap.",
                "Hak Penghapusan (Right to be Forgotten): Meminta penghapusan akun dan data Anda secara permanen.",
                "Hak Portabilitas: Meminta data Anda dalam format yang terstruktur dan dapat dibaca mesin.",
                "Hak Penarikan Persetujuan: Menarik izin penggunaan data untuk pemasaran."
              ]),
              
              // PASAL 8
              _buildArticle("PASAL 8", "TRANSFER DATA INTERNASIONAL"),
              _buildParagraph(
                "Layanan kami mungkin menggunakan server atau penyedia layanan cloud (seperti AWS atau Google Cloud) yang berlokasi di luar Indonesia. Dengan menggunakan Layanan kami, Anda menyetujui transfer, penyimpanan, dan pemrosesan data Anda di negara-negara tersebut dengan tetap memperhatikan standar perlindungan data yang setara."
              ),

              // PASAL 9
              _buildArticle("PASAL 9", "PERLINDUNGAN ANAK"),
              _buildParagraph(
                "Platform ini tidak ditujukan untuk individu di bawah usia 18 tahun (atau usia dewasa di yurisdiksi Anda). Kami tidak secara sadar mengumpulkan data dari anak di bawah umur. Jika kami menemukan bahwa kami telah mengumpulkan data anak tanpa izin orang tua, kami akan segera menghapus data tersebut."
              ),

              // PASAL 10
              _buildArticle("PASAL 10", "PERUBAHAN KEBIJAKAN PRIVASI"),
              _buildParagraph(
                "Kami dapat memperbarui Kebijakan ini dari waktu ke waktu. Perubahan material akan diberitahukan kepada Anda melalui email atau notifikasi dalam aplikasi setidaknya 30 hari sebelum perubahan berlaku."
              ),
              
              // PASAL 11
              _buildArticle("PASAL 11", "HUBUNGI KAMI"),
              _buildParagraph(
                "Jika Anda memiliki pertanyaan tentang Kebijakan Privasi ini, silakan hubungi Data Protection Officer (DPO) kami:"
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  border: Border.all(color: Colors.blueGrey[100]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("PT. SHOOPEDIA INDONESIA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Attn: Data Protection Officer"),
                    Text("Gedung Shoopedia Tower, Lt. 22"),
                    Text("Jl. Jendral Sudirman Kav. 52-53"),
                    Text("Jakarta Selatan 12190, Indonesia"),
                    SizedBox(height: 10),
                    Text("Email: privacy@shoopedia.co.id"),
                    Text("Telepon: (021) 5091-2000"),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Dengan menekan tombol di bawah, Anda menyatakan telah membaca dan menyetujui Kebijakan Privasi ini.",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE4D2D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("SAYA MENGERTI & SETUJU", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER UNTUK KODE RAPI ---

  Widget _buildArticle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFEE4D2D))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const Divider(thickness: 1, color: Colors.black12),
        ],
      ),
    );
  }

  Widget _buildSubHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black54),
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumberedList(List<String> items) {
    return Column(
      children: items.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${entry.key + 1}. ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
