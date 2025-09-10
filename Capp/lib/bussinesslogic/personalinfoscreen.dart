import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ironingboy/Screens/loginpage.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PersonalInfoController extends ChangeNotifier {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isEditingName = false;
  bool isEditingPhone = false;
  bool isEditingEmail = false;

  /// Load user profile data
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token != null) {
      final url = Uri.parse('${base.baseUrl}/profile');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        userData = json.decode(response.body);
        nameController.text = userData?['name'] ?? '';
        phoneController.text = userData?['phone'] ?? '';
        emailController.text = userData?['email'] ?? '';
      }
    }
    isLoading = false;
    notifyListeners();
  }

  /// Update profile field
  Future<void> updateProfile(BuildContext context, String field, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token != null) {
      final url = Uri.parse('${base.baseUrl}/profile');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({field: value}),
      );

      if (response.statusCode == 200) {
        userData?[field] = value;
        if (field == 'name') isEditingName = false;
        if (field == 'phone') isEditingPhone = false;
        if (field == 'email') isEditingEmail = false;

        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$field updated'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update $field'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Logout
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Loginpage()),
      (route) => false,
    );
  }

  /// Delete account
  Future<void> deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');
    if (token == null) return;

    final url = Uri.parse('${base.baseUrl}/profile');
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      await prefs.clear();
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully'), backgroundColor: Colors.green),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Loginpage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete account'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
