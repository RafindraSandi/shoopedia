import 'pages/models/product.dart';

class WishlistManager {
  // List static agar data tersimpan di memori selama aplikasi jalan
  static List<Product> wishlistItems = [];

  // FUNGSI 1: Tambah ke Wishlist (Cek duplikat dulu)
  static void addToWishlist(Product product) {
    // Cek apakah produk dengan nama yang sama sudah ada?
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
  // Berguna untuk mengubah warna Icon Love (Merah/Abu)
  static bool isInWishlist(Product product) {
    return wishlistItems.any((item) => item.name == product.name);
  }

  // FUNGSI 4 (BARU): Toggle (Saklar)
  // Kalau ada dihapus, kalau gak ada ditambah.
  // Return true jika akhirnya ditambah, false jika dihapus.
  static bool toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      removeFromWishlist(product);
      return false; // Sekarang jadi tidak ada (Dihapus)
    } else {
      addToWishlist(product);
      return true; // Sekarang jadi ada (Ditambah)
    }
  }

  // FUNGSI 5: Bersihkan semua
  static void clearWishlist() {
    wishlistItems.clear();
  }
}
