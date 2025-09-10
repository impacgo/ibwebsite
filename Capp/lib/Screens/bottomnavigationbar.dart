import 'package:flutter/material.dart';
import 'package:ironingboy/Screens/homescreen.dart';
import 'package:ironingboy/Screens/widgets/ChatScreen.dart';
import 'package:ironingboy/Screens/widgets/Orderscreen.dart';
class MainScreen extends StatefulWidget {
  final int initialIndex; 

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const Homescreen(),
   MyOrderPage(),
  const LaundryChatScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; 
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
