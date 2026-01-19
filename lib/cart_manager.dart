// cart_manager.dart

class CartManager {
  // Data Dummy Awal
  static List<CartItem> cartItems = [
    CartItem(
      shopName: "Saint Barkley Official",
      title: "St. Andrew Jersey White",
      price: 273600,
      quantity: 1,
      stockLeft: 3,
      variant: "XXL",
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHtRbMG12M-5bmUQ5OC6sBPNoreL4HDTi0GQ&s',
      selected: false,
    ),
    CartItem(
      shopName: "MILLS OFFICIAL Shop",
      title: "Mills Jersey USS Away",
      price: 274500,
      quantity: 1,
      stockLeft: 5,
      variant: "Black, XXL",
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYDgS_WeBSzaUTc4TWjIAbgvv3FaxloDDtvA&s',
      selected: false,
    ),
    CartItem(
      shopName: "MILLS OFFICIAL Shop",
      title: "MILLS COSMO JNE AWAY FUTSAL",
      price: 399000,
      quantity: 1,
      stockLeft: 3,
      variant: "WHITE, XXL",
      imagePath:
          'https://mills.co.id/cdn/shop/files/cosmo_jne_away_futsal_jersey_-_white_-_1470_20.png?v=1738381660',
      selected: false,
    ),
  ];

  // FUNGSI 1: Tambah ke Keranjang (Cek Stok & Duplikat)
  static void addToCart(CartItem item) {
    final existingIndex = cartItems.indexWhere((cartItem) =>
        cartItem.title == item.title && cartItem.variant == item.variant);

    if (existingIndex != -1) {
      int currentQty = cartItems[existingIndex].quantity;
      int maxStock = cartItems[existingIndex].stockLeft;

      if (currentQty + item.quantity <= maxStock) {
        cartItems[existingIndex].quantity += item.quantity;
      } else {
        cartItems[existingIndex].quantity = maxStock;
      }
    } else {
      cartItems.add(item);
    }
  }

  // FUNGSI 2: Hapus Barang (Single)
  static void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
  }

  // FUNGSI 3: Hapus Barang yang Dipilih (Bulk Delete)
  static void removeSelectedItems() {
    cartItems.removeWhere((item) => item.selected);
  }

  // FUNGSI 4: Hitung Total Harga Barang yang Dipilih
  static int get totalSelectedPrice {
    int total = 0;
    for (var item in cartItems) {
      if (item.selected) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  static void clearCart() {
    cartItems.clear();
  }
}

// ==========================================
// MODEL CART ITEM (Dipindah ke sini agar rapi)
// ==========================================
class CartItem {
  String shopName;
  String title;
  int price; 
  int quantity;
  int stockLeft;
  String variant;
  String imagePath;
  bool selected;

  CartItem({
    required this.shopName,
    required this.title,
    required this.price,
    this.quantity = 1,
    this.stockLeft = 9999,
    this.variant = '',
    this.imagePath = '',
    this.selected = false,
  });
}
