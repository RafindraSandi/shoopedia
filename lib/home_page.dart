// home_page.dart
import 'dart:io' as io;
import 'package:flutter/material.dart';

// Pastikan file-file ini ada di project Anda
import 'keranjang_page.dart';
import 'profil_page.dart';
import 'pages/chat_list_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color mainColor = const Color(0xFFEE4D2D);
  int _selectedIndex = 0;

  // 1. TAMBAHKAN VARIABEL INI UNTUK MENAMPUNG TEKS PENCARIAN
  String _searchQuery = "";

  final List<Product> products = [
    Product(
        name: "Gantungan Kunci Kucing Lucu Imut",
        price: "Rp10.900",
        sold: "10RB+ terjual",
        image:
            "https://down-id.img.susercontent.com/file/id-11134207-7r98y-lv0nwoyrqbm58f",
        description:
            "Gantungan kunci kucing lucu dengan desain imut dan menggemaskan. Cocok untuk hiasan tas atau kunci rumah.",
        sizes: ["S", "M", "L"],
        discount: "50%"),
    Product(
        name: "Sepatu Wanita Flat Shoes Pita",
        price: "Rp25.000",
        sold: "5RB+ terjual",
        image:
            "https://media.karousell.com/media/photos/products/2024/3/14/everbest__sepatu_flatshoes_wan_1710428889_41076601_progressive.jpg",
        description:
            "Sepatu flat shoes wanita dengan pita cantik. Nyaman digunakan untuk sehari-hari.",
        sizes: ["36", "37", "38", "39", "40"],
        discount: "10%"),
    Product(
      name: "Case HP Samsung A50 Anti Crack",
      price: "Rp5.000",
      sold: "1RB+ terjual",
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYLN2Idizgl-iqMyPzl_qXL5dE9-6sJnRQxA&s",
      description:
          "Case HP Samsung A50 anti crack dengan desain transparan. Melindungi HP dari benturan.",
      sizes: ["Universal"],
    ),
    Product(
        name: "Kemeja Flannel Pria Kotak-Kotak",
        price: "Rp89.000",
        sold: "200+ terjual",
        image:
            "https://img.lazcdn.com/g/p/2b26740520795b6cc4a47a247a30f2b4.jpg_720x720q80.jpg",
        description:
            "Kemeja flannel pria dengan motif kotak-kotak. Bahan nyaman dan cocok untuk casual.",
        sizes: ["S", "M", "L", "XL"],
        discount: "25%"),
    Product(
        name: "Skin Care Paket Glowing Cepat",
        price: "Rp150.000",
        sold: "10RB+ terjual",
        image:
            "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//91/MTA-35202627/jglow_skincare_paket_glowing_jglow_super_skin_whitening_cream_krim_bpom_set_perawatan_pencerah_kulit_cream_pemutih_wajah_bpom_glowing_cepat_pembersih_muka_full01_gkkc6qbg.jpg",
        description:
            "Paket skin care lengkap untuk kulit glowing cepat. Mengandung vitamin dan antioksidan.",
        sizes: ["Paket"],
        discount: "60%"),
    Product(
        name: "Mouse Gaming RGB Lampu Warni",
        price: "Rp75.000",
        sold: "1RB+ terjual",
        image:
            "https://img.lazcdn.com/g/p/56170666bb543c3ff219920fc8a05cc3.jpg_720x720q80.jpg",
        description:
            "Mouse gaming dengan lampu RGB yang dapat di-custom. Presisi tinggi untuk gaming.",
        sizes: ["Universal"],
        discount: "5%"),
    Product(
        name: "Tas Ransel Sekolah",
        price: "Rp120.000",
        sold: "100+ terjual",
        image:
            "https://img.lazcdn.com/g/p/e519cea445c6839dec3352ef5a0f3dcc.jpg_720x720q80.jpg",
        description:
            "Tas ransel sekolah dengan banyak kantong. Nyaman untuk membawa buku dan alat tulis.",
        sizes: ["Standard"],
        discount: "15%"),
    Product(
      name: "Botol Minum 2L",
      price: "Rp30.000",
      sold: "2RB+ terjual",
      image:
          "https://down-id.img.susercontent.com/file/sg-11134201-7qvef-lijs81976p7120",
      description:
          "Botol minum berkapasitas 2L dengan desain modern. Cocok untuk olahraga dan sehari-hari.",
      sizes: ["2L"],
    ),
  ];

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
            height: height,
          );
        }
      } else {
        return Image.network(url, fit: fit, width: width, height: height);
      }
    } catch (e) {
      return Image.network(
        'https://via.placeholder.com/300?text=Image+Error',
        fit: fit,
        width: width,
        height: height,
      );
    }
  }

  Widget _getBody() {
    if (_selectedIndex == 0) {
      // 2. LOGIKA FILTER PRODUK DISINI
      // Kita buat list baru bernama filteredProducts berdasarkan _searchQuery
      final List<Product> filteredProducts = products.where((item) {
        final nameLower = item.name.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();

      return CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            expandedHeight: 80,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: mainColor.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(Icons.search, color: mainColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  // 3. UPDATE _searchQuery SAAT MENGETIK
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Cari produk...',
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatListPage()),
                          );
                        },
                        icon: Icon(Icons.chat_bubble_outline, color: mainColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. JIKA HASIL PENCARIAN KOSONG
          if (filteredProducts.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text("Produk tidak ditemukan",
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
            ),

          // 5. GRID PRODUK (Gunakan filteredProducts)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Gunakan filteredProducts, bukan products
                  final product = filteredProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.06),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  buildImageWidget(product.image),
                                  if (product.discount != null)
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
                                        child: Text(
                                          product.discount!,
                                          style: TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      product.price,
                                      style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      product.sold,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount:
                    filteredProducts.length, // Gunakan panjang hasil filter
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 68)),
        ],
      );
    }

    return const ShopeediaProfilePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (i) {
          setState(() => _selectedIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Saya"),
        ],
      ),
    );
  }
}
