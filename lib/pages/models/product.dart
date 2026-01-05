class Review {
  final String name;
  final int rating;
  final String comment;
  final String date;

  Review({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  // Convert Review to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }

  // Create Review from Map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      name: map['name'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      date: map['date'] ?? '',
    );
  }
}

class Product {
  final String name;
  final String image;
  final String price;
  final String sold;
  final String description;
  final List<String> sizes;
  final String? discount;
  final String storeName;
  final List<Review> reviews;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.sold,
    required this.description,
    required this.sizes,
    this.discount,
    required this.storeName,
    this.reviews = const [],
  });

  // Convert Product to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'sold': sold,
      'description': description,
      'sizes': sizes,
      'discount': discount,
      'storeName': storeName,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '',
      sold: map['sold'] ?? '',
      description: map['description'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
      discount: map['discount'],
      storeName: map['storeName'] ?? '',
      reviews: map['reviews'] != null
          ? List<Review>.from(map['reviews'].map((x) => Review.fromMap(x)))
          : [],
    );
  }

  // Method to add a review
  Product addReview(Review review) {
    return Product(
      name: name,
      image: image,
      price: price,
      sold: sold,
      description: description,
      sizes: sizes,
      discount: discount,
      storeName: storeName,
      reviews: [...reviews, review],
    );
  }
}
