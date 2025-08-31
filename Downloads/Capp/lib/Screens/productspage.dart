import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironingboy/bussinesslogic/productscreen.dart';
import 'package:ironingboy/cartpage.dart';
import 'package:ironingboy/Screens/cartscreen.dart';
class ProductListScreen extends StatefulWidget {
  final int categoryId;
  final String title;
  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final fetchedProducts = await Productscreen.fetchProducts(widget.categoryId);
      setState(() {
        products = fetchedProducts.cast<Map<String, dynamic>>();
        for (var p in products) {
          p["isAdded"] = false;
        }
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _filterSearch(String query) {
    setState(() {
      final searchQuery = query.toLowerCase();
      filteredProducts = products
          .where((item) => item["name"].toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title.replaceAll('\n', ' '),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.grey))
            : Column(
                children: [
                  _buildSearchBar(),
                  Expanded(child: _buildProductList()),
                ],
              ),
        floatingActionButton: _buildCartFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        onChanged: _filterSearch,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.person, size: 30, color: Colors.blue),
        title: Text(
          product["name"],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: const Text(
          "Clean and iron   Estimated in 1 day",
          style: TextStyle(
            fontSize: 10,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "\$${product["price"]}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 10),
            _buildAddButton(product),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(Map<String, dynamic> product) {
    final isAdded = product["isAdded"] == true;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.read<CartBloc>().add(AddToCart({
              "id": product["id"],
              "name": product["name"],
              "price": product["price"],
            }));

        setState(() => product["isAdded"] = true);

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() => product["isAdded"] = false);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isAdded ? Colors.green : Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isAdded ? "ADDED ✓" : "ADD +",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCartFAB() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int count = state is CartUpdated ? state.items.length : 0;
        if (count == 0) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Flexible(
                child: Text(
                  "Your item added to cart",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "View \n$count Item${count > 1 ? "s" : ""}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}

