class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String image;
  final Map<String, dynamic> specs;

  Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.image,
    required this.specs,
  });

  // wantapi.com JSON yapısından model oluşturma
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      specs: Map<String, dynamic>.from(json['specs'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'image': image,
      'specs': specs,
    };
  }

  // İsme göre kategori belirleme
  String get category {
    final n = name.toLowerCase();
    if (n.contains('iphone')) return 'Phone';
    if (n.contains('macbook') || n.contains('imac')) return 'Computer';
    if (n.contains('ipad')) return 'Tablet';
    if (n.contains('watch')) return 'Watch';
    if (n.contains('airpods')) return 'Accessory';
    if (n.contains('homepod')) return 'Smart Home';
    if (n.contains('vision')) return 'Vision';
    return 'Other';
  }

  // Parse price to double
  double get priceValue {
    return double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
  }
}
