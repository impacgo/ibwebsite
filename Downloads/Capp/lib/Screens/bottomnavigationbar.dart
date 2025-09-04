import 'package:flutter/material.dart';
import 'package:ironingboy/Screens/homescreen.dart';
import 'package:ironingboy/Screens/widgets/ChatScreen.dart';
import 'package:ironingboy/Screens/widgets/Orderscreen.dart';
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//   final List<Widget> _screens = [
//     const Homescreen(),
//     const MyOrdersScreen(),
//     const ChatScreen(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         elevation: 0,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         selectedItemColor: Colors.orangeAccent,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_filled),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_bag),
//             label: "My Orders",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: "Chat",
//           ),
//         ],
//       ),
//     );
//   }
// }
class MainScreen extends StatefulWidget {
  final int initialIndex; // 👈 add this

  const MainScreen({super.key, this.initialIndex = 0}); // default Home

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    Homescreen(),
    MyOrdersScreen(),
    ChatScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // 👈 start with passed index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "My Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
        ],
      ),
    );
  }
}
