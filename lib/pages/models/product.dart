class Product {
  final String name;
  final String image;
  final String price;
  final String sold;
  final String description;
  final List<String> sizes;
  final String? discount;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.sold,
    required this.description,
    required this.sizes,
    this.discount,
  });
}
