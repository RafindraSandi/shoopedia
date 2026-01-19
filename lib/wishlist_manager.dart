import 'pages/models/product.dart';

class WishlistManager {
  // List static agar data tersimpan di memori selama aplikasi jalan
  static List<Product> wishlistItems = [];

  // FUNGSI 1: Tambah ke Wishlist (Cek duplikat dulu)
  static void addToWishlist(Product product) {
    bool exists = wishlistItems.any((item) => item.name == product.name);

    if (!exists) {
      wishlistItems.add(product);
    }
  }

  // FUNGSI 2: Hapus dari Wishlist berdasarkan objek Product
  static void removeFromWishlist(Product product) {
    wishlistItems.removeWhere((item) => item.name == product.name);
  }

  // FUNGSI 3: Cek apakah produk ada di wishlist (Return True/False)
  static bool isInWishlist(Product product) {
    return wishlistItems.any((item) => item.name == product.name);
  }

  // FUNGSI 4 (BARU): Toggle (Saklar)
  static bool toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      removeFromWishlist(product);
      return false; 
    } else {
      addToWishlist(product);
      return true; 
    }
  }

  // FUNGSI 5: Bersihkan semua
  static void clearWishlist() {
    wishlistItems.clear();
  }
}
