
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManagerPage extends StatefulWidget {
  const LocationManagerPage({super.key, });

  @override
  State<LocationManagerPage> createState() => _LocationManagerPageState();
}

class _LocationManagerPageState extends State<LocationManagerPage> {
  GoogleMapController? _mapController;
  LatLng _currentCenter = const LatLng(20.5937, 78.9629);

  final ValueNotifier<String> _addressNotifier = ValueNotifier("Fetching location...");
  String _postalCode = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _additionalController = TextEditingController();

  bool _isLoadingLocation = true;
  bool _isSaving = false;
  bool _isFetchingUser = true;
  String _selectedAddressType = "";

  Timer? _debounceTimer;

  final String homeIconUrl = 'assets/images/Home.svg';
  final String officeIconUrl = 'assets/images/office.svg';
  final String hotelIconUrl = 'assets/images/Hotel.svg';
  final String othersIconUrl = 'assets/images/others.svg';
 
  String? _jwtToken;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _detectUserLocation();
  }

  @override
  void dispose() {
    _additionalController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressNotifier.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _jwtToken = prefs.getString('jwtToken');

      if (_jwtToken == null) {
        if (!mounted) return;
        setState(() {
          _isFetchingUser = false;
        });
        return;
      }

      final url = Uri.parse('${base.baseUrl}/profile');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jwtToken',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _isFetchingUser = false;
        });
      } else {
        setState(() {
          _isFetchingUser = false;
        });
      
        if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unauthorized. Please log in again.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load user data.')));
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isFetchingUser = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error while fetching user data.')));
    }
  }

  Future<void> _detectUserLocation() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var status = await Permission.location.status;
      if (status.isDenied || status.isRestricted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          if (!mounted) return;
          _addressNotifier.value = "Location permission denied";
          _isLoadingLocation = false;
          return;
        }
      }
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      if (!mounted) return;
      _addressNotifier.value = "Location services disabled";
      _isLoadingLocation = false;
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _moveCamera(LatLng(position.latitude, position.longitude));
    } catch (e) {
      if (!mounted) return;
      _addressNotifier.value = "Unable to get location";
      _isLoadingLocation = false;
    }
  }

  void _moveCamera(LatLng target) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
    _currentCenter = target;
    _getAddressFromLatLng(target);
  }

  void _debounceGetAddressFromLatLng(LatLng pos) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _getAddressFromLatLng(pos);
    });
  }

  Future<void> _getAddressFromLatLng(LatLng? pos) async {
    if (pos == null) return;
    try {
      _addressNotifier.value = "Fetching address...";
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final newAddress = "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}"
            .replaceAll(RegExp(r', ,'), ',').trim();
        _addressNotifier.value = newAddress;
        _postalCode = place.postalCode ?? "";
      } else {
        _addressNotifier.value = "Address not found";
        _postalCode = "";
      }
    } catch (e) {
      if (!mounted) return;
      _addressNotifier.value = "Unable to get address";
      _postalCode = "";
    } finally {
      if (!mounted) return;
      _isLoadingLocation = false;
    }
  }


Future<void> _saveLocation() async {
    if (_jwtToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }

    if (_addressNotifier.value.isEmpty || _addressNotifier.value == 'Fetching address...') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an address type and a valid address.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${base.baseUrl}/addresses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jwtToken',
        },
        body: json.encode({
          'address_type': _selectedAddressType,
          'full_address': _addressNotifier.value,
          'additional_details': _additionalController.text,
          'pincode': _postalCode,
          'latitude': _currentCenter.latitude,
          'longitude': _currentCenter.longitude,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address saved successfully!')),
        );
        // Navigate back or to a confirmation page
      } else if (response.statusCode == 409) {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'An address of this type already exists.')),
        );
      } else {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Failed to save address.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Failed to connect to server.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _currentCenter,
                zoom: 5,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onCameraMove: (pos) {
                _currentCenter = pos.target;
              },
              onCameraIdle: () {
                _debounceGetAddressFromLatLng(_currentCenter);
              },
            ),
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.location_pin, size: 50, color: Colors.red),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Your location",
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.keyboard_arrow_up),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.2,
              maxChildSize: 0.55,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address Details", style: GoogleFonts.inter(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        _buildAddressTextField(),
                        const SizedBox(height: 8),
                        _buildAdditionalDetailsTextField(),
                        const SizedBox(height: 16),
                        Text("Personal Details", style: GoogleFonts.inter(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        _isFetchingUser
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  _buildPersonalDetailsTextField("Name", _nameController, Icons.person),
                                  const SizedBox(height: 8),
                                  _buildPersonalDetailsTextField("Phone Number", _phoneController, Icons.phone),
                                ],
                              ),
                        const SizedBox(height: 12),
                        _buildAddressTypeButtons(),
                        const SizedBox(height: 16),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTextField() {
    return ValueListenableBuilder<String>(
      valueListenable: _addressNotifier,
      builder: (context, currentAddress, child) {
        return TextField(
          key: ValueKey(currentAddress),
          readOnly: true,
          controller: TextEditingController(text: currentAddress),
          decoration: InputDecoration(
            hintText: "Fetching location...",
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
            prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
          ),
        );
      },
    );
  }

  Widget _buildAdditionalDetailsTextField() {
    return TextField(
      controller: _additionalController,
      decoration: _inputDecoration("Add additional details (optional)"),
    );
  }

  Widget _buildPersonalDetailsTextField(String hint, TextEditingController controller, IconData icon) {
    return TextField(
      decoration: _inputDecoration(hint, icon: icon),
      controller: controller,
      readOnly: true, 
    );
  }

  Widget _buildAddressTypeButtons() {
    return Row(
      children: [
        _addressTypeButton(homeIconUrl, "Home"),
       _addressTypeButton(officeIconUrl, "Office"),
        _addressTypeButton(hotelIconUrl, "Hotel"),
        _addressTypeButton(othersIconUrl, "Others"),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF8AA01), Color(0xFFF58501)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveLocation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : Text("Save", style: GoogleFonts.inter(textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget _addressTypeButton(String imageUrl, String label) {
    final bool isSelected = _selectedAddressType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAddressType = label;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageUrl,
                width: 20,
                height: 20,
                colorFilter: isSelected ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
                placeholderBuilder: (context) => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.inter(fontSize: 10, color: isSelected ? Colors.white : Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
    );
  }
}