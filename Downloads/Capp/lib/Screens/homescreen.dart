
import 'package:flutter/material.dart';
import 'package:ironingboy/Screens/productspage.dart';
import 'package:ironingboy/Screens/sharedpreferences.dart';
import 'package:ironingboy/Screens/widgets/topbar.dart';
import 'package:ironingboy/Screens/widgets/searchbar.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with WidgetsBindingObserver {
  int selectedCategory = 0;
  int selectedService = 0;
  List<Map<String, dynamic>> items = [];

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 8),
              const SearchBarWidget(),
              const SizedBox(height: 20),

              const Text("⚡ Quick Services",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _serviceCard(context, "Cloth\nClean & Iron","👔",
                      [const Color(0xFFE6F3FF), const Color(0xFFFFFFFF)],1),
                  _serviceCard(context, "Cloth\nIron only", "🥌",
                      [const Color(0xFFFFF4E6), const Color(0xFFFFFFFF)],2),
                  _serviceCard(context, "Cloth\nDry Clean", "♨",
                      [const Color(0xFFFDE6F3), const Color(0xFFFFFFFF)],3),
                  _serviceCard(context, "Leather Fur &\n Suede", "🧥",
                      [const Color(0xFFF5E6FF), const Color(0xFFFFFFFF)],4),
                  _serviceCard(context, "Footwear &\n Bags", "👟",
                      [const Color(0xFFE6FFF3), const Color(0xFFFFFFFF)],5),
                  _serviceCard(context, "Bedding &\n Household", "🛏️",
                      [const Color(0xFFFFFBE6), const Color(0xFFFFFFFF)],7),
                  _serviceCard(context, "Repair and \nalterations", "🧵",
                      [const Color(0xFFE6F7FF), const Color(0xFFFFFFFF)],8),
                  _serviceCard(context, "Service wash", "🧺",
                      [const Color(0xFFFFE6F0), const Color(0xFFFFFFFF)],9),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickService(String title, String emoji) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(BuildContext context, String title, String emoji, List<Color> colors, int categoryid) {
    return GestureDetector(
      onTap: () async{
      
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProductListScreen(categoryId: categoryid, title: title),
    ),
  );

      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 6, offset: const Offset(0, 3)),
          ],
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40, fontFamily: 'Poppins')),
            const SizedBox(height: 3),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}





  
 
  
