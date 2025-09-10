import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ironingboy/Screens/payment.dart';
import 'package:ironingboy/cartpage.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';

class ReviewOrderPage extends StatefulWidget {
  final String collect;
  final String delivery;
  final double? tip;
  
  const ReviewOrderPage({
    super.key,
    required this.collect,
    required this.delivery,
    this.tip,
  });
  
  @override
  State<ReviewOrderPage> createState() => _ReviewOrderPageState();
}

class _ReviewOrderPageState extends State<ReviewOrderPage> {
  List<Map<String, dynamic>> _savedAddresses = [];
  int? _selectedAddressId;
  bool _loadingAddress = true;
  
  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }
  
  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
  
  Map<String, dynamic> _normalizeAddress(Map<String, dynamic> raw) {
    final int? addressId = _toInt(raw['address_id'] ?? raw['id'] ?? raw['addressId'] ?? raw['address_id ']);
    final String addressType = (raw['address_type'] ?? raw['type'] ?? '').toString();
    final String fullAddress = (raw['full_address'] ?? raw['address'] ?? raw['fullAddress'] ?? '').toString();
    final String pincode = (raw['pincode'] ?? raw['pin'] ?? raw['postal_code'] ?? '').toString();
    final bool isSelected = (raw['is_selected'] ?? raw['isSelected'] ?? raw['selected'] ?? false) == true;
    final String name = (raw['name'] ?? '').toString();
    final String phone = (raw['phone'] ?? raw['phone_number'] ?? '').toString();
    
    return {
      'address_id': addressId,
      'address_type': addressType,
      'full_address': fullAddress,
      'pincode': pincode,
      'is_selected': isSelected,
      'name': name,
      'phone': phone,
      '__raw': raw,
    };
  }
  
  Future<void> _fetchAddresses() async {
    setState(() => _loadingAddress = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final _authToken = prefs.getString('jwtToken');

      if (_authToken == null) {
        setState(() {
          _savedAddresses = [];
          _selectedAddressId = null;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${base.baseUrl}/addresses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        try {
          final dynamic decoded = json.decode(response.body);
          if (decoded is List) {
            final normalized = decoded
                .whereType<Map<String, dynamic>>()
                .map(_normalizeAddress)
                .where((m) => _toInt(m['address_id']) != null)
                .toList();

            setState(() {
              _savedAddresses = normalized;
            });

            if (_savedAddresses.isNotEmpty) {
              int? defaultId;
              
              final autoSelected = _savedAddresses.firstWhere(
                (a) => a['is_selected'] == true,
                orElse: () => {},
              );
              if (autoSelected is Map<String, dynamic> && _toInt(autoSelected['address_id']) != null) {
                defaultId = _toInt(autoSelected['address_id']);
              } else {
                final byHome = _savedAddresses.firstWhere(
                  (a) => (a['address_type'] ?? '').toString().toLowerCase() == 'home',
                  orElse: () => {},
                );
                if (byHome is Map<String, dynamic> && _toInt(byHome['address_id']) != null) {
                  defaultId = _toInt(byHome['address_id']);
                } else {
                  final byOffice = _savedAddresses.firstWhere(
                    (a) => (a['address_type'] ?? '').toString().toLowerCase() == 'office',
                    orElse: () => {},
                  );
                  if (byOffice is Map<String, dynamic> && _toInt(byOffice['address_id']) != null) {
                    defaultId = _toInt(byOffice['address_id']);
                  } else {
                    final byHotel = _savedAddresses.firstWhere(
                      (a) => (a['address_type'] ?? '').toString().toLowerCase() == 'hotel',
                      orElse: () => {},
                    );
                    if (byHotel is Map<String, dynamic> && _toInt(byHotel['address_id']) != null) {
                      defaultId = _toInt(byHotel['address_id']);
                    } else {
                      defaultId = _toInt(_savedAddresses.first['address_id']);
                    }
                  }
                }
              }

              setState(() {
                _selectedAddressId = defaultId;
              });
            } else {
              setState(() {
                _selectedAddressId = null;
              });
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unexpected response when loading addresses.")),
              );
            }
            setState(() {
              _savedAddresses = [];
              _selectedAddressId = null;
            });
          }
        } on FormatException catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error parsing addresses: $e")),
            );
          }
          setState(() {
            _savedAddresses = [];
            _selectedAddressId = null;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load addresses: ${response.statusCode}")),
          );
        }
        setState(() {
          _savedAddresses = [];
          _selectedAddressId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading addresses: $e")),
        );
      }
      setState(() {
        _savedAddresses = [];
        _selectedAddressId = null;
      });
    } finally {
      setState(() => _loadingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Review Your Order",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartUpdated && state.items.isNotEmpty) {
              final items = state.items;
              final subtotal = items.fold<double>(0, (sum, e) => sum + e.totalPrice);
              final driverTip = widget.tip ?? 0;
              final total = subtotal + driverTip;
            
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...items.map((item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.name,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: "Poppins")),
                          subtitle: Text("${item.qty} × ${item.price}"),
                          trailing: Text(
                            "£${item.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                          ),
                        )),
                    const Divider(),
                    _buildSummaryRow("Sub Total", "£${subtotal.toStringAsFixed(2)}"),
                    _buildSummaryRow("Driver Tip", "£${driverTip.toStringAsFixed(2)}"),
                    const Divider(),
                    _buildSummaryRow("Total Amount", "£${total.toStringAsFixed(2)}", isBold: true, highlight: true),
            
                    BlocBuilder<CartExtraBloc, CartExtraState>(builder: (context, extraState) {
                      final notes = extraState.notes;
                      final images = extraState.imagePaths;
            
                      final hasNotes = notes != null && notes.trim().isNotEmpty;
                      final hasImages = images.isNotEmpty;
            
                      if (!hasNotes && !hasImages) {
                        return const SizedBox.shrink();
                      }
            
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Special Instructions"),
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (hasNotes) ...[
                                    Text(
                                      notes!,
                                      style: const TextStyle(fontFamily: "Poppins"),
                                    ),
                                  ],
                                  if (hasNotes && hasImages) const SizedBox(height: 8),
                                  if (hasImages)
                                    SizedBox(
                                      height: 110,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: images.length,
                                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                                        itemBuilder: (context, index) {
                                          final path = images[index];
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => Dialog(
                                                  child: InteractiveViewer(
                                                    child: Image.file(File(path), fit: BoxFit.contain),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey.shade200,
                                                child: Image.file(
                                                  File(path),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Center(child: Icon(Icons.broken_image));
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
            
                    const SizedBox(height: 16),
                    _buildSectionTitle("Slots"),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today, color: Colors.blue),
                        title: const Text("Pickup"),
                        subtitle: Text(widget.collect),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today, color: Colors.blue),
                        title: const Text("Dropoff"),
                        subtitle: Text(widget.delivery),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle("Address"),
                    _loadingAddress
                        ? const Center(child: CircularProgressIndicator())
                        : _savedAddresses.isEmpty
                            ? const Text("No saved addresses found.")
                            : Column(
                                children: _savedAddresses.map((addr) {
                                  final int? addrId = _toInt(addr['address_id']);
                                  if (addrId == null) return const SizedBox.shrink();
                                  
                                  return Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: RadioListTile<int>(
                                      value: addrId,
                                      groupValue: _selectedAddressId,
                                      onChanged: (val) {
                                        setState(() {
                                          _selectedAddressId = val;
                                        });
                                      },
                                      title: Text(
                                        (addr['name']?.toString().isNotEmpty == true)
                                            ? addr['name'].toString()
                                            : "No name",
                                        style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (addr['phone']?.toString().isNotEmpty == true)
                                            Text(
                                              addr['phone'].toString(),
                                              style: const TextStyle(fontFamily: "Poppins"),
                                            ),
                                          Text(
                                            "${addr['full_address'] ?? ''}, ${addr['pincode'] ?? ''}",
                                            style: const TextStyle(fontFamily: "Poppins"),
                                          ),
                                          if (addr['address_type']?.toString().isNotEmpty == true)
                                            Text(
                                              (addr['address_type']?.toString().isNotEmpty == true)
                                                  ? addr['address_type'].toString()
                                                  : "Address",
                                              style: const TextStyle(fontFamily: "Poppins"),
                                            ),
                                        ],
                                      ),
                                      secondary: _getIconForAddressType(addr['address_type']?.toString()),
                                    ),
                                  );
                                }).toList(),
                              ),
                    const SizedBox(height: 30),
                    SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () async {
        if (_selectedAddressId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select an address first")),
          );
          return;
        }
            
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwtToken');
            
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Not authenticated")),
          );
          return;
        }
            
        final selectedAddress = _savedAddresses.firstWhere(
          (addr) => _toInt(addr['address_id']) == _selectedAddressId,
          orElse: () => {},
        );
            
        if (selectedAddress is! Map<String, dynamic> || _toInt(selectedAddress['address_id']) == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Selected address not found. Please reselect.")),
          );
          return;
        }
            
        final cartExtraState = context.read<CartExtraBloc>().state;
        final notes = cartExtraState.notes;
        final images = cartExtraState.imagePaths;
            
        final itemsPayload = items.map((e) => {
              "product_id": e.id,
              "quantity": e.qty,
              "price_at_purchase": e.price,
            }).toList();
            
        final orderPayload = {
          "address_id": _toInt(selectedAddress['address_id']),
          "items": itemsPayload,
          "subtotal": subtotal,
          "tip": widget.tip ?? 0,
          "total": total,
          "collect_slot": widget.collect,
          "delivery_slot": widget.delivery,
          "notes": notes,
          "images": images,
        };
            
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
            
        try {
          final response = await http.post(
            Uri.parse('${base.baseUrl}/orders'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(orderPayload),
          );
            
          Navigator.of(context).pop();
            
          if (response.statusCode == 201) {
            context.read<CartBloc>().add(ClearCart());
            context.read<CartExtraBloc>().add(ClearExtras());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PaymentScreen(amount: total)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to create order: ${response.body}")),
            );
          }
        } catch (e) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error placing order: $e")),
          );
        }
            },
            style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // 🔑 remove default padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.transparent, // 🔑 transparent to show gradient
        shadowColor: Colors.transparent,
            ),
            child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF8B500), Color(0xFFF57C00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            "Confirm Order",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
              color: Colors.white,
            ),
          ),
        ),
            ),
        ),
            ),
            
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.orange,
                    //       padding: const EdgeInsets.symmetric(vertical: 16),
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    //     ),
                    //     onPressed: () async {
                    //       if (_selectedAddressId == null) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text("Please select an address first")),
                    //         );
                    //         return;
                    //       }
            
                    //       final prefs = await SharedPreferences.getInstance();
                    //       final token = prefs.getString('jwtToken');
            
                    //       if (token == null) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text("Not authenticated")),
                    //         );
                    //         return;
                    //       }
            
                    //       final selectedAddress = _savedAddresses.firstWhere(
                    //         (addr) => _toInt(addr['address_id']) == _selectedAddressId,
                    //         orElse: () => {},
                    //       );
            
                    //       if (selectedAddress is! Map<String, dynamic> || _toInt(selectedAddress['address_id']) == null) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text("Selected address not found. Please reselect.")),
                    //         );
                    //         return;
                    //       }
            
                    //       final cartExtraState = context.read<CartExtraBloc>().state;
                    //       final notes = cartExtraState.notes;
                    //       final images = cartExtraState.imagePaths;
            
                    //       final itemsPayload = items.map((e) => {
                    //             "product_id": e.id,
                    //             "quantity": e.qty,
                    //             "price_at_purchase": e.price,
                    //           }).toList();
            
                    //       final orderPayload = {
                    //         "address_id": _toInt(selectedAddress['address_id']),
                    //         "items": itemsPayload,
                    //         "subtotal": subtotal,
                    //         "tip": widget.tip ?? 0,
                    //         "total": total,
                    //         "collect_slot": widget.collect,
                    //         "delivery_slot": widget.delivery,
                    //         "notes": notes,
                    //         "images": images,
                    //       };
            
                    //       showDialog(
                    //         context: context,
                    //         barrierDismissible: false,
                    //         builder: (_) => const Center(child: CircularProgressIndicator()),
                    //       );
            
                    //       try {
                    //         final response = await http.post(
                    //           Uri.parse('${base.baseUrl}/orders'),
                    //           headers: {
                    //             'Content-Type': 'application/json',
                    //             'Authorization': 'Bearer $token',
                    //           },
                    //           body: json.encode(orderPayload),
                    //         );
            
                    //         Navigator.of(context).pop();
            
                    //         if (response.statusCode == 201) {
                    //           context.read<CartBloc>().add(ClearCart());
                    //           context.read<CartExtraBloc>().add(ClearExtras());
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(builder: (_) => PaymentScreen(amount: total)),
                    //           );
                    //         } else {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             SnackBar(content: Text("Failed to create order: ${response.body}")),
                    //           );
                    //         }
                    //       } catch (e) {
                    //         Navigator.of(context).pop();
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(content: Text("Error placing order: $e")),
                    //         );
                    //       }
                    //     },
                    //     child: const Text(
                    //       "Confirm Order",
                    //       style: TextStyle(
                    //           fontSize: 16, fontWeight: FontWeight.w600, fontFamily: "Poppins", color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("Your cart is empty"),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontFamily: "Poppins",
              )),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Colors.blue : Colors.black,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
}

Widget _getIconForAddressType(String? addressType) {
  String assetPath;

  switch (addressType?.toLowerCase()) {
    case 'home':
      assetPath = 'assets/images/Home.svg';
      break;
    case 'hotel':
      assetPath = 'assets/images/Hotel.svg';
      break;
    case 'other':
      assetPath = 'assets/images/other.svg';
      break;
    default:
      assetPath = 'assets/images/office.svg';
      break;
  }

  return SvgPicture.asset(
    assetPath,
    colorFilter: const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
    width: 24,
    height: 24,
  );
}