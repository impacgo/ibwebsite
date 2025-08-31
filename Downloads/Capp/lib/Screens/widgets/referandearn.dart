import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 
class ReferEarnPage extends StatelessWidget {
  const ReferEarnPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
              colors: [Color(0xFFF8B500), Color(0xFFF57C00)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              ),
            ),
            ),
          title: const Text("Refer & Earn"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: "Refer"),
              Tab(text: "Earn"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReferTab(),
            EarnTab(),
          ],
        ),
      ),
    );
  }
} 
class ReferTab extends StatelessWidget {
  const ReferTab({super.key}); 
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
 
    return Column(
      children: [
     
        Container(
          height: screenHeight * 0.7, 
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8B500), Color(0xFFF57C00)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(50), 
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.card_giftcard, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                "€ 100",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Get 100 points for every friend who signs up & places their first order.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "A1B2C3",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("Copy Code"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Share your Referral code",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
 
        
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
 

class EarnTab extends StatelessWidget {
  const EarnTab({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8B500), Color(0xFFF57C00)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const Text(
            "Total Earned",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Text(
            "300.00",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Your referrals",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 15),
          referralTile(
              "Aditya Ram", "Pending", "Apr 20", 100.00, Colors.orange),
          referralTile("Sai", "Successful", "Apr 8", 100.00, Colors.green),
          referralTile(
              "Bhushan Gonthina", "Successful", "Mar 7", 100.00, Colors.green),
        ],
      ),
    );
  }
 
  static Widget referralTile(String name, String status, String date,
      double amount, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(name),
        subtitle: Text(date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              amount.toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: TextStyle(color: statusColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 