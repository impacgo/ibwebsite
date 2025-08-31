import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: items.length,
        padding: const EdgeInsets.only(bottom: 80),
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Instructions',
                          style: TextStyle(color: Colors.blue.shade600, fontSize: 12)),
                    ],
                  ),
                ),
                Text("(\$${item['price'].toStringAsFixed(2)})"),
                const SizedBox(width: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (item['qty'] > 0) item['qty']--;
                      },
                    ),
                    Text(item['qty'].toString().padLeft(2, '0')),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        item['qty']++;
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
