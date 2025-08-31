// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:ironingboy/Screens/locationpage.dart';

// class AddressListPage extends StatefulWidget {
//   const AddressListPage({super.key});

//   @override
//   State<AddressListPage> createState() => _AddressListPageState();
// }

// class _AddressListPageState extends State<AddressListPage> {
//   List<Map<String, String>> savedAddresses = [
//     {
//       "name": "sai",
//       "address": "Camden Town, Landon, United Kingdom",
//       "pincode": "SW1A 1AA"
//     }
//   ];


//   Future<void> _addAddress() async {
//     final newAddress = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const LocationManagerPage(),
//       ),
//     );

//     if (newAddress != null && newAddress is Map<String, String>) {
//       setState(() {
//         savedAddresses.insert(0, newAddress);
//       });
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
//     onTap: () {
//       Navigator.pop(context);
//     },
//               child: Row(
//                 children: const [
//                   Text(
//                     "Select location",
//                     style: TextStyle( fontSize: 16, fontWeight: FontWeight.w500, fontFamily:'Poppins'),
//                   ),
//                   SizedBox(width: 4),
//                   Icon(Icons.keyboard_arrow_up),
//                 ],
//               ),
//             ),
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
//                   )
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
            
//                   InkWell(
//   onTap: () async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permission denied")),
//         );
//         return;
//       }
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       String address = '';
//       String pincode = '';
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         address =
//             "${place.locality}, ${place.administrativeArea}, ${place.country}";
//         pincode = place.postalCode ?? '';
//       }
//       Navigator.pop(context, {
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//         'address': address,
//         'pincode': pincode,
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   },
//   child: Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Icon(Icons.location_on, color: Colors.orange, size: 22),
//       const SizedBox(width: 8),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               "Use current location",
//               style: TextStyle(
//                   color: Colors.orange, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),

//                   const SizedBox(height: 12),
//                   Divider(color: Colors.grey.shade300, height: 1),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: _addAddress,
//                     child: const Center(
//                       child: Text(
//                         "+ Add address",
//                         style: TextStyle(
//                           color: Colors.orange,
//                           fontWeight: FontWeight.w500,
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
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   Expanded(child: Divider(thickness: 1)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//              Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: savedAddresses.length,
//                 itemBuilder: (context, index) {
//                   final addr = savedAddresses[index];
//                   return Container(
//                     margin: const EdgeInsets.symmetric(vertical: 6),
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         )
//                       ],
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Icon(Icons.home, color: Colors.black),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 addr['name'] ?? '',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 14),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 "${addr['address']},\n${addr['pincode']}",
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Icon(Icons.more_vert),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ironingboy/Screens/locationpage.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  // Replace with your actual backend URL
  
  List<Map<String, dynamic>> _savedAddresses = [];
  bool _isLoading = true;

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
          });
        } else {
          // Handle non-200 responses (e.g., 401 Unauthorized)
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load addresses from the server.')),
            );
          }
        }
      } else {
        // Handle case where token is not found (user is not logged in)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to view your addresses.')),
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

  Future<void> _addAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationManagerPage(),
      ),
    );
  }

  String   _getIconForAddressType(String addressType) {
    switch (addressType.toLowerCase()) {
      case 'home':
        return 'assets/images/Home.svg';
      case 'office':
        return 'assets/images/office.svg';
      case 'hotel':
        return 'assets/images/Hotel.svg';
      case 'other':
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
                onTap: () {
                  Navigator.pop(context);
                },
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
                        LocationPermission permission = await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Location permission denied")),
                            );
                          }
                          return;
                        }
                        Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );
                        List<Placemark> placemarks = await placemarkFromCoordinates(
                          position.latitude,
                          position.longitude,
                        );
                        String address = '';
                        String pincode = '';
                        if (placemarks.isNotEmpty) {
                          Placemark place = placemarks.first;
                          address = "${place.locality}, ${place.administrativeArea}, ${place.country}";
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.my_location, color: Colors.orange, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Use current location",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                    child: const Center(
                      child: Text(
                        "+ Add address",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
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
                      style: TextStyle(fontWeight: FontWeight.w500),
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
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(_getIconForAddressType(addr['address_type'] ?? 'other'), color: Colors.black),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addr['title'] ?? '',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${addr['full_address'] ?? ''},\n${addr['pincode'] ?? ''}",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Options menu coming soon!')),
                                        );
                                      }
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
