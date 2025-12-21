import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shoopedia/database_helper.dart'; 
import 'pages/notification_page.dart';
import 'pages/wishlist_page.dart';     
import 'keranjang_page.dart';
import 'profil_page.dart';
import 'pages/chat_list_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/models/product.dart'; 
import 'pages/shop_bot_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color mainColor = const Color(0xFFEE4D2D);
  int _selectedIndex = 0;
  String _searchQuery = "";

  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductsFromDB();
  }

  // Ambil Data Produk dari DB Lokal
  Future<void> _loadProductsFromDB() async {
    final dataList = await DatabaseHelper.instance.getAllProducts();
    
    if (mounted) {
      setState(() {
        products = dataList.map((item) {
          List<String> sizesList = [];
          if (item['sizes'] != null) {
            try {
               sizesList = List<String>.from(jsonDecode(item['sizes']));
            } catch(e) {
               sizesList = ["Standard"];
            }
          }

          return Product(
            name: item['name'],
            price: item['price'],
            sold: item['sold'] ?? '',
            image: item['image'],
            description: item['description'],
            sizes: sizesList,
            discount: item['discount'] == 'null' ? null : item['discount'],
          );
        }).toList();
        
        isLoading = false;
      });
    }
  }

  Widget buildImageWidget(String url) {
    // Sederhana: gunakan network image
    return Image.network(
      url, 
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
         return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
      },
    );
  }

  Widget _getBody() {
    if (_selectedIndex == 0) {
      final List<Product> filteredProducts = products.where((item) {
        final nameLower = item.name.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();

      return CustomScrollView(
        slivers: [
          // AppBar Pencarian
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            expandedHeight: 80,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: mainColor.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(Icons.search, color: mainColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) => setState(() => _searchQuery = value),
                                  decoration: InputDecoration(
                                    hintText: 'Cari produk...',
                                    hintStyle: TextStyle(color: mainColor.withOpacity(0.9)),
                                    border: InputBorder.none,
                                  ),
                                  
                                  const SizedBox(width: 8),

                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage()));
                                    },
                                    icon: Icon(Icons.notifications_none, color: mainColor),
                                  ),
            
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistPage()));
                                    },
                                    icon: Icon(Icons.favorite_border, color: mainColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KeranjangPage())),
                        icon: Icon(Icons.shopping_cart_outlined, color: mainColor),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatListPage())),
                        icon: Icon(Icons.chat_bubble_outline, color: mainColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Grid Produk
          if (isLoading)
             const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (filteredProducts.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.search_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text("Produk tidak ditemukan", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 3)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    buildImageWidget(product.image),
                                    if (product.discount != null)
                                      Positioned(
                                        top: 6, right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.yellow[700], borderRadius: BorderRadius.circular(4)),
                                          child: Text(product.discount!, style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 11)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                                  const SizedBox(height: 6),
                                  Text(product.price, style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
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
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
              ),
            ),
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
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShopBotPage()),
          );
        },
        backgroundColor: const Color(0xFFEE4D2D), // Warna Oranye Shopee
        elevation: 4,
        tooltip: 'Tanya Shop Bot',
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 28),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
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


