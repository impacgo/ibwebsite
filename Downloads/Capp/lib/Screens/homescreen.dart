
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ironingboy/Screens/cartscreen.dart';
// import 'package:ironingboy/Screens/productspage.dart';
// import 'package:ironingboy/Screens/sharedpreferences.dart';
// import 'package:ironingboy/Screens/widgets/topbar.dart';
// import 'package:ironingboy/Screens/widgets/searchbar.dart';
// import 'package:ironingboy/cartpage.dart';
// class Homescreen extends StatefulWidget {
//   const Homescreen({super.key});
//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }

// class _HomescreenState extends State<Homescreen> with WidgetsBindingObserver {
//   int selectedCategory = 0;
//   int selectedService = 0;
//   List<Map<String, dynamic>> items = [];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   Future<void> _loadInitialData() async {
//     selectedCategory = await SharedPrefsHelper.getSelectedCategory();
//     selectedService = await SharedPrefsHelper.getSelectedService();
//     items = await SharedPrefsHelper.getItems();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const TopBar(),
//               const SearchBarWidget(),
//               const SizedBox(height: 8),
            
//               const SizedBox(height: 20),

//               const Text("⚡ Quick Services",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 90,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _quickService("Express", "🚀"),
//                     _quickService("Dry clean", "♨"),
//                     _quickService("Clean & iron", "👔"),
//                     _quickService("Service wash", "🧺"),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               const Text("Our Services",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
//               const SizedBox(height: 12),
//               GridView.count(
//                 crossAxisCount: 3,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 children: [
//                   _serviceCard(context, "Cloth\nClean & Iron","👔",
//                       [const Color(0xFFE6F3FF), const Color(0xFFFFFFFF)],1),
//                   _serviceCard(context, "Cloth\nIron only", "🥌",
//                       [const Color(0xFFFFF4E6), const Color(0xFFFFFFFF)],2),
//                   _serviceCard(context, "Cloth\nDry Clean", "♨",
//                       [const Color(0xFFFDE6F3), const Color(0xFFFFFFFF)],3),
//                   _serviceCard(context, "Leather Fur &\n Suede", "🧥",
//                       [const Color(0xFFF5E6FF), const Color(0xFFFFFFFF)],4),
//                   _serviceCard(context, "Footwear &\n Bags", "👟",
//                       [const Color(0xFFE6FFF3), const Color(0xFFFFFFFF)],5),
//                   _serviceCard(context, "Household\nclean & Iron", "🛏️",
//                       [const Color(0xFFFFFBE6), const Color(0xFFFFFFFF)],6),
//                          _serviceCard(context, "Household\n Iron only", "🛏️",
//                        [const Color(0xFFE6FFF3), const Color(0xFFFFFFFF)],5),
//                   _serviceCard(context, "Repair and \nalterations", "🧵",
//                       [const Color(0xFFE6F7FF), const Color(0xFFFFFFFF)],8),
//                   _serviceCard(context, "Service wash", "🧺",
//                       [const Color(0xFFFFE6F0), const Color(0xFFFFFFFF)],9),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: _buildCartFAB(),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }

//   Widget _quickService(String title, String emoji) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         width: 90,
//         height: 76,
//         margin: const EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: const Color(0XFFFAFAFA),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(emoji, style: const TextStyle(fontSize: 30, fontFamily: 'Poppins')),
//             const SizedBox(height: 8),
//             Text(title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _serviceCard(BuildContext context, String title, String emoji, List<Color> colors, int categoryid) {
//     return GestureDetector(
//       onTap: () async{
      
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => ProductListScreen(categoryId: categoryid, title: title),
//     ),
//   );

//       },
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 6, offset: const Offset(0, 3)),
//           ],
//           gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(emoji, style: const TextStyle(fontSize: 40, fontFamily: 'Poppins')),
//             const SizedBox(height: 3),
//             Text(title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _buildCartFAB() {
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
//             // The main text, now with conditional logic
//             Text(
//               count == 0
//                   ? "Please add items into cart"
//                   : "Your Item add to cart",
//               style: const TextStyle(
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
//             GestureDetector(
//               onTap: () => context.read<CartBloc>().add(HideCartBar()),
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.white24, 
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironingboy/Screens/cartscreen.dart';
import 'package:ironingboy/Screens/productspage.dart';
import 'package:ironingboy/Screens/sharedpreferences.dart';
import 'package:ironingboy/Screens/widgets/topbar.dart';
import 'package:ironingboy/Screens/widgets/searchbar.dart';
import 'package:ironingboy/cartpage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with WidgetsBindingObserver {
  int selectedCategory = 0;
  int selectedService = 0;
  List<Map<String, dynamic>> items = [];

  // cart FAB logic
  bool _isFabBarVisible = false; 
  Offset _fabIconPosition = const Offset(20, 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    selectedCategory = await SharedPrefsHelper.getSelectedCategory();
    selectedService = await SharedPrefsHelper.getSelectedService();
    items = await SharedPrefsHelper.getItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          // 🔹 Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBar(),
                  const SearchBarWidget(),
                  const SizedBox(height: 8),
                  const SizedBox(height: 20),
                  const Text("⚡ Quick Services",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _quickService("Express", "🚀"),
                        _quickService("Dry clean", "♨"),
                        _quickService("Clean & iron", "👔"),
                        _quickService("Service wash", "🧺"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Our Services",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _serviceCard(context, "Cloth\nClean & Iron", "👔",
                          [const Color(0xFFE6F3FF), const Color(0xFFFFFFFF)], 1),
                      _serviceCard(context, "Cloth\nIron only", "🥌",
                          [const Color(0xFFFFF4E6), const Color(0xFFFFFFFF)], 2),
                      _serviceCard(context, "Cloth\nDry Clean", "♨",
                          [const Color(0xFFFDE6F3), const Color(0xFFFFFFFF)], 3),
                      _serviceCard(context, "Leather Fur &\n Suede", "🧥",
                          [const Color(0xFFF5E6FF), const Color(0xFFFFFFFF)], 4),
                      _serviceCard(context, "Footwear &\n Bags", "👟",
                          [const Color(0xFFE6FFF3), const Color(0xFFFFFFFF)], 5),
                      _serviceCard(context, "Household\nclean & Iron", "🛏️",
                          [const Color(0xFFFFFBE6), const Color(0xFFFFFFFF)], 6),
                      _serviceCard(context, "Household\n Iron only", "🛏️",
                          [const Color(0xFFE6FFF3), const Color(0xFFFFFFFF)], 7),
                      _serviceCard(context, "Repair and \nalterations", "🧵",
                          [const Color(0xFFE6F7FF), const Color(0xFFFFFFFF)], 8),
                      _serviceCard(context, "Service wash", "🧺",
                          [const Color(0xFFFFE6F0), const Color(0xFFFFFFFF)], 9),
                    ],
                  ),
                  const SizedBox(height: 80), // extra space for cart bar
                ],
              ),
            ),
          ),

          // 🔹 FAB cart bar
          if (_isFabBarVisible)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: 10,
              left: 12,
              right: 12,
              child: _buildCartFAB(),
            ),

          // 🔹 Draggable cart icon
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _quickService(String title, String emoji) {
    return Container(
      width: 90,
      height: 76,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0XFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30, fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _serviceCard(BuildContext context, String title, String emoji,
      List<Color> colors, int categoryid) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductListScreen(categoryId: categoryid, title: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3)),
          ],
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji,
                style: const TextStyle(fontSize: 40, fontFamily: 'Poppins')),
            const SizedBox(height: 3),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins')),
          ],
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
