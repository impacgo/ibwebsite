import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ironingboy/Screens/revieworder.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:ironingboy/cartpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _collectDateController = TextEditingController();
  final TextEditingController _deliverDateController = TextEditingController();
  List<Map<String, dynamic>> _addresses = [];
  String? _selectedAddressType;
  bool _isLoadingAddress = true;
  bool _changeLaundry = false;
  bool _tipEnabled = false;
  double? _selectedTip;
  final List<int> tipOptions = [2, 5, 10];
  DateTime? _collectDate;
  DateTime? _deliverDate;
  String? _selectedCollectTimeSlot;
  String? _selectedDeliverTimeSlot;

  Widget _buildDriverTip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _tipEnabled,
              onChanged: (val) {
                setState(() {
                  _tipEnabled = val ?? false;
                  if (!_tipEnabled) _selectedTip = null;
                });
              },
            ),
            const Text(
              "Tip to the driver",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        if (_tipEnabled)
          Wrap(
            spacing: 8,
            children: [
              ...tipOptions.map((tip) {
                bool isSelected = _selectedTip == tip.toDouble();
                return ChoiceChip(
                  label: Text("+£$tip"),
                  selected: isSelected,
                  selectedColor: Colors.green,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedTip = tip.toDouble();
                    });
                  },
                );
              }),
              ChoiceChip(
                label: const Text("Custom +"),
                selected: false,
                onSelected: (_) => _showCustomTipDialog(),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final _authToken = prefs.getString('jwtToken');

      if (_authToken != null) {
        final response = await http.get(
          Uri.parse('${base.baseUrl}/addresses'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            _addresses = List<Map<String, dynamic>>.from(data);
            if (_addresses.isNotEmpty) {
              final home = _addresses.firstWhere(
                (a) => (a['address_type'] as String?)?.toLowerCase() == 'home',
                orElse: () => _addresses.first,
              );
              _selectedAddressType = home['address_type'];
            }
            _isLoadingAddress = false;
          });
        } else {
          setState(() => _isLoadingAddress = false);
        }
      } else {
        setState(() => _isLoadingAddress = false);
      }
    } catch (e) {
      setState(() => _isLoadingAddress = false);
    }
  }

  Widget _buildSlotTile(
      BuildContext context, String title, TextEditingController controller, bool isCollect) {
    String subtitleText = "Select date";
    if (controller.text.isNotEmpty) {
      subtitleText = controller.text;
    } else if ((isCollect && _collectDate != null) || (!isCollect && _deliverDate != null)) {
      subtitleText = "Select time";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.blue),
        title: Text(title),
        subtitle: Text(
          subtitleText,
          style: TextStyle(
            color: subtitleText != "Select date" && subtitleText != "Select time"
                ? Colors.black54
                : Colors.red,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _selectDate(context, isCollect),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCollect) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      setState(() {
        if (isCollect) {
          _collectDate = picked;
          _collectDateController.text = formattedDate;
          _selectedCollectTimeSlot = null; 
        } else {
          _deliverDate = picked;
          _deliverDateController.text = formattedDate;
          _selectedDeliverTimeSlot = null; 
        }
      });
      if (isCollect) {
        _selectTimeSlot(context, picked, true);
      } else {
        if (_collectDate != null && picked.isBefore(_collectDate!.add(const Duration(days: 1)))) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Delivery must be at least one day after collection."),
            ),
          );
          setState(() {
            _deliverDateController.text = "";
            _deliverDate = null;
            _selectedDeliverTimeSlot = null;
          });
        } else {
          _selectTimeSlot(context, picked, false);
        }
      }
    }
  }

  void _selectTimeSlot(BuildContext context, DateTime selectedDate, bool isCollect) {
    final List<String> availableSlots = _generateTimeSlots(selectedDate, isCollect);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCollect ? "Select a Collection Time Slot" : "Select a Delivery Time Slot",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableSlots.length,
                  itemBuilder: (context, index) {
                    final slot = availableSlots[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ActionChip(
                        label: Text(slot),
                        backgroundColor: (isCollect ? _selectedCollectTimeSlot : _selectedDeliverTimeSlot) == slot
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                        onPressed: () {
                          setState(() {
                            if (isCollect) {
                              _selectedCollectTimeSlot = slot;
                              _collectDateController.text = "${_collectDateController.text}, $slot";
                            } else {
                              _selectedDeliverTimeSlot = slot;
                              _deliverDateController.text = "${_deliverDateController.text}, $slot";
                            }
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _generateTimeSlots(DateTime date, bool isCollect) {
    List<String> slots = [];
    final now = DateTime.now();
    for (int hour = 9; hour < 19; hour++) {
      final slotStart = DateTime(date.year, date.month, date.day, hour, 0);
      if (isCollect && date.day == now.day) {
        if (slotStart.isAfter(now)) {
          slots.add("${hour % 12 == 0 ? 12 : hour % 12} ${hour < 12 ? 'AM' : 'PM'} - ${(hour + 1) % 12 == 0 ? 12 : (hour + 1) % 12} ${hour + 1 < 12 ? 'AM' : 'PM'}");
        }
      } else {
        slots.add("${hour % 12 == 0 ? 12 : hour % 12} ${hour < 12 ? 'AM' : 'PM'} - ${(hour + 1) % 12 == 0 ? 12 : (hour + 1) % 12} ${hour + 1 < 12 ? 'AM' : 'PM'}");
      }
    }
    return slots;
  }

  void _showCustomTipDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Custom Tip"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter amount in £"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _selectedTip = double.tryParse(controller.text) ?? 0;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: highlight ? Colors.green : Colors.black,
              )),
        ],
      ),
    );
  }

  String _getSvgPathForAddressType(String? addressType) {
    switch ((addressType ?? '').toLowerCase()) {
      case 'home':
        return 'assets/images/Home.svg';
      case 'office':
        return 'assets/images/office.svg';
      case 'hotel':
        return 'assets/images/Hotel.svg';
      default:
        return 'assets/images/others.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartUpdated && state.items.isNotEmpty) {
              final items = state.items;
              final grandTotal =
                  items.fold<double>(0, (sum, e) => sum + e.totalPrice);
              final totalAmount = grandTotal + (_selectedTip ?? 0);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...items.map((item) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins')),
                            subtitle: Text("Quantity: ${item.qty}"),
                            trailing: Text(
                              "£${item.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),
                    const Text("Order Summary",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    _buildSummaryRow("Sub total",
                        "£${grandTotal.toStringAsFixed(2)}"),
                    _buildDriverTip(),
                    const Divider(),
                    _buildSummaryRow("Total Amount",
                        "£${totalAmount.toStringAsFixed(2)}",
                        isBold: true, highlight: true),
                    const SizedBox(height: 20),
                    const Text("My slot",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    _buildSlotTile(
                        context, "Collect from me", _collectDateController, true),
                    _buildSlotTile(context, "Deliver to me", _deliverDateController, false),
                    const SizedBox(height: 20),
                    const Text("Address Details",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    _isLoadingAddress
                        ? const Center(child: CircularProgressIndicator())
                        : _addresses.isEmpty
                            ? const Text("No saved addresses. Please add one.")
                            : Column(
                                children: _addresses.map((addr) {
                                  final addressType = addr['address_type'] as String?;
                                  final isSelected = _selectedAddressType == addressType;
                                  final svgPath = _getSvgPathForAddressType(addressType);
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected
                                          ? Border.all(color: Colors.orange, width: 2)
                                          : Border.all(color: Colors.transparent),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Radio<String>(
                                          value: addressType ?? "",
                                          groupValue: _selectedAddressType,
                                          activeColor: Colors.orange,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedAddressType = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        SvgPicture.asset(
                                          svgPath,
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (addr['name'] as String?) ?? '',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                (addr['phone'] as String?) ?? '',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "${(addr['full_address'] as String?) ?? ''}, ${(addr['pincode'] as String?) ?? ''}",
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Change laundry",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                        Switch(
                          value: _changeLaundry,
                          onChanged: (val) {
                            setState(() {
                              _changeLaundry = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.orange),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Back to service",
                                style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                             
                            ),
                            onPressed: () {
                              if (_collectDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a collection date."),
                                  ),
                                );
                                return;
                              }
                              if (_selectedCollectTimeSlot == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a time slot for collection."),
                                  ),
                                );
                                return;
                              }
                              if (_deliverDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a delivery date."),
                                  ),
                                );
                                return;
                              }
                              if (_selectedDeliverTimeSlot == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a time slot for delivery."),
                                  ),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewOrderPage(
                                    collect: _collectDateController.text,
                                    delivery: _deliverDateController.text,
                                    tip: _selectedTip,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Review & Confirm"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text("Cart is empty"));
          },
        ),
      ),
    );
  }
}