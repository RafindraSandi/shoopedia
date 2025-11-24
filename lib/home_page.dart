import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Untuk mengatur menu bawah yang aktif

  // Dummy Data Produk (Pura-pura data dari server)
  final List<Map<String, dynamic>> products = [
    {
      "name": "Gantungan Kunci Kucing Lucu Imut",
      "price": "Rp10.900",
      "sold": "10RB+ terjual",
      "image": "https://via.placeholder.com/150", // Nanti ganti dengan url gambar asli
      "discount": "50%"
    },
    {
      "name": "Sepatu Wanita Flat Shoes Pita",
      "price": "Rp25.000",
      "sold": "5RB+ terjual",
      "image": "https://via.placeholder.com/150",
      "discount": "10%"
    },
    {
      "name": "Case HP Samsung A50 Anti Crack",
      "price": "Rp5.000",
      "sold": "1RB+ terjual",
      "image": "https://via.placeholder.com/150",
      "discount": null
    },
    {
      "name": "Kemeja Flannel Pria Kotak-Kotak",
      "price": "Rp89.000",
      "sold": "200+ terjual",
      "image": "https://via.placeholder.com/150",
      "discount": "25%"
    },
     {
      "name": "Skin Care Paket Glowing Cepat",
      "price": "Rp150.000",
      "sold": "10RB+ terjual",
      "image": "https://via.placeholder.com/150",
      "discount": "60%"
    },
     {
      "name": "Mouse Gaming RGB Lampu Warni",
      "price": "Rp75.000",
      "sold": "1RB+ terjual",
      "image": "https://via.placeholder.com/150",
      "discount": "5%"
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFFEE4D2D); // Warna Oranye Shopee

    return Scaffold(
      backgroundColor: Colors.grey[100], // Background agak abu supaya produk menonjol
      
      // BAGIAN 1: CUSTOM APP BAR (Search, Cart, Chat)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0, // Mengurangi jarak default kiri
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: mainColor), // Border oren tipis
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: mainColor),
                hintText: "HP Murah RAM 8", // Sesuai gambar
                hintStyle: const TextStyle(color: mainColor, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                suffixIcon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: mainColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: mainColor),
            onPressed: () {},
          ),
          const SizedBox(width: 5),
        ],
      ),

      // BAGIAN 2: DAFTAR PRODUK (GRID)
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 Kolom ke samping
            childAspectRatio: 0.75, // Mengatur tinggi kartu (makin kecil makin tinggi)
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Produk
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Placeholder warna abu
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                        image: DecorationImage(
                          image: NetworkImage(product['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Label Diskon (Opsional)
                      child: product['discount'] != null ? Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          color: Colors.yellow,
                          child: Text(
                            product['discount'], 
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mainColor)
                          ),
                        ),
                      ) : null,
                    ),
                  ),
                  
                  // Detail Produk
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        const SizedBox(height: 5),
                        // Label "Bebas Pengembalian" / Lainnya (Opsional)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor),
                            borderRadius: BorderRadius.circular(2)
                          ),
                          child: const Text("Pasti Ori", style: TextStyle(fontSize: 8, color: mainColor)),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['price'],
                              style: const TextStyle(
                                fontSize: 14, 
                                color: mainColor, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              product['sold'],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // BAGIAN 3: NAVIGASI BAWAH (BOTTOM BAR)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Wajib fixed karena item > 3
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_outlined),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Saya',
          ),
        ],
      ),
    );
  }
}