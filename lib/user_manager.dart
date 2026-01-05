import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/models/product.dart';

class User {
  String username;
  String fullName;
  String email;
  String phone;
  String bio;
  String? profileImagePath;
  bool isSeller;
  String? storeName;
  String? storeDescription;
  List<Product>? storeProducts;

  User({
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.bio,
    this.profileImagePath,
    this.isSeller = false,
    this.storeName,
    this.storeDescription,
    this.storeProducts,
  });

  // Convert User to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'bio': bio,
      'profileImagePath': profileImagePath,
      'isSeller': isSeller,
      'storeName': storeName,
      'storeDescription': storeDescription,
      'storeProducts':
          storeProducts?.map((product) => product.toMap()).toList(),
    };
  }

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      bio: map['bio'] ?? '',
      profileImagePath: map['profileImagePath'],
      isSeller: map['isSeller'] ?? false,
      storeName: map['storeName'],
      storeDescription: map['storeDescription'],
      storeProducts: map['storeProducts'] != null
          ? List<Product>.from(
              map['storeProducts'].map((x) => Product.fromMap(x)))
          : null,
    );
  }
}

class UserManager {
  static User _currentUser = User(
    username: 'rafindrasandi123',
    fullName: 'Rafindra Sandi',
    email: 'rafindra@example.com',
    phone: '081234567890',
    bio: 'Pelanggan setia Shoopedia',
  );

  static User get currentUser => _currentUser;

  // Load user data from shared preferences
  static Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      try {
        final userMap = json.decode(userData) as Map<String, dynamic>;
        _currentUser = User.fromMap(userMap);
      } catch (e) {
        // If loading fails, keep default user
        print('Error loading user data: $e');
      }
    }
  }

  // Save user data to shared preferences
  static Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(_currentUser.toMap());
    await prefs.setString('user_data', userData);
  }

  // Update user profile
  static void updateProfile({
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? bio,
    String? profileImagePath,
  }) {
    _currentUser = User(
      username: username ?? _currentUser.username,
      fullName: fullName ?? _currentUser.fullName,
      email: email ?? _currentUser.email,
      phone: phone ?? _currentUser.phone,
      bio: bio ?? _currentUser.bio,
      profileImagePath: profileImagePath ?? _currentUser.profileImagePath,
      isSeller: _currentUser.isSeller,
      storeName: _currentUser.storeName,
      storeDescription: _currentUser.storeDescription,
      storeProducts: _currentUser.storeProducts,
    );
    saveUserData();
  }

  static void setCurrentUser(String username) {
    _currentUser = User(
      username: username,
      fullName: _currentUser.fullName,
      email: _currentUser.email,
      phone: _currentUser.phone,
      bio: _currentUser.bio,
      profileImagePath: _currentUser.profileImagePath,
      isSeller: _currentUser.isSeller,
      storeName: _currentUser.storeName,
      storeDescription: _currentUser.storeDescription,
      storeProducts: _currentUser.storeProducts,
    );
  }

  static void setCurrentUserFromMap(Map<String, dynamic> userMap) {
    _currentUser = User.fromMap(userMap);
    saveUserData();
  }

  static void becomeSeller(String storeName, String storeDescription) {
    _currentUser = User(
      username: _currentUser.username,
      fullName: _currentUser.fullName,
      email: _currentUser.email,
      phone: _currentUser.phone,
      bio: _currentUser.bio,
      profileImagePath: _currentUser.profileImagePath,
      isSeller: true,
      storeName: storeName,
      storeDescription: storeDescription,
      storeProducts: _currentUser.storeProducts ?? [],
    );
    saveUserData();
  }

  static void setSellerStatus(bool isSeller) {
    _currentUser = User(
      username: _currentUser.username,
      fullName: _currentUser.fullName,
      email: _currentUser.email,
      phone: _currentUser.phone,
      bio: _currentUser.bio,
      profileImagePath: _currentUser.profileImagePath,
      isSeller: isSeller,
      storeName: _currentUser.storeName,
      storeDescription: _currentUser.storeDescription,
      storeProducts: _currentUser.storeProducts,
    );
    saveUserData();
  }

  static void addProductToStore(Product product) {
    if (_currentUser.isSeller) {
      List<Product> updatedProducts =
          List.from(_currentUser.storeProducts ?? []);
      updatedProducts.add(product);
      _currentUser = User(
        username: _currentUser.username,
        fullName: _currentUser.fullName,
        email: _currentUser.email,
        phone: _currentUser.phone,
        bio: _currentUser.bio,
        profileImagePath: _currentUser.profileImagePath,
        isSeller: true,
        storeName: _currentUser.storeName,
        storeDescription: _currentUser.storeDescription,
        storeProducts: updatedProducts,
      );
      saveUserData();
    }
  }

  static void updateProductInStore(int index, Product updatedProduct) {
    if (_currentUser.isSeller &&
        _currentUser.storeProducts != null &&
        index < _currentUser.storeProducts!.length) {
      List<Product> updatedProducts = List.from(_currentUser.storeProducts!);
      updatedProducts[index] = updatedProduct;
      _currentUser = User(
        username: _currentUser.username,
        fullName: _currentUser.fullName,
        email: _currentUser.email,
        phone: _currentUser.phone,
        bio: _currentUser.bio,
        profileImagePath: _currentUser.profileImagePath,
        isSeller: true,
        storeName: _currentUser.storeName,
        storeDescription: _currentUser.storeDescription,
        storeProducts: updatedProducts,
      );
      saveUserData();
    }
  }

  static void removeProductFromStore(int index) {
    if (_currentUser.isSeller &&
        _currentUser.storeProducts != null &&
        index < _currentUser.storeProducts!.length) {
      List<Product> updatedProducts = List.from(_currentUser.storeProducts!);
      updatedProducts.removeAt(index);
      _currentUser = User(
        username: _currentUser.username,
        fullName: _currentUser.fullName,
        email: _currentUser.email,
        phone: _currentUser.phone,
        bio: _currentUser.bio,
        profileImagePath: _currentUser.profileImagePath,
        isSeller: true,
        storeName: _currentUser.storeName,
        storeDescription: _currentUser.storeDescription,
        storeProducts: updatedProducts,
      );
      saveUserData();
    }
  }

  static List<Product> getAllSellerProducts() {
    // In a real app, this would aggregate products from all sellers
    // For now, return current user's products if they are a seller
    if (_currentUser.isSeller && _currentUser.storeProducts != null) {
      return _currentUser.storeProducts!;
    }
    return [];
  }
}
