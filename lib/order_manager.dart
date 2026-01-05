import 'keranjang_page.dart';

class Order {
  String id;
  List<CartItem> items;
  String status; // Belum Bayar, Dikemas, Dikirim, Selesai, Pengembalian
  DateTime createdAt;
  int totalAmount;
  String address;
  String paymentMethod;
  String? returnStatus; // Dalam Proses, Sukses

  Order({
    required this.id,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    this.returnStatus,
  });
}

// Helper function to parse price string to int
int _parsePrice(String priceString) {
  // Remove "Rp" and dots, then parse
  return int.parse(
      priceString.replaceAll('Rp', '').replaceAll('.', '').replaceAll(',', ''));
}

class OrderManager {
  static List<Order> orders = [
    // Demo order for Dikemas - using products from home page
    Order(
      id: 'SP-001',
      items: [
        CartItem(
          title: 'Gantungan Kunci Kucing Lucu Imut',
          price: _parsePrice('Rp10.900'),
          quantity: 1,
          imagePath:
              'https://down-id.img.susercontent.com/file/id-11134207-7r98y-lv0nwoyrqbm58f',
          shopName: 'Toko Aksesoris Lucu',
          variant: 'S',
        ),
        CartItem(
          title: 'Sepatu Wanita Flat Shoes Pita',
          price: _parsePrice('Rp25.000'),
          quantity: 1,
          imagePath:
              'https://media.karousell.com/media/photos/products/2024/3/14/everbest__sepatu_flatshoes_wan_1710428889_41076601_progressive.jpg',
          shopName: 'Toko Sepatu Wanita',
          variant: '37',
        ),
      ],
      status: 'Dikemas',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      totalAmount: _parsePrice('Rp10.900') + _parsePrice('Rp25.000'),
      address: 'Jl. Sudirman No. 123, Jakarta',
      paymentMethod: 'Bayar di Tempat (COD)',
    ),
    // Demo order for Dikirim - using products from home page
    Order(
      id: 'SP-002',
      items: [
        CartItem(
          title: 'Case HP Samsung A50 Anti Crack',
          price: _parsePrice('Rp5.000'),
          quantity: 2,
          imagePath:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYLN2Idizgl-iqMyPzl_qXL5dE9-6sJnRQxA&s',
          shopName: 'Toko Aksesoris HP',
          variant: 'Universal',
        ),
        CartItem(
          title: 'Kemeja Flannel Pria Kotak-Kotak',
          price: _parsePrice('Rp89.000'),
          quantity: 1,
          imagePath:
              'https://img.lazcdn.com/g/p/2b26740520795b6cc4a47a247a30f2b4.jpg_720x720q80.jpg',
          shopName: 'Toko Pakaian Pria',
          variant: 'M',
        ),
      ],
      status: 'Dikirim',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      totalAmount: (_parsePrice('Rp5.000') * 2) + _parsePrice('Rp89.000'),
      address: 'Jl. Thamrin No. 456, Jakarta',
      paymentMethod: 'Transfer Bank BCA',
    ),
    // Demo order for Selesai - using products from home page
    Order(
      id: 'SP-003',
      items: [
        CartItem(
          title: 'Skin Care Paket Glowing Cepat',
          price: _parsePrice('Rp150.000'),
          quantity: 1,
          imagePath:
              'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//91/MTA-35202627/jglow_skincare_paket_glowing_jglow_super_skin_whitening_cream_krim_bpom_set_perawatan_pencerah_kulit_cream_pemutih_wajah_bpom_glowing_cepat_pembersih_muka_full01_gkkc6qbg.jpg',
          shopName: 'Toko Kecantikan',
          variant: 'Paket',
        ),
        CartItem(
          title: 'Mouse Gaming RGB Lampu Warni',
          price: _parsePrice('Rp75.000'),
          quantity: 1,
          imagePath:
              'https://img.lazcdn.com/g/p/56170666bb543c3ff219920fc8a05cc3.jpg_720x720q80.jpg',
          shopName: 'Toko Gaming',
          variant: 'Universal',
        ),
      ],
      status: 'Selesai',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      totalAmount: _parsePrice('Rp150.000') + _parsePrice('Rp75.000'),
      address: 'Jl. Gatot Subroto No. 789, Jakarta',
      paymentMethod: 'GoPay',
    ),
    // Demo order for Pengembalian - Dalam Proses - using products from home page
    Order(
      id: 'SP-004',
      items: [
        CartItem(
          title: 'Tas Ransel Sekolah',
          price: _parsePrice('Rp120.000'),
          quantity: 1,
          imagePath:
              'https://img.lazcdn.com/g/p/e519cea445c6839dec3352ef5a0f3dcc.jpg_720x720q80.jpg',
          shopName: 'Toko Tas Sekolah',
          variant: 'Standard',
        ),
      ],
      status: 'Pengembalian',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      totalAmount: _parsePrice('Rp120.000'),
      address: 'Jl. Malioboro No. 101, Yogyakarta',
      paymentMethod: 'DANA',
      returnStatus: 'Dalam Proses',
    ),
    // Demo order for Pengembalian - Sukses - using products from home page
    Order(
      id: 'SP-005',
      items: [
        CartItem(
          title: 'Botol Minum 2L',
          price: _parsePrice('Rp30.000'),
          quantity: 1,
          imagePath:
              'https://down-id.img.susercontent.com/file/sg-11134201-7qvef-lijs81976p7120',
          shopName: 'Toko Botol Minum',
          variant: '2L',
        ),
      ],
      status: 'Pengembalian',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      totalAmount: _parsePrice('Rp30.000'),
      address: 'Jl. Malioboro No. 102, Yogyakarta',
      paymentMethod: 'ShopeediaPay',
      returnStatus: 'Sukses',
    ),
  ];

  static void createOrder({
    required List<CartItem> selectedItems,
    required String address,
    required String paymentMethod,
  }) {
    final totalAmount = selectedItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
    final orderId = 'SP-${DateTime.now().millisecondsSinceEpoch}';

    final order = Order(
      id: orderId,
      items: List.from(selectedItems),
      status: 'Dikemas',
      createdAt: DateTime.now(),
      totalAmount: totalAmount,
      address: address,
      paymentMethod: paymentMethod,
    );

    orders.add(order);
  }

  static List<Order> getOrdersByStatus(String status) {
    return orders.where((order) => order.status == status).toList();
  }
}
