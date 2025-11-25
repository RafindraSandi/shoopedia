// home_page.dart
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color mainColor = const Color(0xFFEE4D2D); // warna utama (Shopeedia)
  int _selectedIndex = 0;

  // --- Banner images (termasuk file lokal yang kamu upload) ---
  final List<String> bannerImages = [
    // developer requested to include uploaded file path:
    '/mnt/data/WhatsApp Image 2025-11-25 at 11.28.21.jpeg',
    'https://via.placeholder.com/800x300?text=Promo+1',
    'https://via.placeholder.com/800x300?text=Promo+2',
  ];

  // --- Dummy categories/menu icons ---
  final List<Map<String, dynamic>> categories = [
    {"label": "Pulsa", "icon": Icons.phone_android},
    {"label": "Promo", "icon": Icons.local_offer},
    {"label": "VIP", "icon": Icons.workspace_premium},
    {"label": "Games", "icon": Icons.videogame_asset},
    {"label": "ShopeeFood", "icon": Icons.fastfood},
    {"label": "Voucher", "icon": Icons.card_giftcard},
    {"label": "Top-Up", "icon": Icons.payments},
    {"label": "Lainnya", "icon": Icons.more_horiz},
  ];

  // --- Flash sale items (horizontal) ---
  final List<Map<String, String>> flashItems = [
    {
      "name": "Smartwatch Keren",
      "price": "Rp199.000",
      "image": "https://via.placeholder.com/120"
    },
    {
      "name": "Headset Bluetooth",
      "price": "Rp79.000",
      "image": "https://via.placeholder.com/120"
    },
    {
      "name": "Powerbank 10k",
      "price": "Rp49.000",
      "image": "https://via.placeholder.com/120"
    },
    {
      "name": "Kaos Polo",
      "price": "Rp59.000",
      "image": "https://via.placeholder.com/120"
    },
  ];

  // --- Products (grid) ---
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
  ];

  // --- Carousel controller ---
  final PageController _pageController = PageController(viewportFraction: 0.95);
  int _currentBanner = 0;
  Timer? _bannerTimer;

  // --- Flash sale countdown (contoh countdown 1 jam dari saat buka halaman) ---
  late DateTime _flashEndTime;
  Timer? _countdownTimer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Banner auto-scroll setiap 4 detik
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int next = (_currentBanner + 1) % bannerImages.length;
        _pageController.animateToPage(next,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut);
      }
    });

    // Misal flash sale 1 jam dari sekarang:
    _flashEndTime = DateTime.now().add(const Duration(hours: 1));
    _updateCountdown();
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _updateCountdown() {
    final now = DateTime.now();
    setState(() {
      _timeLeft = _flashEndTime.difference(now);
      if (_timeLeft.isNegative) _timeLeft = Duration.zero;
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _countdownTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // helper: menampilkan image baik dari file lokal maupun network
  Widget buildImageWidget(String url,
      {BoxFit fit = BoxFit.cover, double? width, double? height}) {
    try {
      // Jika path lokal (dimulai dengan /mnt atau file://), gunakan File
      if (url.startsWith('/') || url.startsWith('file://')) {
        final path =
            url.startsWith('file://') ? url.replaceFirst('file://', '') : url;
        final file = io.File(path);
        if (file.existsSync()) {
          return Image.file(file, fit: fit, width: width, height: height);
        } else {
          // fallback ke placeholder kalau file tidak ada
          return Image.network(
              'https://via.placeholder.com/800x300?text=No+Image',
              fit: fit,
              width: width,
              height: height);
        }
      } else {
        return Image.network(url, fit: fit, width: width, height: height);
      }
    } catch (e) {
      return Image.network(
          'https://via.placeholder.com/800x300?text=Image+Error',
          fit: fit,
          width: width,
          height: height);
    }
  }

  String _formatDuration(Duration d) {
    if (d <= Duration.zero) return "00:00:00";
    int h = d.inHours;
    int m = d.inMinutes.remainder(60);
    int s = d.inSeconds.remainder(60);
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // pakai CustomScrollView supaya mudah gabungkan berbagai section
      body: CustomScrollView(
        slivers: [
          // Sliver AppBar (sticky, dengan search)
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
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.camera_alt_outlined,
                                    size: 20, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_cart_outlined,
                            color: mainColor),
                      ),
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

          // Banner carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentBanner = i),
                itemCount: bannerImages.length,
                itemBuilder: (context, index) {
                  final url = bannerImages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          buildImageWidget(url, fit: BoxFit.cover),
                          // overlay gradient for readability
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.15)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dots indicator for banner
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(bannerImages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  width: _currentBanner == i ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentBanner == i ? mainColor : Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
          ),

          // Categories (grid icons)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.only(top: 8),
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, idx) {
                  final cat = categories[idx];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO: kategori action
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(cat['icon'], color: mainColor),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(cat['label'], style: const TextStyle(fontSize: 12)),
                    ],
                  );
                },
              ),
            ),
          ),

          // Flash Sale section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('FLASH',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        const Text('Flash Sale',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(_formatDuration(_timeLeft),
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        final item = flashItems[i];
                        return Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 4)
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                child: Image.network(item['image']!,
                                    height: 90, width: 120, fit: BoxFit.cover),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name']!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(item['price']!,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, i) =>
                          const SizedBox(width: 8),
                      itemCount: flashItems.length,
                    ),
                  )
                ],
              ),
            ),
          ),

          // Live / Short Video section (horizontal)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Live & Video',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(4, (i) {
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://via.placeholder.com/320x180?text=Live+$i'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: const Text('LIVE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: const Text('52,6RB',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product grid (sliver)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    // TODO: navigasi ke detail
                  },
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
                        // image
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
                        // details
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

          // bottom padding so grid not hidden by BottomNavigationBar
          SliverToBoxAdapter(
            child: SizedBox(height: 68),
          )
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up), label: 'Trending'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notif'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Saya'),
        ],
      ),
    );
  }
}
