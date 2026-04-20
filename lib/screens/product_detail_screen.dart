import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final Cart _cart = Cart();
  bool _addedToCart = false;

  void _addToCart() {
    _cart.addProduct(widget.product);
    setState(() => _addedToCart = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${widget.product.name} added to cart ✓'),
      backgroundColor: const Color(0xFF0071E3),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      action: SnackBarAction(
        label: 'Go to Cart',
        textColor: Colors.white,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CartScreen())),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(children: [
          // AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 18, color: Color(0xFF1D1D1F)),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen()))
                  .then((_) => setState(() {})),
                child: Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.shopping_bag_outlined,
                        size: 22, color: Color(0xFF1D1D1F)),
                  ),
                  if (_cart.itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0071E3),
                            shape: BoxShape.circle),
                        child: Text('${_cart.itemCount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ]),
              ),
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Hero image from wantapi.com
                Container(
                  height: 280,
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.network(
                    p.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(Icons.devices,
                          size: 100, color: Colors.grey.shade400),
                    ),
                    loadingBuilder: (_, child, prog) => prog == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF0071E3))),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(p.category,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0071E3),
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 10),
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1F))),
                    const SizedBox(height: 4),
                    Text(p.tagline,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF86868B),
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 8),
                    Text(p.price,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0071E3))),
                    const SizedBox(height: 22),

                    // Description
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1F))),
                    const SizedBox(height: 8),
                    Text(p.description,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3D3D3F),
                            height: 1.7)),
                    const SizedBox(height: 24),

                    // Specs from wantapi.com
                    const Text('Specifications',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1F))),
                    const SizedBox(height: 12),
                    if (p.specs.isNotEmpty)
                      Row(
                        children: p.specs.entries
                            .take(3)
                            .map((e) => Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F7),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(children: [
                                      const Icon(
                                          Icons.check_circle_outline,
                                          color: Color(0xFF0071E3),
                                          size: 20),
                                      const SizedBox(height: 6),
                                      Text(e.key,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF86868B))),
                                      const SizedBox(height: 2),
                                      Text('${e.value}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1D1D1F)),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ]),
                                  ),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 24),
                  ]),
                ),
              ]),
            ),
          ),

          // Add to Cart butonu
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: Icon(_addedToCart
                    ? Icons.check_circle_outline
                    : Icons.shopping_bag_outlined),
                label: Text(
                    _addedToCart ? 'Added to Cart' : 'Add to Cart',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _addedToCart
                      ? const Color(0xFF34C759)
                      : const Color(0xFF0071E3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
