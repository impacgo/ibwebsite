import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ironingboy/Screens/widgets/addresspage.dart';
import 'package:ironingboy/Screens/widgets/profile/profilepage.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});
  @override
  State<TopBar> createState() => _TopBarState();
}
class _TopBarState extends State<TopBar> {
  String _currentAddress = "Fetching location...";
  @override
  void initState() {
    super.initState();
    _getAddressFromGPS();
  }
  Future<void> _getAddressFromGPS() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _currentAddress = "Permission denied";
        });
        return;
      }
      Position position = await Geolocator.getCurrentPosition();
      await _updateAddress(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _currentAddress = "Unable to get location";
      });
    }
  }
  Future<void> _updateAddress(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _currentAddress = "${place.locality}, ${place.administrativeArea}";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressListPage()),
              );
              if (result != null) {
                await _updateAddress(result.latitude, result.longitude);
              }
            },
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    _currentAddress,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
          const Spacer(),
    GestureDetector(
      onTap: () {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
      },
      child: Container(
    width: 35,  
    height: 35,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.black, width: 1.5), 
    ),
    child: const CircleAvatar(
      radius: 18,               
      backgroundColor: Colors.white,
      child: Icon(Icons.person_outline, color: Colors.black),
    ),
      ),
    ),
        ],
      ),
    );
  }
}


