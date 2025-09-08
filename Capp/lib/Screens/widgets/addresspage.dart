import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ironingboy/Screens/locationpage.dart';
import 'package:ironingboy/Screens/widgets/navigator.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  List<Map<String, dynamic>> _savedAddresses = [];
  bool _isLoading = true;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    setState(() {
      _isLoading = true;
    });

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
            
            if (_savedAddresses.isNotEmpty && _selectedAddressId == null) {
              _selectedAddressId = _savedAddresses.first['_id'] as String?;
            }
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Failed to load addresses from the server.')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please log in to view your addresses.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to backend: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final prefs = await SharedPreferences.getInstance();
    final _authToken = prefs.getString('jwtToken');

    if (_authToken == null) return;

    try {
      final response = await http.delete(
        Uri.parse('${base.baseUrl}/addresses/$addressId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _savedAddresses.removeWhere((addr) => addr['_id'] == addressId);
          if (_selectedAddressId == addressId) {
            _selectedAddressId = _savedAddresses.isNotEmpty ? _savedAddresses.first['_id'] as String? : null;
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address deleted successfully!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete address.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editAddress(Map<String, dynamic> addressData) async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => LocationManagerPage(addressToEdit: addressData),
    //   ),
    // );
    _fetchAddresses();
  }

  Future<void> _addAddress() async {
    await SafeNavigator.push(
  MaterialPageRoute(builder: (_) => const LocationManagerPage()),
 
);

    _fetchAddresses();
  }

  String _getIconForAddressType(String? addressType) {
    switch ((addressType ?? '').toLowerCase()) {
      case 'home':
        return 'assets/images/Home.svg';
      case 'work':
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Text(
                      "Select location",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_up),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        LocationPermission permission =
                            await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied ||
                            permission == LocationPermission.deniedForever) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Location permission denied")),
                            );
                          }
                          return;
                        }
                        Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                          position.latitude,
                          position.longitude,
                        );
                        String address = '';
                        String pincode = '';
                        if (placemarks.isNotEmpty) {
                          Placemark place = placemarks.first;
                          address =
                              "${place.locality}, ${place.administrativeArea}, ${place.country}";
                          pincode = place.postalCode ?? '';
                        }
                        if (mounted) {
                          Navigator.pop(context, {
                            'latitude': position.latitude,
                            'longitude': position.longitude,
                            'address': address,
                            'pincode': pincode,
                          });
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.my_location,
                            color: Colors.orange, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Use current location",
                            style: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade300, height: 1),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _addAddress,
                    child: Center(
                      child: Text(
                        "+ Add address",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Saved Address",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
  child: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : _savedAddresses.isEmpty
          ? const Center(child: Text('No saved addresses yet.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _savedAddresses.length,
              itemBuilder: (context, index) {
                final addr = _savedAddresses[index];
                final String? addressType = addr['address_type'] as String?;
                if (_selectedAddressId == null &&
                    addressType?.toLowerCase() == 'home') {
                  _selectedAddressId = addressType;
                }

                final isSelected = _selectedAddressId == addressType;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                        groupValue: _selectedAddressId,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() {
                            _selectedAddressId = value;
                          });
                        },
                      ),
                      const SizedBox(width: 8),

                      SvgPicture.asset(
                        _getIconForAddressType(addressType),
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (addr['name'] as String?) ?? '',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                              Text(
                              (addr['phone'] as String?) ?? '',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${(addr['full_address'] as String?) ?? ''},\n${(addr['pincode'] as String?) ?? ''}",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Edit'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _editAddress(addr);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete,
                                          color: Colors.red),
                                      title: const Text('Delete'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        final addressId =
                                            addr['_id'] as String?;
                                        if (addressId != null) {
                                          _deleteAddress(addressId);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
),

          ],
        ),
      ),
    );
  }
}