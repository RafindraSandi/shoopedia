// home_page.dart
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // PENTING: Tambahkan ini di pubspec.yaml jika belum ada

import 'keranjang_page.dart';
import 'profil_page.dart';
import 'login_page.dart';
import 'pages/chat_list_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/models/product.dart';
import 'pages/whistlist_page.dart';
import 'pages/notification_page.dart';
import 'pages/shop_bot_page.dart';
import 'products_data.dart';
import 'user_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color mainColor = const Color(0xFFEE4D2D);
  int _selectedIndex = 0;
  String _searchQuery = "";

  // Formatter untuk mengubah angka 10000 menjadi "Rp10.000"
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  Widget buildImageWidget(String url,
      {BoxFit fit = BoxFit.cover, double? width, double? height}) {
    try {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return Image.network(url, fit: fit, width: width, height: height);
      } else {
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

  // UPDATE: Menghitung harga diskon dari Integer
  String _calculateDiscountedPrice(int originalPrice, int discountPercent) {
    double discountAmount = originalPrice * (discountPercent / 100);
    int finalPrice = originalPrice - discountAmount.toInt();
    return currencyFormatter.format(finalPrice);
  }

  Widget _getBody() {
    // Cek Login dummy
    if (UserManager.currentUser.username == "rafindrasandi123") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedIndex == 0) {
      // Gabungkan produk data asli + produk seller
      final List<Product> allProducts = [
        ...ProductsData.products,
        ...UserManager.getAllSellerProducts(),
      ];

      // Filter Pencarian
      final List<Product> filteredProducts = allProducts.where((item) {
        final nameLower = item.name.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();

      return CustomScrollView(
        slivers: [
          // --- APP BAR & SEARCH ---
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
                      // ICONS
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const KeranjangPage())),
                        icon: Icon(Icons.shopping_cart_outlined,
                            color: mainColor),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatListPage())),
                        icon: Icon(Icons.chat_bubble_outline, color: mainColor),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WishlistPage())),
                        icon: Icon(Icons.favorite_border, color: mainColor),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationPage())),
                        icon:
                            Icon(Icons.notifications_none, color: mainColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- SEARCH EMPTY STATE ---
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

          // --- PRODUCT GRID ---
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                          // GAMBAR PRODUK
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  buildImageWidget(product.image),
                                  // LABEL DISKON (Cek jika diskon > 0)
                                  if (product.discount > 0)
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
                                          "${product.discount}%", // Tampilkan %
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
                          // INFO PRODUK
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
                                
                                // LOGIKA HARGA (Diskon vs Normal)
                                if (product.discount > 0)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Harga Coret
                                      Text(
                                        currencyFormatter.format(product.price),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      // Harga Diskon
                                      Text(
                                        _calculateDiscountedPrice(product.price,
                                            product.discount),
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  // Harga Normal
                                  Text(
                                    currencyFormatter.format(product.price),
                                    style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  
                                const SizedBox(height: 4),
                                Text(
                                  product.sold,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: filteredProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 68)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShopBotPage()),
          );
        },
        backgroundColor: mainColor,
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Saya"),
        ],
      ),
    );
  }
}
