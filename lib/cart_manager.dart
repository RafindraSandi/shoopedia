import 'keranjang_page.dart';

class CartManager {
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

  static void addToCart(CartItem item) {
    // Check if item already exists
    final existingIndex = cartItems.indexWhere((cartItem) =>
        cartItem.title == item.title && cartItem.variant == item.variant);

    if (existingIndex != -1) {
      // Item exists, increase quantity
      cartItems[existingIndex].quantity += item.quantity;
    } else {
      // Add new item
      cartItems.add(item);
    }
  }

  static void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
  }

  static void clearCart() {
    cartItems.clear();
  }
}
