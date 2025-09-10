import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');
      final response = await http.get(
        Uri.parse("${base.baseUrl}/orders"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          orders = data["orders"] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  Future<void> fetchOrderDetails(int orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');
      final response = await http.get(
        Uri.parse("${base.baseUrl}/orders/$orderId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final order = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Order #${order['order_id']}"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total: £${order['total']}"),
                  Text("Subtotal: £${order['subtotal']}"),
                  Text("Tip: £${order['tip']}"),
                  Text("Collect Slot: ${order['collect_slot']}"),
                  Text("Delivery Slot: ${order['delivery_slot']}"),
                  const SizedBox(height: 10),
                  const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate(order['items'].length, (i) {
                    final item = order['items'][i];
                    return Text(
                    "- ${item['product_name']} (x${item['quantity']}) = £${item['price_at_purchase']}"
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              )
            ],
          ),
        );
      } else {
        print("Failed to fetch order details");
      }
    } catch (e) {
      print("Error fetching order details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Orders"),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
                ? const Center(child: Text("No orders found"))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text("Order #${order['order_id']}"),
                          subtitle: Text("Total: ₹${order['total']}"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => fetchOrderDetails(order['order_id']),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
