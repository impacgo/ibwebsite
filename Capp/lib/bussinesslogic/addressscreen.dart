// lib/services/address_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../bussinesslogic/commonbaseurl.dart';

class AddressService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  static Future<List<Map<String, dynamic>>> fetchAddresses() async {
    final token = await _getToken();
    if (token == null) throw Exception("Not logged in");

    final response = await http.get(
      Uri.parse('${base.baseUrl}/addresses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to fetch addresses: ${response.body}");
    }
  }

  static Future<void> selectAddress(String addressId) async {
    final token = await _getToken();
    if (token == null) return;

    final response = await http.put(
      Uri.parse('${base.baseUrl}/addresses/$addressId/select'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to select address: ${response.body}");
    }
  }

  static Future<void> deleteAddress(String addressId) async {
    final token = await _getToken();
    if (token == null) return;

    final response = await http.delete(
      Uri.parse("${base.baseUrl}/addresses/$addressId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete address: ${response.body}");
    }
  }

  static Future<void> updateAddress(String id, Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) return;

    final response = await http.put(
      Uri.parse('${base.baseUrl}/addresses/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update address: ${response.body}");
    }
  }
}
