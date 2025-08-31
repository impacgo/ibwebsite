import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignupResult {
  final bool success;
  final String message;
  SignupResult({required this.success, required this.message});
}
class Signupscreen {
  static Future<SignupResult> signup({
    required String name, 
    required String email,
    required String phone,
    required String password
  }) async {
    try {
      final response = await http.post(  
        Uri.parse('${base.baseUrl}/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'phone': phone,'password':password}),
      );
      final data = json.decode(response.body);
      if (data['success'] == true){
          final prefs = await SharedPreferences.getInstance();
         await prefs.setString('jwtToken', data['token']);
        return SignupResult(success: true, message: "Success");
      }else{ 
        return SignupResult( 
          success: false,
          message: data['error'] == 'User already exists'
              ? 'User already exists. Please login.'
              : 'Signup Failed: ${data['error']}',          
        );
      }
    } catch (e){
      return SignupResult(success: false, message: "Something went wrong.");
    }
  }
}
