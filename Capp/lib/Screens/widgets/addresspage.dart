// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:ironingboy/Screens/locationpage.dart';
// import 'package:ironingboy/Screens/widgets/navigator.dart';
// import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// class AddressListPage extends StatefulWidget {
//   const AddressListPage({super.key});

//   @override
//   State<AddressListPage> createState() => _AddressListPageState();
// }
// class _AddressListPageState extends State<AddressListPage> {
//   List<Map<String, dynamic>> _savedAddresses = [];
//   bool _isLoading = true;
//   String? _selectedAddressId;
//   @override
//   void initState() {
//     super.initState();
//     _fetchAddresses();
//   }
//   Future<void> _fetchAddresses() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final _authToken = prefs.getString('jwtToken');
//       if (_authToken != null) {
//         final response = await http.get(
//           Uri.parse('${base.baseUrl}/addresses'),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $_authToken',
//           },
//         );
//         if (response.statusCode == 200) {
//           final List<dynamic> addressesJson = json.decode(response.body);
//           setState(() {
//             _savedAddresses = addressesJson.cast<Map<String, dynamic>>();
//             final selected = _savedAddresses.firstWhere(
//   (addr) => addr['is_selected'] == true,
//   orElse: () => {},
// );
//            if (selected.isNotEmpty) {
//   _selectedAddressId = selected['address_id'].toString();
// } else if (_savedAddresses.isNotEmpty) {
//   _selectedAddressId = _savedAddresses.first['address_id'].toString();
// } else {
//   _selectedAddressId = null;
// }
//           });
//         } else {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text('Failed to load addresses from the server.')),
//             );
//           }
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('Please log in to view your addresses.')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error connecting to backend: $e')),
//         );
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// Future<void> _selectAddress(String addressId) async {
//   final prefs = await SharedPreferences.getInstance();
//   final _authToken = prefs.getString('jwtToken');

//   if (_authToken == null) return;  
//   setState(() {
//     _selectedAddressId = addressId;
//   });

//   try {
//     final response = await http.put(
//       Uri.parse('${base.baseUrl}/addresses/$addressId/select'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $_authToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       _fetchAddresses();
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to update selected address.")),
//         );
//       }
//     }
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
// }
// Future<void> deleteAddress(String addressId) async {
//   final prefs = await SharedPreferences.getInstance();
//   final _authToken = prefs.getString('jwtToken');

//   if (_authToken == null) return;

//   final url = Uri.parse("${base.baseUrl}/addresses/$addressId");

//   try {
//     final response = await http.delete(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $_authToken",
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         _savedAddresses.removeWhere((a) => a['address_id'].toString() == addressId);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Address deleted successfully")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to delete address: ${response.body}")),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error: $e")),
//     );
//   }
// }
//  Future<void> _editAddress(Map<String, dynamic> addressData) async {
//   final prefs = await SharedPreferences.getInstance();
//   final _authToken = prefs.getString('jwtToken');
//   if (_authToken == null) return;
//   final addressId = addressData['address_id'].toString();
//   final TextEditingController nameController =
//       TextEditingController(text: addressData['name']);
//   final TextEditingController phoneController =
//       TextEditingController(text: addressData['phone']);
//   final TextEditingController fullAddressController =
//       TextEditingController(text: addressData['full_address']);
//   final TextEditingController pincodeController =
//       TextEditingController(text: addressData['pincode']);
//   final result = await showDialog<bool>(
//     context: context,
//     builder: (ctx) {
//       return AlertDialog(
//         title: const Text("Edit Address"),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
//               TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
//               TextField(controller: fullAddressController, decoration: const InputDecoration(labelText: "Full Address")),
//               TextField(controller: pincodeController, decoration: const InputDecoration(labelText: "Pincode")),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text("Save"),
//           ),
//         ],
//       );
//     },
//   );

//   if (result == true) {
//     try {
//       final response = await http.put(
//         Uri.parse('${base.baseUrl}/addresses/$addressId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_authToken',
//         },
//         body: jsonEncode({
//           "name": nameController.text,
//           "phone": phoneController.text,
//           "full_address": fullAddressController.text,
//           "pincode": pincodeController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         _fetchAddresses();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Address updated successfully!")),
//           );
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Failed to update address")),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: $e")),
//         );
//       }
//     }
//   }
// }
// Future<void> _addAddress() async {
//     await SafeNavigator.push(
//       MaterialPageRoute(builder: (_) => const LocationManagerPage()),
//     );
//     _fetchAddresses();
//   }

