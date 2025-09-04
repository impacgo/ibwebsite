// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ironingboy/Screens/cartitem.dart';
// import 'package:ironingboy/bussinesslogic/productscreen.dart';
// import 'package:ironingboy/cartpage.dart';
// import 'package:ironingboy/Screens/cartscreen.dart';
// class ProductListScreen extends StatefulWidget {
//   final int categoryId;
//   final String title;
//   const ProductListScreen({
//     super.key,
//     required this.categoryId,
//     required this.title,
//   });
//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   List<Map<String, dynamic>> products = [];
//   List<Map<String, dynamic>> filteredProducts = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   Future<void> _loadProducts() async {
//     try {
//       final fetchedProducts = await Productscreen.fetchProducts(widget.categoryId);
//       setState(() {
//         products = fetchedProducts.cast<Map<String, dynamic>>();
//         for (var p in products) {
//           p["isAdded"] = false;
//         }
//         filteredProducts = products;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   void _filterSearch(String query) {
//     setState(() {
//       final searchQuery = query.toLowerCase();
//       filteredProducts = products
//           .where((item) => item["name"].toLowerCase().contains(searchQuery))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<CartBloc, CartState>(
//       listener: (context, state) {},
//       child: Scaffold(
//         appBar: AppBar(
//             backgroundColor: Colors.white,
//           title: Text(
//             widget.title.replaceAll('\n', ' '),
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator(color: Colors.grey))
//             : Column(
//                 children: [
//                   _buildSearchBar(),
//                   Expanded(child: _buildProductList()),
//                 ],
//               ),
//         floatingActionButton: _buildCartFAB(),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: TextField(
//         onChanged: _filterSearch,
//         decoration: InputDecoration(
//           hintText: "Search",
//           prefixIcon: const Icon(Icons.search),
//           filled: true,
//           fillColor: Colors.grey.shade200,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductList() {
//     return ListView.builder(
//       itemCount: filteredProducts.length,
//       itemBuilder: (context, index) {
//         final product = filteredProducts[index];
//         return _buildProductCard(product);
//       },
//     );
//   }

//   Widget _buildProductCard(Map<String, dynamic> product) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//        leading: Text(
//   product["emoji"]?? '🛒', 
//   style: const TextStyle(fontSize: 30),
// ),
//         title: 
//         Text(
//           product["name"],
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 12,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         subtitle: Text(
//          ' ${widget.title}'.replaceAll('\n', ' '),
//           style: const TextStyle(
//             fontSize: 10,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "\$${product["price"]}",
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(width: 10),
//             _buildAddButton(product),
//           ],
//         ),
//       ),
//     );
//   }



//   Widget _buildAddButton(Map<String, dynamic> product) {
//     final isAdded = product["isAdded"] == true;

//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: () {
//          context.read<CartBloc>().add(
//         AddToCart(
//           CartItem(
//             id: product["id"] as int,
//             name: product["name"] as String,
//             price: double.parse(product["price"].toString()),
//             qty: 1,
           
//           ),
//         ),
//       );
//         setState(() => product["isAdded"] = true);

//         Future.delayed(const Duration(seconds: 1), () {
//           if (mounted) {
//             setState(() => product["isAdded"] = false);
//           }
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isAdded ? Colors.green : Colors.orange,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           isAdded ? "ADDED ✓" : "ADD +",
//           style: const TextStyle(
//             color: Colors.white,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
//       Widget _buildCartFAB() {
//   return BlocBuilder<CartBloc, CartState>(
//     builder: (context, state) {
//       if (state is CartUpdated && state.showBar == false) {
//         return const SizedBox.shrink();
//       }

//       int count = state is CartUpdated ? state.items.length : 0;
      
//       // Main container, matching the orange background and shadow from the image
//       return Container(
//         margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.orange,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the ends
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             // The main text, matching the image exactly
//             const Text(
//               "Your Item add to cart",
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 14,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const SizedBox(width: 8),

//             // View Cart Button, matching the image's green button and shadow
//             if (count > 0)
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const CartPage()),
//                   );
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     "View cart\n$count Item${count > 1 ? "s" : ""}",
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontFamily: 'Poppins',
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),

//             const SizedBox(width: 8),

//             // Close button, matching the image's circular background
//             GestureDetector(
//               onTap: () => context.read<CartBloc>().add(HideCartBar()),
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.white24, // A slightly transparent white background
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironingboy/Screens/cartitem.dart';
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

  Offset _fabIconPosition = const Offset(20, 450);
  bool _isFabBarVisible = false; // toggle between cart icon and FAB bar

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final fetchedProducts =
          await Productscreen.fetchProducts(widget.categoryId);
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
          backgroundColor: Colors.white,
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
            : Stack(
                children: [
                  Column(
                    children: [
                      _buildSearchBar(),
                      Expanded(child: _buildProductList()),
                    ],
                  ),

                  // show FAB bar when visible
                  if (_isFabBarVisible)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildCartFAB(),
                    ),

                  // show cart icon only when FAB bar is hidden
                  if (!_isFabBarVisible)
                    Positioned(
                      left: _fabIconPosition.dx,
                      top: _fabIconPosition.dy,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFabBarVisible = true;
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            _fabIconPosition += details.delta;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7,),
    
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Text(
          product["emoji"] ?? '🛒',
          style: const TextStyle(fontSize: 30),
        ),
        title: Text(
          product["name"],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: Text(
          ' ${widget.title}'.replaceAll('\n', ' '),
          style: const TextStyle(
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
        context.read<CartBloc>().add(
              AddToCart(
                CartItem(
                  id: product["id"] as int,
                  name: product["name"] as String,
                  price: double.parse(product["price"].toString()),
                  qty: 1,
                ),
              ),
            );
        setState(() => product["isAdded"] = true);

        setState(() {
          _isFabBarVisible = true; // show FAB bar when add clicked
        });

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

        return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count == 0
                    ? "Please add items into cart"
                    : "Your Item add to cart",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (count > 0)
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
                      "View cart\n$count Item${count > 1 ? "s" : ""}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFabBarVisible = false; // hide FAB bar
                  });
                },
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
