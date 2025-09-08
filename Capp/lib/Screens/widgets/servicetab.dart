import 'package:flutter/material.dart';

class ServiceTabs extends StatelessWidget {
  final int selectedService;
  final Function(int) onServiceSelected;

  const ServiceTabs({
    super.key,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<String> services = ['Clean & Iron', 'Iron Only'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: services.asMap().entries.map((entry) {
          int idx = entry.key;
          String label = entry.value;
          bool isSelected = idx == selectedService;

          return Expanded(
            child: GestureDetector(
              onTap: () => onServiceSelected(idx),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
