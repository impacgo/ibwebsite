import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ironingboy/Screens/confirmorder.dart';
import 'package:ironingboy/cartpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  String? _selectedAddressId;
  bool _loadingAddress = true;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }
  Future<void> _fetchAddresses() async {
    setState(() => _loadingAddress = true);
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
          final List<dynamic> addressesJson = json.decode(response.body);
          setState(() {
            _savedAddresses = addressesJson.cast<Map<String, dynamic>>();

            if (_savedAddresses.isNotEmpty) {
              String? defaultId;
              for (var addr in _savedAddresses) {
                final type =
                    (addr['address_type'] ?? '').toString().toLowerCase();
                if (type == "home") {
                  defaultId = addr['address_type'].toString();
                  break;
                } else if (type == "office") {
                  defaultId ??= addr['address_type'].toString();
                } else if (type == "hotel") {
                  defaultId ??= addr['address_type'].toString();
                } else {
                  defaultId ??= addr['address_type'].toString();
                }
              }
              _selectedAddressId = defaultId;
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading addresses: $e")),
        );
      }
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
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated && state.items.isNotEmpty) {
            final items = state.items;
            final subtotal =
                items.fold<double>(0, (sum, e) => sum + e.totalPrice);
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
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins")),
                        subtitle: Text("${item.qty} × ${item.price}"),
                        trailing: Text(
                          "₹${item.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins"),
                        ),
                      )),
                  const Divider(),
                  _buildSummaryRow("Sub Total", "₹${subtotal.toStringAsFixed(2)}"),
                  _buildSummaryRow(
                      "Driver Tip", "₹${driverTip.toStringAsFixed(2)}"),
                  const Divider(),
                  _buildSummaryRow("Total Amount", "₹${total.toStringAsFixed(2)}",
                      isBold: true, highlight: true),
                 
                  BlocBuilder<CartExtraBloc, CartExtraState>(
                      builder: (context, extraState) {
                    final notes = extraState.notes;
                    final images = extraState.imagePaths;

                    final hasNotes = notes != null && notes.trim().isNotEmpty;
                    final hasImages = images.isNotEmpty;

                    if (!hasNotes && !hasImages) {
                      _buildSectionTitle("Special Instructions");
                       return const SizedBox.shrink();
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final path = images[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            child: InteractiveViewer(
                                              child: Image.file(File(path),
                                                  fit: BoxFit.contain),
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
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                  child: Icon(Icons.broken_image));
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
                    );
                  }),

                  const SizedBox(height: 16),

                  _buildSectionTitle("Slots"),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.blue),
                      title: const Text("Pickup"),
                      subtitle: Text(widget.collect),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.blue),
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
                                final addrId = addr['address_type'].toString();
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: RadioListTile<String>(
                                    value: addrId,
                                    groupValue: _selectedAddressId,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedAddressId = val;
                                      });
                                    },
                                    title: Text(addr['address_type'] ?? "No title"),
                                    subtitle: Text(
                                      "${addr['full_address'] ?? ''}, ${addr['pincode'] ?? ''}",
                                    ),
                                    secondary: _getIconForAddressType(
                                        addr['address_type']?.toString()),
                                  ),
                                );
                              }).toList(),
                            ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_selectedAddressId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select an address first")),
                          );
                          return;
                        }
                        context.read<CartBloc>().add(ClearCart());
                        context.read<CartExtraBloc>().add(ClearExtras());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const OrderPlacedScreen()));
                      },
                      child: const Text(
                        "Confirm Order",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            color: Colors.white),
                      ),
                    ),
                  ),
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

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, bool highlight = false}) {
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