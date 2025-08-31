import 'package:flutter/material.dart';
import 'package:ironingboy/Screens/loginpage.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;

  final TextEditingController _phoneController = TextEditingController();
  bool _isEditingPhone = false;

  final TextEditingController _emailController = TextEditingController();
  bool _isEditingEmail = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');
    if (token != null) {
      final url = Uri.parse('${base.baseUrl}/profile');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          _nameController.text = userData!['name'] ?? '';
          _phoneController.text = userData!['phone'] ?? '';
          _emailController.text = userData!['email'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile(String field, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');
    if (token != null) {
      final url = Uri.parse('http://16.171.62.4:3000/profile');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({field: value}),
      );
      if (response.statusCode == 200) {
        setState(() {
          userData![field] = value;
          if (field == 'name') _isEditingName = false;
          if (field == 'phone') _isEditingPhone = false;
          if (field == 'email') _isEditingEmail = false;
        });
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

  Widget _infoField({
    required IconData icon,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditToggle,
    required String fieldName,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon),
        title: isEditing
            ? TextField(
                controller: controller,
                autofocus: true,
                keyboardType: keyboardType,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onSubmitted: (value) {
                  updateProfile(fieldName, value);
                },
              )
            : GestureDetector(
                onTap: onEditToggle,
                child: Text(controller.text),
              ),
        trailing: IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit_outlined),
          onPressed: () {
            if (isEditing) {
              updateProfile(fieldName, controller.text);
            } else {
              onEditToggle();
            }
          },
        ),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Personal Info'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.black87,
                      child: Text(
                        _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nameController.text.isNotEmpty ? _nameController.text : 'User',
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _infoField(
                    icon: Icons.person_outline,
                    controller: _nameController,
                    isEditing: _isEditingName,
                    onEditToggle: () => setState(() => _isEditingName = true),
                    fieldName: 'name',
                  ),
                  _infoField(
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    isEditing: _isEditingPhone,
                    onEditToggle: () => setState(() => _isEditingPhone = true),
                    fieldName: 'phone',
                    keyboardType: TextInputType.phone,
                  ),
                  _infoField(
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    isEditing: _isEditingEmail,
                    onEditToggle: () => setState(() => _isEditingEmail = true),
                    fieldName: 'email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _actionButton(
                    text: 'Log Out',
                    icon: Icons.logout_outlined,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => Loginpage()),
                        (route) => false,
                      );
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                 
                    },
                    child: const Text(
                      'Delete My Account',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

