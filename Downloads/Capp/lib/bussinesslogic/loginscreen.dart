import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<Map<String, dynamic>> loginWithIdentifier(String identifier,String password) async {
    try {
      final response = await http.post(
        Uri.parse('${base.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier, 'password': password}),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', data['token']);
      await prefs.setBool("isLoggedIn", true);
    }
      
      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'message': data['message'] ?? 'Unknown error',
        'token': data['token'] ?? '',
      };
    } catch (e) {
      return {'success': false, 'message': 'Login error: $e'};
    }
  }
  Future<Map<String, dynamic>> checkUserExists(String identifier) async {
  try {
    final response = await http.post(
      Uri.parse('${base.baseUrl}/checkUserExists'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier}),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {
          'exists': false,
          'type': _determineIdentifierType(identifier),
        };
      }
      
      final data = jsonDecode(response.body);

      return {
        'exists': data['exists'] ?? false,
        'type': _determineIdentifierType(identifier),
      };
    } 
   
    else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Client error: The request was invalid or incomplete. Status: ${response.statusCode}.');
    } 
   
    else if (response.statusCode >= 500 && response.statusCode < 600) {
      throw Exception('Server error: Could not process the request. Please try again. Status: ${response.statusCode}.');
    } 
    else {
      throw Exception('Unexpected error. Status: ${response.statusCode}. Response: ${response.body}');
    }
  } on FormatException {
    throw Exception('Failed to parse server response. The server may have returned invalid JSON.');
  } catch (e) {
    throw Exception('Failed to check user due to a network or server issue.');
  }
}
String _determineIdentifierType(String identifier) {
  final isEmail = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(identifier);
  final isPhone = RegExp(r'^\d+$').hasMatch(identifier);
  if (isEmail) {
    return 'email';
  } else if (isPhone) {
    return 'mobile';
  } else {
    return 'unknown';
  }
}
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId: kIsWeb
            ? "310559490686-22117vgg9sv08gb4ch8e89ou61hq089b.apps.googleusercontent.com"
            : null,
      );
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return {'success': false, 'message': 'Sign-In cancelled'};

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        return {'success': false, 'message': 'Missing Google auth tokens'};
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final email = userCredential.user?.email ?? '';
      final name = userCredential.user?.displayName ?? 'Google User';
      final response = await http.post(
        Uri.parse('${base.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': email, 'name': name, 'googleSignIn': true}),
      );
      final data = json.decode(response.body);
       if (response.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', data['token']);
      await prefs.setBool("isLoggedIn", true);
    }
    
      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'message': data['message'] ?? 'Unknown error',
        'token': data['token'] ?? '',
      };
    } catch (e) {
      return {'success': false, 'message': 'Google Sign-In error: $e'};
    }
  }
}
