import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Cart _cart = Cart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 18, color: Color(0xFF1D1D1F)),
          ),
        ),
        title: const Text('Cart',
            style: TextStyle(
                color: Color(0xFF1D1D1F), fontWeight: FontWeight.bold)),
        actions: [
          if (_cart.items.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() => _cart.clear());
              },
              child: const Text('Clear',
                  style: TextStyle(color: Color(0xFFFF3B30))),
            ),
        ],
      ),
      body: _cart.items.isEmpty ? _buildEmpty() : _buildCart(),
    );
  }

  Widget _buildEmpty() {
    return Column(children: [
      Expanded(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Icon(Icons.shopping_bag_outlined,
                size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('Your cart is empty',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1F))),
            const SizedBox(height: 6),
            const Text('Add items to start shopping',
                style: TextStyle(fontSize: 14, color: Color(0xFF86868B))),
          ]),
        ),
      ),
      _buildBottomBar(),
    ]);
  }

  Widget _buildCart() {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _cart.items.length,
          itemBuilder: (_, i) {
            final item = _cart.items[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Row(children: [
                // Product image from wantapi.com
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 72,
                    height: 72,
                    color: const Color(0xFFF5F5F7),
                    child: Image.network(
                      item.product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.devices, color: Color(0xFF86868B)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(item.product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1D1D1F))),
                    const SizedBox(height: 2),
                    Text(item.product.category,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF86868B))),
                    const SizedBox(height: 4),
                    Text(item.product.price,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0071E3))),
                  ]),
                ),
                // Miktar kontrolü
                Column(children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _cart.decreaseQuantity(item.product.id)),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.remove,
                          size: 16, color: Color(0xFF1D1D1F)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text('${item.quantity}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _cart.addProduct(item.product)),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: const Color(0xFF0071E3),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.add,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ]),
              ]),
            );
          },
        ),
      ),
      _buildBottomBar(),
    ]);
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4))
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(10)),
          child: const Row(children: [
            Icon(Icons.info_outline, size: 14, color: Color(0xFF86868B)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                  'Prices include VAT. Free shipping on all orders.',
                  style:
                      TextStyle(fontSize: 11, color: Color(0xFF86868B))),
            ),
          ]),
        ),
        if (_cart.items.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            const Text('Total:',
                style:
                    TextStyle(fontSize: 15, color: Color(0xFF86868B))),
            Text('\$${_cart.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1D1F))),
          ]),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _cart.items.isEmpty
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: const Text('Order Confirmed'),
                        content: Text(
                            '\$${_cart.totalPrice.toStringAsFixed(0)} worth of order has been placed! 🎉'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() => _cart.clear());
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0071E3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text('Checkout',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }
}