//   String _getIconForAddressType(String? addressType) {
//     switch ((addressType ?? '').toLowerCase()) {
//       case 'home':
//         return 'assets/images/Home.svg';
//       case 'work':
//       case 'office':
//         return 'assets/images/office.svg';
//       case 'hotel':
//         return 'assets/images/Hotel.svg';
//       default:
//         return 'assets/images/others.svg';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Select location",
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     const Icon(Icons.keyboard_arrow_up),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       try {
//                         LocationPermission permission =
//                             await Geolocator.requestPermission();
//                         if (permission == LocationPermission.denied ||
//                             permission == LocationPermission.deniedForever) {
//                           if (mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text("Location permission denied")),
//                             );
//                           }
//                           return;
//                         }
//                         Position position = await Geolocator.getCurrentPosition(
//                           desiredAccuracy: LocationAccuracy.high,
//                         );
//                         List<Placemark> placemarks =
//                             await placemarkFromCoordinates(
//                           position.latitude,
//                           position.longitude,
//                         );
//                         String address = '';
//                         String pincode = '';
//                         if (placemarks.isNotEmpty) {
//                           Placemark place = placemarks.first;
//                           address =
//                               "${place.locality}, ${place.administrativeArea}, ${place.country}";
//                           pincode = place.postalCode ?? '';
//                         }
//                         if (mounted) {
//                           Navigator.pop(context, {
//                             'latitude': position.latitude,
//                             'longitude': position.longitude,
//                             'address': address,
//                             'pincode': pincode,
//                           });
//                         }
//                       } catch (e) {
//                         if (mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Error: $e")),
//                           );
//                         }
//                       }
//                     },
//                     child: Row(
//                       children: [
//                         const Icon(Icons.my_location,
//                             color: Colors.orange, size: 22),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             "Use current location",
//                             style: GoogleFonts.poppins(
//                               color: Colors.orange,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Divider(color: Colors.grey.shade300, height: 1),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: _addAddress,
//                     child: Center(
//                       child: Text(
//                         "+ Add address",
//                         style: TextStyle(
//                           color: Colors.orange,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Poppins',
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(child: Divider(thickness: 1)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text(
//                       "Saved Address",
//                       style: TextStyle(
//                           fontFamily: 'Poppins', fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   Expanded(child: Divider(thickness: 1)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _savedAddresses.isEmpty
//                       ? const Center(child: Text('No saved addresses yet.'))
//                       : ListView.builder(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           itemCount: _savedAddresses.length,
//                           itemBuilder: (context, index) {
//                             final addr = _savedAddresses[index];
//                             final String? addressType =
//                                 addr['address_type'] as String?;
//                            final String addressId = addr['address_id']?.toString() ?? "";
// final isSelected = _selectedAddressId == addressId;

//                             return Container(
//   margin: const EdgeInsets.symmetric(vertical: 6),
//   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//   decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(12),
//     border: isSelected
//         ? Border.all(color: Colors.orange, width: 2)
//         : Border.all(color: Colors.transparent),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.05),
//         blurRadius: 4,
//         offset: const Offset(0, 2),
//       ),
//     ],
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Radio<String>(
//             value: addressId,
//             groupValue: _selectedAddressId,
//             activeColor: Colors.orange,
//             onChanged: (value) {
//               if (value != null) {
//                 _selectAddress(value);
//               }
//             },
//           ),
//           const SizedBox(width: 8),
//           SvgPicture.asset(
//             _getIconForAddressType(addressType),
//             width: 24,
//             height: 24,
//             colorFilter:
//                 const ColorFilter.mode(Colors.black, BlendMode.srcIn),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   (addr['name'] as String?) ?? '',
//                   style: const TextStyle(
//                       fontFamily: 'Poppins', fontSize: 14),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   (addr['phone'] as String?) ?? '',
//                   style: const TextStyle(
//                       fontFamily: 'Poppins', fontSize: 14),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   "${(addr['full_address'] as String?) ?? ''},\n${(addr['pincode'] as String?) ?? ''}",
//                   style: const TextStyle(
//                       fontFamily: 'Poppins', fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 8),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           TextButton.icon(
//             onPressed: () => _editAddress(addr),
//             icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
//             label: const Text("Edit",
//                 style: TextStyle(color: Colors.blue, fontSize: 13)),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//   icon: const Icon(Icons.delete, color: Colors.red),
//   onPressed: () async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Confirm Delete"),
//         content: const Text("Are you sure you want to delete this address?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       deleteAddress(addr['address_id'].toString());
//     }
//   },
// ),


//         ],
//       ),
//     ],
//   ),
// );

//                           },
//                         ),
//             ),  
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/screens/address_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironingboy/Screens/locationpage.dart';
import 'package:ironingboy/Screens/widgets/navigator.dart';
import 'package:ironingboy/bussinesslogic/addressscreen.dart';

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
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    try {
      final addresses = await AddressService.fetchAddresses();
      setState(() {
        _savedAddresses = addresses;
        final selected = _savedAddresses.firstWhere(
          (addr) => addr['is_selected'] == true,
          orElse: () => {},
        );
        if (selected.isNotEmpty) {
          _selectedAddressId = selected['address_id'].toString();
        } else if (_savedAddresses.isNotEmpty) {
          _selectedAddressId = _savedAddresses.first['address_id'].toString();
        } else {
          _selectedAddressId = null;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading addresses: $e")),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectAddress(String id) async {
    setState(() => _selectedAddressId = id);
    try {
      await AddressService.selectAddress(id);
      _loadAddresses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting address: $e")),
      );
    }
  }

  Future<void> _deleteAddress(String id) async {
    try {
      await AddressService.deleteAddress(id);
      setState(() {
        _savedAddresses.removeWhere((a) => a['address_id'].toString() == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting address: $e")),
      );
    }
  }

  Future<void> _editAddress(Map<String, dynamic> addr) async {
    final nameController = TextEditingController(text: addr['name']);
    final phoneController = TextEditingController(text: addr['phone']);
    final fullAddressController =
        TextEditingController(text: addr['full_address']);
    final pincodeController = TextEditingController(text: addr['pincode']);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Address"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name")),
              TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone")),
              TextField(
                  controller: fullAddressController,
                  decoration: const InputDecoration(labelText: "Full Address")),
              TextField(
                  controller: pincodeController,
                  decoration: const InputDecoration(labelText: "Pincode")),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Save")),
        ],
      ),
    );

    if (result == true) {
      try {
        await AddressService.updateAddress(addr['address_id'].toString(), {
          "name": nameController.text,
          "phone": phoneController.text,
          "full_address": fullAddressController.text,
          "pincode": pincodeController.text,
        });
        _loadAddresses();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address updated successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating address: $e")),
        );
      }
    }
  }

  Future<void> _addAddress() async {
    await SafeNavigator.push(
        MaterialPageRoute(builder: (_) => const LocationManagerPage()));
    _loadAddresses();
  }

  String _getIconForType(String? type) {
    switch ((type ?? '').toLowerCase()) {
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

            // 🔹 Current Location + Add New
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
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        LocationPermission permission =
                            await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied ||
                            permission == LocationPermission.deniedForever) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Location permission denied")),
                          );
                          return;
                        }
                        Position position =
                            await Geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high);
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
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
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Saved Addresses Label
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
                          fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 🔹 Address List
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
                            final String? addressType =
                                addr['address_type'] as String?;
                            final String addressId =
                                addr['address_id']?.toString() ?? "";
                            final isSelected = _selectedAddressId == addressId;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Radio<String>(
                                        value: addressId,
                                        groupValue: _selectedAddressId,
                                        activeColor: Colors.orange,
                                        onChanged: (value) {
                                          if (value != null) {
                                            _selectAddress(value);
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      SvgPicture.asset(
                                        _getIconForType(addressType),
                                        width: 24,
                                        height: 24,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.black, BlendMode.srcIn),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (addr['name'] as String?) ?? '',
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              (addr['phone'] as String?) ?? '',
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${(addr['full_address'] as String?) ?? ''},\n${(addr['pincode'] as String?) ?? ''}",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => _editAddress(addr),
                                        icon: const Icon(Icons.edit,
                                            size: 18, color: Colors.blue),
                                        label: const Text("Edit",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13)),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text("Confirm Delete"),
                                              content: const Text(
                                                  "Are you sure you want to delete this address?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, false),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  child: const Text("Delete",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            _deleteAddress(
                                                addr['address_id'].toString());
                                          }
                                        },
                                      ),
                                    ],
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
