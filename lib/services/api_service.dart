import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Base API URL
  static const String _baseUrl = 'https://wantapi.com';
  static const String _productsEndpoint = '$_baseUrl/products.php';
  static const String _bannerUrl = '$_baseUrl/assets/banner.png';

  static String get bannerUrl => _bannerUrl;

  // Fetch all products
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(_productsEndpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json['status'] == 'success') {
          final List<dynamic> data = json['data'];
          return data.map((item) => Product.fromJson(item)).toList();
        } else {
          throw Exception('API error: ${json['status']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
