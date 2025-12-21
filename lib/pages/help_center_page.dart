import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // ==========================================
  // DATABASE FAQ RAKSASA
  // ==========================================
  final List<Map<String, dynamic>> _faqDatabase = [
    {
      "category": "Akun & Keamanan",
      "icon": Icons.shield_outlined,
      "items": [
        {
          "q": "Bagaimana cara mereset Password?",
          "a": "Jika Anda lupa kata sandi atau ingin mengubahnya demi keamanan:\n\n1. Masuk ke halaman Login, klik 'Lupa Password'.\n2. Masukkan Email atau No. HP terdaftar.\n3. Masukkan kode OTP 6 digit yang dikirim.\n4. Buat password baru (Min. 8 karakter, kombinasi huruf & angka).\n5. Login ulang dengan password baru."
        },
        {
          "q": "Akun saya dibatasi / Banned",
          "a": "Pembatasan akun terjadi karena aktivitas mencurigakan, seperti:\n\n• Terdeteksi Order Fiktif (Fake Order).\n• Login di banyak perangkat sekaligus.\n• Penyalahgunaan Voucher.\n\nUntuk memulihkan akun, silakan isi formulir 'Banding Pemulihan Akun' atau hubungi CS kami dengan melampirkan Foto KTP dan Selfie."
        },
        {
          "q": "Cara ganti Nomor HP yang hilang/hangus",
          "a": "Jika nomor lama sudah tidak aktif:\n1. Buka menu Profil > Pengaturan.\n2. Pilih 'Profil Saya' > 'Telepon'.\n3. Klik 'Ubah' > 'Nomor lama sudah tidak aktif'.\n4. Lakukan verifikasi wajah atau verifikasi email.\n5. Masukkan nomor baru."
        },
        {
          "q": "Menghapus Akun Permanen",
          "a": "PENTING: Menghapus akun akan menghanguskan Koin dan Saldo.\n\nMasuk ke Pengaturan > Ajukan Penghapusan Akun. Proses memakan waktu 14 hari kerja."
        }
      ]
    },
    {
      "category": "Pesanan & Pelacakan",
      "icon": Icons.local_shipping_outlined,
      "items": [
        {
          "q": "Kapan pesanan saya dikirim?",
          "a": "Penjual memiliki batas waktu pengiriman ('Masa Pengemasan'):\n\n• Reguler: 2 Hari Kerja\n• Pre-order: 7-14 Hari Kerja\n\nJika melewati batas waktu, pesanan batal otomatis & dana kembali penuh."
        },
        {
          "q": "Status 'Pesanan Selesai' tapi barang belum sampai",
          "a": "Mohon periksa hal berikut:\n1. Cek riwayat penerima di detail pelacakan (apakah diterima satpam/tetangga?).\n2. Hubungi kurir terkait.\n3. Jika tidak ketemu, segera ajukan 'Pengembalian Barang/Dana' sebelum masa Garansi Shoopedia habis (2x24 jam)."
        },
        {
          "q": "Kenapa resi tidak bisa dilacak?",
          "a": "Resi baru terbaca di sistem ekspedisi maksimal 1x24 jam setelah barang diserahkan ke kurir (Pick-up). Silakan cek berkala."
        },
        {
          "q": "Membatalkan Pesanan",
          "a": "• Jika status 'Dikemas' dan belum ada resi: Pembatalan Instan.\n• Jika sudah ada resi: Harus persetujuan penjual.\n• Jika status 'Dikirim': Tidak bisa dibatalkan."
        }
      ]
    },
    {
      "category": "Pembayaran & Tagihan",
      "icon": Icons.payment_outlined,
      "items": [
        {
          "q": "Cara bayar via Virtual Account",
          "a": "1. Pilih metode Transfer Bank (Auto Check).\n2. Salin No. Virtual Account.\n3. Buka M-Banking > Menu Virtual Account.\n4. Masukkan nomor > Bayar sesuai nominal.\n5. Pembayaran terverifikasi otomatis dalam 5 menit."
        },
        {
          "q": "Pembayaran COD (Bayar di Tempat)",
          "a": "COD tersedia untuk wilayah dan toko tertentu. Syarat:\n• Maksimal transaksi Rp 3 Juta.\n• Dilarang menolak paket saat kurir datang (Akun bisa di-banned).\n• Bayar tunai ke kurir sebelum buka paket."
        },
        {
          "q": "Sudah bayar tapi status 'Belum Bayar'",
          "a": "Jika lebih dari 30 menit status tidak berubah, silakan Hubungi CS dengan melampirkan bukti transfer. Kemungkinan ada gangguan pada sistem bank."
        }
      ]
    },
    {
      "category": "ShoopediaPay & Koin",
      "icon": Icons.account_balance_wallet_outlined,
      "items": [
        {
          "q": "Cara Top Up ShoopediaPay",
          "a": "Anda bisa Top Up melalui:\n• Transfer Bank (BCA, Mandiri, BRI, BNI).\n• Minimarket (Indomaret/Alfamart).\n• OneKlik.\n\nMinimal Top Up Rp 10.000."
        },
        {
          "q": "Upgrade ke ShoopediaPay Plus",
          "a": "Keuntungan Plus: Limit saldo Rp 20 Juta & Bisa Transfer ke Bank.\nSyarat: Upload Foto E-KTP & Selfie. Proses verifikasi 1x24 Jam."
        },
        {
          "q": "Koin Shoopedia Hangus",
          "a": "Koin memiliki masa berlaku 3 bulan sejak didapatkan. Gunakan koin untuk potongan belanja (maks 50% total transaksi)."
        }
      ]
    },
    {
      "category": "Pengembalian (Retur)",
      "icon": Icons.assignment_return_outlined,
      "items": [
        {
          "q": "Syarat & Ketentuan Retur",
          "a": "Anda bisa mengajukan retur jika:\n• Barang Rusak/Cacat.\n• Salah Kirim (Warna/Ukuran).\n• Produk Tidak Original (Khusus Shoopedia Mall).\n\nWAJIB: Video Unboxing tanpa jeda."
        },
        {
          "q": "Biaya Ongkir Retur",
          "a": "• Jika kesalahan Penjual: Ongkir retur ditanggung Shoopedia/Penjual.\n• Jika 'Berubah Pikiran': Ongkir ditanggung Pembeli (hanya untuk produk tertentu)."
        },
        {
          "q": "Berapa lama dana kembali (Refund)?",
          "a": "• ShoopediaPay: Instan (setelah retur disetujui).\n• Kartu Kredit: 7-14 hari kerja (tergantung bank).\n• Transfer Bank: 1-3 hari kerja."
        }
      ]
    },
    {
      "category": "Voucher & Promosi",
      "icon": Icons.discount_outlined,
      "items": [
        {
          "q": "Voucher Gratis Ongkir tidak bisa dipakai",
          "a": "Cek syarat berikut:\n1. Minimal belanja belum terpenuhi (cth: Min. Rp 30rb).\n2. Metode pembayaran tidak sesuai (cth: Wajib ShoopediaPay).\n3. Jasa kirim tidak didukung.\n4. Kuota voucher habis."
        },
        {
          "q": "Cara pakai Voucher Cashback",
          "a": "Pilih voucher di halaman Checkout. Cashback akan masuk dalam bentuk Koin Shoopedia setelah pesanan selesai (bukan potongan harga langsung)."
        }
      ]
    },
    {
      "category": "Mitra Penjual",
      "icon": Icons.storefront_outlined,
      "items": [
        {
          "q": "Cara buka toko di Shoopedia",
          "a": "1. Masuk menu 'Saya' > 'Mulai Jual'.\n2. Atur info toko (Nama, Deskripsi, Alamat).\n3. Upload produk pertama.\n4. Atur jasa kirim yang didukung."
        },
        {
          "q": "Biaya Admin Penjual",
          "a": "• Penjual Non-Star: Gratis untuk 100 order pertama, selanjutnya 1.5%.\n• Star Seller: 3.5%.\n• Shoopedia Mall: 5.5%."
        }
      ]
    },
    {
      "category": "Kendala Teknis",
      "icon": Icons.bug_report_outlined,
      "items": [
        {
          "q": "Aplikasi sering Force Close / Crash",
          "a": "1. Bersihkan Cache aplikasi (Pengaturan HP > Aplikasi > Shoopedia > Clear Cache).\n2. Update aplikasi ke versi terbaru di PlayStore.\n3. Pastikan memori internal HP tidak penuh."
        },
        {
          "q": "Tidak bisa upload gambar/video",
          "a": "Pastikan Anda telah memberikan Izin Akses (Permission) untuk Kamera dan Galeri di pengaturan privasi HP Anda."
        }
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background agak abu biar konten pop-up
      appBar: AppBar(
        title: const Text("Pusat Bantuan"),
        backgroundColor: const Color(0xFFEE4D2D), // Warna Shopee
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}), // Riwayat Tiket
        ],
      ),
      body: Column(
        children: [
          // BAGIAN ATAS: SEARCH & GREETING
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFFEE4D2D),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Halo, Rafindra!",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Ada yang bisa kami bantu hari ini?",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Cari kendala (cth: lacak paket)",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ],
            ),
          ),

          // LIST KONTEN
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // MENU CEPAT (GRID)
                const Text("Bantuan Cepat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  childAspectRatio: 0.9,
                  children: [
                    _buildQuickMenu(Icons.lock_reset, "Reset PW", Colors.blue),
                    _buildQuickMenu(Icons.local_shipping, "Lacak", Colors.orange),
                    _buildQuickMenu(Icons.assignment_return, "Retur", Colors.red),
                    _buildQuickMenu(Icons.wallet, "Top Up", Colors.purple),
                  ],
                ),

                const SizedBox(height: 24),
                const Text("Kategori Masalah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // LOOPING DATABASE FAQ
                ..._faqDatabase.map((category) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEE4D2D).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(category['icon'], color: const Color(0xFFEE4D2D)),
                        ),
                        title: Text(
                          category['category'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        children: (category['items'] as List).map<Widget>((item) {
                          return Column(
                            children: [
                              Divider(height: 1, color: Colors.grey[200]),
                              ExpansionTile(
                                title: Text(
                                  item['q'],
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    color: Colors.grey[50],
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Text(
                                          item['a'],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.5),
                                        ),
                                        const SizedBox(height: 10),
                                        OutlinedButton.icon(
                                          onPressed: (){}, 
                                          icon: const Icon(Icons.thumb_up_alt_outlined, size: 14),
                                          label: const Text("Membantu", style: TextStyle(fontSize: 12)),
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(100, 30),
                                            foregroundColor: Colors.grey
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),
                
                // BANNER KONTAK CS
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFEE4D2D), Color(0xFFFF7337)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFEE4D2D).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.support_agent, color: Colors.white, size: 40),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Masih butuh bantuan?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text("Chat dengan Agen CS kami (24 Jam)", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menghubungkan ke Live Agent...")));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFEE4D2D),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("Chat Sekarang"),
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Center(child: Text("Versi Aplikasi 1.2.0 (Build 304)", style: TextStyle(color: Colors.grey[400], fontSize: 12))),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenu(IconData icon, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
