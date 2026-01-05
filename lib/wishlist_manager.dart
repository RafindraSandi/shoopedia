import 'pages/models/product.dart';

class WishlistManager {
  static List<Product> wishlistItems = [];

  static void addToWishlist(Product product) {
    // Check if product already exists in wishlist
    final existingIndex =
        wishlistItems.indexWhere((item) => item.name == product.name);

    if (existingIndex == -1) {
      // Add new item to wishlist
      wishlistItems.add(product);
    }
    // If item already exists, do nothing (no duplicates)
  }

  static void removeFromWishlist(String productName) {
    wishlistItems.removeWhere((item) => item.name == productName);
  }

  static bool isInWishlist(String productName) {
    return wishlistItems.any((item) => item.name == productName);
  }

  static void clearWishlist() {
    wishlistItems.clear();
  }
}
