// home_page.dart
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'keranjang_page.dart'; // Import halaman keranjang

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color mainColor = const Color(0xFFEE4D2D); // warna utama
  int _selectedIndex = 0;

  // --- HANYA DATA PRODUK YANG TERSISA ---
  final List<Map<String, dynamic>> products = [
    {
      "name": "Gantungan Kunci Kucing Lucu Imut",
      "price": "Rp10.900",
      "sold": "10RB+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": "50%"
    },
    {
      "name": "Sepatu Wanita Flat Shoes Pita",
      "price": "Rp25.000",
      "sold": "5RB+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": "10%"
    },
    {
      "name": "Case HP Samsung A50 Anti Crack",
      "price": "Rp5.000",
      "sold": "1RB+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": null
    },
    {
      "name": "Kemeja Flannel Pria Kotak-Kotak",
      "price": "Rp89.000",
      "sold": "200+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": "25%"
    },
    {
      "name": "Skin Care Paket Glowing Cepat",
      "price": "Rp150.000",
      "sold": "10RB+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": "60%"
    },
    {
      "name": "Mouse Gaming RGB Lampu Warni",
      "price": "Rp75.000",
      "sold": "1RB+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": "5%"
    },
    // Tambahkan produk dummy lagi biar terlihat banyak
    {
      "name": "Tas Ransel Sekolah",
      "price": "Rp120.000",
      "sold": "100+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": "15%"
    },
    {
      "name": "Botol Minum 2L",
      "price": "Rp30.000",
      "sold": "2RB+ terjual",
      "image": "https://via.placeholder.com/300",
      "discount": null
    },
  ];

  // Helper: menampilkan image (tetap dipakai untuk produk)
  Widget buildImageWidget(String url,
      {BoxFit fit = BoxFit.cover, double? width, double? height}) {
    try {
      if (url.startsWith('/') || url.startsWith('file://')) {
        final path =
            url.startsWith('file://') ? url.replaceFirst('file://', '') : url;
        final file = io.File(path);
        if (file.existsSync()) {
          return Image.file(file, fit: fit, width: width, height: height);
        } else {
          return Image.network(
              'https://via.placeholder.com/300?text=No+Image',
              fit: fit,
              width: width,
              height: height);
        }
      } else {
        return Image.network(url, fit: fit, width: width, height: height);
      }
    } catch (e) {
      return Image.network(
          'https://via.placeholder.com/300?text=Image+Error',
          fit: fit,
          width: width,
          height: height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: CustomScrollView(
        slivers: [
          // 1. NAVBAR (APP BAR)
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.5,
            expandedHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: mainColor.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(Icons.search, color: mainColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText:
                                        'Cari produk, toko, atau kategori',
                                    hintStyle: TextStyle(
                                        color: mainColor.withOpacity(0.9)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tombol Keranjang
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const KeranjangPage()),
                          );
                        },
                        icon: Icon(Icons.shopping_cart_outlined,
                            color: mainColor),
                      ),
                      // Tombol Chat
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.chat_bubble_outline, color: mainColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. PRODUK (GRID) - Langsung muncul setelah Navbar
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.06), blurRadius: 3)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Produk
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                buildImageWidget(product['image']),
                                if (product['discount'] != null)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[700],
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(product['discount'],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Detail Produk (Nama, Harga, Terjual)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['name'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(product['price'],
                                      style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  Text(product['sold'],
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }, childCount: products.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
            ),
          ),

          // Spasi bawah agar grid paling bawah tidak tertutup footer
          SliverToBoxAdapter(
            child: SizedBox(height: 68),
          )
        ],
      ),

      // 3. FOOTER (NAVIGASI BAWAH)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Saya'),
        ],
      ),
    );
  }
}
