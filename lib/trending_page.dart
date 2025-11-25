// trending_page.dart
import 'dart:io' as io;
import 'package:flutter/material.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> with TickerProviderStateMixin {
  final Color mainColor = const Color(0xFFEE4D2D);
  int _selectedIndex = 1;

  // GlobalKey untuk posisi ikon cart (dipakai untuk animasi terbang)
  final GlobalKey _cartIconKey = GlobalKey();

  // contoh produk (pakai beberapa gambar lokal dari upload)
  final List<Map<String, dynamic>> trendingProducts = [
    {
      "title": "Giordano 3D Lion Polo",
      "price": "Rp153.000",
      "original": "Rp375.000",
      "discount": "-59%",
      "rating": 4.9,
      "sold": "1RB+",
      "image": "/mnt/data/WhatsApp Image 2025-11-25 at 11.58.24.jpeg",
      "isMall": true,
      "isOriginal": true,
    },
    {
      "title": "Transworld Celana Chino",
      "price": "Rp139.920",
      "original": "Rp349.000",
      "discount": "-59%",
      "rating": 4.8,
      "sold": "800+",
      "image": "/mnt/data/WhatsApp Image 2025-11-25 at 11.58.25.jpeg",
      "isMall": true,
      "isOriginal": true,
    },
    {
      "title": "BRTWL Hoodie Boxy Tiger",
      "price": "Rp243.750",
      "original": "Rp359.000",
      "discount": "-32%",
      "rating": 4.9,
      "sold": "156",
      "image": "/mnt/data/WhatsApp Image 2025-11-25 at 11.58.25.jpeg",
      "isMall": false,
      "isOriginal": false,
    },
    {
      "title": "Pierre Cardin Bra & Set",
      "price": "Rp137.192",
      "original": "Rp161.000",
      "discount": "-15%",
      "rating": 5.0,
      "sold": "2RB+",
      "image": "https://via.placeholder.com/400x400?text=Pierre+Cardin",
      "isMall": true,
      "isOriginal": false,
    },
    // tambahkan lebih banyak item sesuai kebutuhan...
  ];

  // jumlah item di keranjang
  int cartCount = 0;

  // helper: load local file or fallback to network placeholder
  Widget _imageFromPath(String path, {BoxFit fit = BoxFit.cover}) {
    try {
      if (path.startsWith('/') || path.startsWith('file://')) {
        final filePath = path.startsWith('file://') ? path.replaceFirst('file://', '') : path;
        final file = io.File(filePath);
        if (file.existsSync()) {
          return Image.file(file, fit: fit);
        } else {
          return Image.network('https://via.placeholder.com/400x400?text=No+Image', fit: fit);
        }
      } else {
        return Image.network(path, fit: fit);
      }
    } catch (e) {
      return Image.network('https://via.placeholder.com/400x400?text=Error', fit: fit);
    }
  }

  // buat animasi gambar terbang ke ikon keranjang
  Future<void> _runAddToCartAnimation(GlobalKey imageKey) async {
    // dapatkan RenderBox image dan cart
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final renderImage = imageKey.currentContext?.findRenderObject() as RenderBox?;
    final renderCart = _cartIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderImage == null || renderCart == null) {
      // fallback: hanya naikkan counter tanpa animasi
      setState(() => cartCount++);
      return;
    }

    final imagePos = renderImage.localToGlobal(Offset.zero);
    final imageSize = renderImage.size;
    final cartPos = renderCart.localToGlobal(Offset.zero);
    final cartSize = renderCart.size;

    // create overlay entry with animated positioned image
    final animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    final curved = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    final topTween = Tween<double>(begin: imagePos.dy, end: cartPos.dy + cartSize.height / 2 - (imageSize.height * 0.15));
    final leftTween = Tween<double>(begin: imagePos.dx, end: cartPos.dx + cartSize.width / 2 - (imageSize.width * 0.15));
    final sizeTween = Tween<double>(begin: imageSize.width, end: imageSize.width * 0.3);

    OverlayEntry? entry;
    entry = OverlayEntry(builder: (context) {
      return AnimatedBuilder(
        animation: curved,
        builder: (context, child) {
          final t = curved.value;
          final top = topTween.evaluate(curved);
          final left = leftTween.evaluate(curved);
          final size = sizeTween.evaluate(curved);
          final opacity = (1.0 - t).clamp(0.0, 1.0);
          return Positioned(
            top: top,
            left: left,
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: size,
                height: size,
                child: child,
              ),
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: (imageKey.currentWidget is _ProductImageWrapper)
                ? (_imageFromPath((imageKey.currentWidget as _ProductImageWrapper).imgPath))
                : Container(color: Colors.grey),
          ),
        ),
      );
    });

    overlay.insert(entry);
    await animationController.forward();
    animationController.dispose();
    entry.remove();

    // animasi selesai -> tambah cart count dengan efek bounce di ikon cart
    setState(() => cartCount++);

    // small cart bounce using a temporary controller + setState to redraw (we'll keep it simple)
    // alternatif: tambahkan animation pada icon sendiri (untuk kesederhanaan kita hanya rebuild -> badge muncul)
  }

  // widget kartu produk yang presisi
  Widget _buildProductCard(Map<String, dynamic> item) {
    // key untuk image widget (dipakai animasi terbang)
    final GlobalKey imageKey = GlobalKey();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.grey.shade200.withOpacity(0.25), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Stack(
              children: [
                // wrapper custom agar dapat diakses widgetnya untuk animasi
                _ProductImageWrapper(
                  key: imageKey,
                  imgPath: item['image'] as String,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: SizedBox.expand(child: _imageFromPath(item['image'] as String, fit: BoxFit.cover)),
                  ),
                ),
                // top-left badges
                Positioned(
                  left: 6,
                  top: 6,
                  child: Row(
                    children: [
                      if (item['isMall'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                          child: Text("Mall", style: TextStyle(color: mainColor, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      if (item['isOriginal'] == true) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                          child: const Text("ORI", style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ]
                    ],
                  ),
                ),
                // small "more" button top-right
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                    child: IconButton(
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.more_horiz, size: 18, color: Colors.grey[700]),
                      onPressed: () {
                        // TODO: show product menu
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // content area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(item['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 6),
                // rating + sold
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: Colors.yellow.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(item['rating'].toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(item['sold'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    // dummy lokasi icon or similar
                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[400]),
                  ],
                ),
                const SizedBox(height: 8),
                // price row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(item['price'], style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(width: 8),
                    if (item['original'] != null)
                      Text(item['original'], style: const TextStyle(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                    const Spacer(),
                    if (item['discount'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text(item['discount'], style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // action row: tombol add to cart + chat/touch
                Row(
                  children: [
                    // tombol chat kecil
                    InkWell(
                      onTap: () {
                        // chat action
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.chat_bubble_outline, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // tombol add to cart dengan animasi scale
                    Expanded(
                      child: _AddToCartButton(
                        onPressed: () async {
                          // play scale animation inside button (handled by _AddToCartButton)
                          // jalankan animasi terbang pake key imageKey
                          await _runAddToCartAnimation(imageKey);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // header bar mirip sebelumnya
  Widget _buildTopBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0.6,
      expandedHeight: 70,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                Text("TRENDING", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Expanded(child: TextField(decoration: InputDecoration(hintText: "Cari produk, toko ...", border: InputBorder.none))),
                        Icon(Icons.shopping_cart_outlined, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // cart icon with badge -> use key for animation target
                Container(
                  key: _cartIconKey,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 28),
                      if (cartCount > 0)
                        Positioned(
                          right: -8,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                            child: Text(cartCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = trendingProducts[index];
          return _buildProductCard(product);
        }, childCount: trendingProducts.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.66,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: mainColor,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (i) {
        setState(() {
          _selectedIndex = i;
        });
      },
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: _buildCartIconWithBadge(), label: 'Trending'),
        const BottomNavigationBarItem(icon: Icon(Icons.live_tv_outlined), label: 'Live'),
        const BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Notifikasi'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Saya'),
      ],
    );
  }

  // icon cart kecil untuk bottom nav (dengan badge)
  Widget _buildCartIconWithBadge() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.local_fire_department),
        if (cartCount > 0)
          Positioned(
            right: -10,
            top: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
              child: Text(cartCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildTopBar(),
          // small header badges
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  _smallBadge(Icons.fiber_new, "Baru Setiap Hari"),
                  const SizedBox(width: 8),
                  _smallBadge(Icons.local_shipping_outlined, "Gratis Ongkir"),
                ],
              ),
            ),
          ),
          // top promo card (mirip screenshot)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Container(
                height: 120,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                          Text("HANYA DI SHOPEE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text("Koleksi Baru Diskon 50RB", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text("Praktis dan Terbaru", style: TextStyle(color: Colors.grey)),
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                        child: _imageFromPath('/mnt/data/WhatsApp Image 2025-11-25 at 11.58.25.jpeg', fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildTrendingGrid(),
          SliverToBoxAdapter(child: SizedBox(height: 84)),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _smallBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [Icon(icon, size: 16, color: Colors.grey[700]), const SizedBox(width: 6), Text(text)]),
    );
  }
}

// ==================================================
// Small helper widgets below
// ==================================================

// Wrapper widget used only to expose the image path on the widget tree so the overlay can grab it.
// We intentionally keep it simple. This allows the overlay animation to access the underlying image path.
class _ProductImageWrapper extends StatefulWidget {
  final String imgPath;
  final Widget child;
  const _ProductImageWrapper({super.key, required this.imgPath, required this.child});

  @override
  State<_ProductImageWrapper> createState() => _ProductImageWrapperState();
}

class _ProductImageWrapperState extends State<_ProductImageWrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Add to cart button with built-in scale (bounce) animation
class _AddToCartButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  const _AddToCartButton({required this.onPressed});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _scaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await _controller.forward();
    await _controller.reverse();
    await widget.onPressed();
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _handleTap,
        child: _isProcessing ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_shopping_cart_outlined, size: 16),
            SizedBox(width: 6),
            Text("Tambah", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
