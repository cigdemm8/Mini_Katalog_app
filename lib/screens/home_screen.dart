import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Cart _cart = Cart();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'All',
    'Phone',
    'Computer',
    'Tablet',
    'Watch',
    'Accessory',
    'Smart Home',
    'Vision',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final products = await ApiService.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final matchSearch =
            p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.tagline.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchCat =
            _selectedCategory == 'All' || p.category == _selectedCategory;
        return matchSearch && matchCat;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(children: [
          _buildAppBar(),
          _buildSearchBar(),
          _buildCategories(),
          _buildBanner(),
          Expanded(child: _buildBody()),
        ]),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
      child: Row(children: [
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Discover',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1D1F))),
            Text('Find your perfect device.',
                style: TextStyle(fontSize: 13, color: Color(0xFF86868B))),
          ]),
        ),
        _buildCartButton(),
      ]),
    );
  }

  Widget _buildCartButton() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      ).then((_) => setState(() {})),
      child: Stack(children: [
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.shopping_bag_outlined,
              color: Color(0xFF1D1D1F), size: 26),
        ),
        if (_cart.itemCount > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Color(0xFF0071E3), shape: BoxShape.circle),
              child: Text('${_cart.itemCount}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          ),
      ]),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          _searchQuery = val;
          _filterProducts();
        },
        decoration: InputDecoration(
          hintText: 'Search products',
          hintStyle: const TextStyle(color: Color(0xFF86868B)),
          prefixIcon:
              const Icon(Icons.search, color: Color(0xFF86868B)),
          filled: true,
          fillColor: const Color(0xFFF5F5F7),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      color: Colors.white,
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final sel = _categories[i] == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = _categories[i]);
              _filterProducts();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: sel
                    ? const Color(0xFF0071E3)
                    : const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(_categories[i],
                    style: TextStyle(
                        fontSize: 13,
                        color: sel ? Colors.white : const Color(0xFF1D1D1F),
                        fontWeight: sel
                            ? FontWeight.w600
                            : FontWeight.normal)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      height: 96,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF0071E3), Color(0xFF42A5F5)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(children: [
          // Banner görseli - wantapi.com/assets/banner.png
          Positioned.fill(
            child: Image.network(
              ApiService.bannerUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
          // Üstüne overlay
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🎁  GIFT STORE',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(height: 4),
                      Text('Discover the best technology',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ]),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white54, size: 16),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(color: Color(0xFF0071E3)),
          SizedBox(height: 16),
          Text('Loading products...',
              style: TextStyle(color: Color(0xFF86868B))),
        ]),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.wifi_off, size: 64, color: Color(0xFF86868B)),
          const SizedBox(height: 16),
          const Text('Connection error',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1D1F))),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadProducts,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0071E3),
                foregroundColor: Colors.white),
            child: const Text('Try Again'),
          ),
        ]),
      );
    }

    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off, size: 64, color: Color(0xFF86868B)),
          SizedBox(height: 12),
          Text('No products found',
              style: TextStyle(color: Color(0xFF86868B), fontSize: 16)),
        ]),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      color: const Color(0xFF0071E3),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (_, i) => _ProductCard(
          product: _filteredProducts[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProductDetailScreen(product: _filteredProducts[i]),
            ),
          ).then((_) => setState(() {})),
          onAdd: () {
            _cart.addProduct(_filteredProducts[i]);
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${_filteredProducts[i].name} added to cart ✓'),
              backgroundColor: const Color(0xFF0071E3),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ));
          },
        ),
      ),
    );
  }
}

// ── Ürün Kartı ────────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap, onAdd;

  const _ProductCard(
      {required this.product, required this.onTap, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Product image from wantapi.com
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                color: const Color(0xFFF5F5F7),
                width: double.infinity,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(Icons.devices,
                        size: 56, color: Colors.grey.shade400),
                  ),
                  loadingBuilder: (_, child, prog) => prog == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0071E3), strokeWidth: 2)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.category,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF86868B))),
              const SizedBox(height: 2),
              Text(product.name,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1F)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(product.tagline,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF86868B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.price,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0071E3))),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0071E3),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
