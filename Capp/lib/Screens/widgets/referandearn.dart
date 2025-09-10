import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
class Referandearn extends StatelessWidget {
  const Referandearn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refer & Earn Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFFF8B500),
        scaffoldBackgroundColor: const Color(0xFFFFF9F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF9F2),
          foregroundColor: Color(0xFF1F2937),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF57C00),
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Color(0xFF1F2937)),
          bodyMedium: TextStyle(color: Color(0xFF6B7280)),
        ),
        useMaterial3: false,
      ),
      home: const ReferEarnPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ReferEarnPage extends StatelessWidget {
  const ReferEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Refer & Earn",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          centerTitle: true,
          toolbarHeight: 64,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 12, right: 12),
              child: const TabBar(
                indicatorColor: Color(0xFFF57C00),
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.symmetric(horizontal: 8),
                labelColor: Color(0xFFF57C00),
                unselectedLabelColor: Color(0xFF6B7280),
                labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                tabs: [
                  Tab(text: "Refer"),
                  Tab(text: "Earn"),
                ],
              ),
            ),
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              ReferTab(),
              EarnTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReferTab extends StatelessWidget {
  const ReferTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF57C00),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  BounceInDown(
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('🎁', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    child: const Text(
                      "Earn €100",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: Duration(milliseconds: 200),
                    child: const Text(
                      "Get 100 points for every friend who signs up and places their first order.",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SlideInUp(
                    delay: const Duration(milliseconds: 350),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "A1B2C3",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                await Clipboard.setData(const ClipboardData(text: "A1B2C3"));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Code copied")),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF57C00),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.copy, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FadeIn(
                    delay: Duration(milliseconds: 500),
                    child: const Text(
                      "Share your referral code",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZoomIn(
                        delay: Duration(milliseconds: 650),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.whatsapp),
                          label: const Text("WhatsApp"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF25D366),
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ZoomIn(
                        delay: Duration(milliseconds: 800),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          label: const Text("More"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFFF57C00),
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline),
                title: Text("How it works"),
                subtitle: Text("Share your code. When a friend places their first order, you earn."),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class EarnTab extends StatelessWidget {
  const EarnTab({super.key});

  final List<Map<String, dynamic>> _referrals = const [
    {"name": "Aditya Ram", "date": "Apr 20", "amount": 100.00, "status": "Pending"},
    {"name": "Sai", "date": "Apr 8", "amount": 100.00, "status": "Successful"},
    {"name": "Bhushan Gonthina", "date": "Mar 7", "amount": 100.00, "status": "Successful"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        SlideInDown(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            color: const Color(0xFFF57C00),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Total Earned", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text("€300.00",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text("Referral History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (int i = 0; i < _referrals.length; i++)
          FadeInLeft(
            delay: Duration(milliseconds: 120 * (i + 1)),
            child: _buildReferralCard(_referrals[i]),
          ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildReferralCard(Map<String, dynamic> item) {
    final status = item['status'] as String;
    final isSuccess = status.toLowerCase() == "successful";
    final statusColor = isSuccess ? const Color(0xFF16A34A) : const Color(0xFFFBBF24);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(item['name'],
            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
        subtitle: Text(item['date'], style: const TextStyle(color: Color(0xFF6B7280))),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("€${(item['amount'] as double).toStringAsFixed(2)}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1F2937))),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}