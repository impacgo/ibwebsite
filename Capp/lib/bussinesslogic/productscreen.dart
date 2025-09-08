import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 
import 'commonbaseurl.dart';
class Productscreen {  
  static Future<List<Map<String, dynamic>>> fetchProducts(int categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken'); 
    if (token == null) {
      throw Exception("No token found. Please login again.");
    }
    final response = await http.get(
      Uri.parse("${base.baseUrl}/products?categoryId=$categoryId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map && data.containsKey("data")) {
        return List<Map<String, dynamic>>.from(data["data"]);
      }
      if (data is List) {
        return data.map((item) => {
          "id": item["id"] ?? "null",
          "name": item["name"],
          "price": item["price"],
         "emoji": item["emoji"] ?? "🧺",
        }).toList();
      }
      throw Exception("Unexpected response format: ${response.body}");
    } else {
      throw Exception("Failed to load products: ${response.body}");
    }
  }
}



