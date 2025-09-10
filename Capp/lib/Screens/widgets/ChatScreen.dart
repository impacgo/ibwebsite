

import 'package:flutter/material.dart';

class LaundryChatScreen extends StatefulWidget {
  const LaundryChatScreen({Key? key}) : super(key: key);

  @override
  State<LaundryChatScreen> createState() => _LaundryChatScreenState();
}

class _LaundryChatScreenState extends State<LaundryChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _quickScrollController = ScrollController();
  final ScrollController _messagesController = ScrollController();

  // Dummy orders database
  final Map<String, Map<String, dynamic>> _orders = {
    "#LB1023": {
      "orderId": "#LB1023",
      "items": ["2x White Shirt", "1x Blue Jeans", "3x Formal Pants"],
      "status": "Out for Delivery",
      "deliveryDate": "Today, 7 PM"
    },
    "#LB2045": {
      "orderId": "#LB2045",
      "items": ["1x Jacket", "2x T-Shirt"],
      "status": "Processing",
      "deliveryDate": "Tomorrow, 2 PM"
    },
    "#LB3099": {
      "orderId": "#LB3099",
      "items": ["1x Saree (Dry Clean)", "1x Shirt"],
      "status": "Delivered",
      "deliveryDate": "Yesterday, 5 PM"
    },
  };

  // quick messages (chips)
  final List<String> _quickMessages = [
    "Order Status",
    "Return policy",
    "Shipping info",
    "Book pickup",
    "Pricing",
    "Report missing item",
    "Apply coupon"
  ];

  // Dummy conversation with times
  final List<Map<String, dynamic>> _messages = [
    {
      "sender": "bot",
      "type": "text",
      "text":
          "Hello! \$username welcome to our support chat. How can I help you today?",
      "time": "10:04 AM"
    },
    {
      "sender": "user",
      "type": "text",
      "text":
          "Hi, I'm having an issue with my recent order. I didn't get one of my white shirt. So I need your support",
      "time": "10:05 AM"
    },
    {
      "sender": "bot",
      "type": "text",
      "text":
          "I'm really sorry to hear that, \$username. Let me look into that right away. Could you please share your order ID or the approximate date of your order?",
      "time": "10:05 AM"
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    _quickScrollController.dispose();
    _messagesController.dispose();
    super.dispose();
  }

  String _nowTimeLabel() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;
    final displayHour = (hour % 12 == 0) ? 12 : hour % 12;
    return "$displayHour:$minute ${isAm ? 'AM' : 'PM'}";
  }

  // Main send handler
  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        "sender": "user",
        "type": "text",
        "text": trimmed,
        "time": _nowTimeLabel()
      });
    });
    _controller.clear();
    _scrollToBottomDelayed();

    // If the user explicitly tapped quick action for Order Status, we handle separately elsewhere.
    Future.delayed(const Duration(milliseconds: 500), () {
      final lower = trimmed.toLowerCase();

      // Detect order id pattern like '#LB1023' or 'LB1023' (case-insensitive)
      final idMatch = RegExp(r'#?lb\d+', caseSensitive: false).firstMatch(trimmed);
      if (idMatch != null) {
        var raw = idMatch.group(0) ?? "";
        raw = raw.startsWith('#') ? raw.toUpperCase() : '#${raw.toUpperCase()}';
        if (_orders.containsKey(raw)) {
          // respond with order card
          setState(() {
            final order = _orders[raw]!;
            _messages.add({
              "sender": "bot",
              "type": "order",
              "orderId": order["orderId"],
              "items": order["items"],
              "status": order["status"],
              "deliveryDate": order["deliveryDate"],
              "time": _nowTimeLabel()
            });
          });
        } else {
          setState(() {
            _messages.add({
              "sender": "bot",
              "type": "text",
              "text": "I couldn't find an order with ID $raw. Please verify and try again.",
              "time": _nowTimeLabel()
            });
          });
        }
      } else if (lower.contains("order status")) {
        // If user asked for order status without providing ID, show order list sheet
        _showOrderListSheet();
      } else if (lower.contains("return") || lower.contains("missing")) {
        setState(() {
          _messages.add({
            "sender": "bot",
            "type": "text",
            "text":
                "We're sorry about that. Please share a photo or confirm the items missing. We'll raise an internal check.",
            "time": _nowTimeLabel()
          });
        });
      } else {
        setState(() {
          _messages.add({
            "sender": "bot",
            "type": "text",
            "text":
                "✅ Thanks! Our support team will check this and get back to you shortly.",
            "time": _nowTimeLabel()
          });
        });
      }

      _scrollToBottomDelayed();
    });
  }

  void _scrollToBottomDelayed() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_messagesController.hasClients) {
        _messagesController.animateTo(
          _messagesController.position.maxScrollExtent + 160,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Show bottom sheet with list of dummy orders
  void _showOrderListSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6)),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Your recent orders",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
              ),
              const SizedBox(height: 8),
              ..._orders.values.map((order) {
                return ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(order["orderId"]),
                  subtitle: Text(order["status"]),
                  trailing: Text(order["deliveryDate"],
                      style: const TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    // simulate user typing/choosing this order id
                    _sendMessage(order["orderId"]);
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.72;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: const Icon(Icons.arrow_back, color: Colors.black),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("IroningBoy Support",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              SizedBox(height: 2),
              Text("CamdenTown, London",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          actions: [
      
          ],
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _messagesController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg["sender"] == "user";
                    if (msg["type"] == "order") {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _buildOrderCard(msg),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment:
                            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.smart_toy, size: 20, color: Colors.black54),
                            ),
                          ],
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                            child: Column(
                              crossAxisAlignment: isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: isUser ? const Color(0xFF111827) : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(isUser ? 16 : 6),
                                      topRight: Radius.circular(isUser ? 6 : 16),
                                      bottomLeft: const Radius.circular(16),
                                      bottomRight: const Radius.circular(16),
                                    ),
                                    boxShadow: [
                                      if (!isUser)
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: Text(
                                    msg["text"] ?? "",
                                    style: TextStyle(
                                      color: isUser ? Colors.white : Colors.black87,
                                      fontSize: 14,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // timestamp
                                Text(
                                  msg["time"] ?? "",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (isUser) const SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Scrollbar(
                  controller: _quickScrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: _quickScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickMessages.map((label) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: GestureDetector(
                            onTap: () {
                              if (label == "Order Status") {
                                _showOrderListSheet();
                              } else {
                                _sendMessage(label);
                              }
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 36),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                label,
                                style: const TextStyle(fontSize: 13),
                              )),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
      
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.attachment, color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: "Message",
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                onSubmitted: (v) => _sendMessage(v),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _sendMessage(_controller.text),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7A18),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_upward,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_laundry_service, size: 18),
                const SizedBox(width: 8),
                Text("Order Details",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey[900])),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(order["status"] ?? "",
                      style: const TextStyle(fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text("Order ID: ${order["orderId"] ?? ''}",
                style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text("Delivery: ${order["deliveryDate"] ?? ''}",
                style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            const Text("Items:",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            ...List<Widget>.from((order["items"] as List<dynamic>).map((it) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("• $it", style: const TextStyle(fontSize: 13)),
              );
            })),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _sendMessage("Report missing items ${order["orderId"]}");
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black),
                  child: const Text("Report"),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    _sendMessage("Contact delivery for ${order["orderId"]}");
                  },
                  child: const Text("Contact"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}