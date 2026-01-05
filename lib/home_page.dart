// home_page.dart
import 'dart:io' as io;
import 'package:flutter/material.dart';

// Pastikan file-file ini ada di project Anda
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

  // 1. TAMBAHKAN VARIABEL INI UNTUK MENAMPUNG TEKS PENCARIAN
  String _searchQuery = "";

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

  String _calculateDiscountedPrice(String originalPrice, String discount) {
    // Parse original price (remove 'Rp' and '.')
    final priceString = originalPrice.replaceAll('Rp', '').replaceAll('.', '');
    final price = int.parse(priceString);

    // Parse discount percentage (remove '%')
    final discountPercent = double.parse(discount.replaceAll('%', ''));

    // Calculate discounted price
    final discountAmount = price * (discountPercent / 100);
    final discountedPrice = price - discountAmount.toInt();

    // Format back to 'Rp xxx.xxx'
    final formattedPrice = discountedPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'Rp $formattedPrice';
  }

  Widget _getBody() {
    // Check if user is logged in (not using default username)
    if (UserManager.currentUser.username == "rafindrasandi123") {
      // Redirect to login if not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedIndex == 0) {
      // 2. LOGIKA FILTER PRODUK DISINI
      // Gabungkan produk default dengan produk dari seller
      final List<Product> allProducts = [
        ...ProductsData.products,
        ...UserManager.getAllSellerProducts(),
      ];

      // Kita buat list baru bernama filteredProducts berdasarkan _searchQuery
      final List<Product> filteredProducts = allProducts.where((item) {
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WishlistPage()),
                          );
                        },
                        icon: Icon(Icons.favorite_border, color: mainColor),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotificationPage()),
                          );
                        },
                        icon: Icon(Icons.notifications_none, color: mainColor),
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
                                    Expanded(
                                      child: product.discount != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.price,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  _calculateDiscountedPrice(
                                                      product.price,
                                                      product.discount!),
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              product.price,
                                              style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
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
