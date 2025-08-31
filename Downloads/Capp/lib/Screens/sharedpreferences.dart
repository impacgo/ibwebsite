import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefsHelper {
  static const _selectedCategoryKey = "selectedCategory";
  static const _selectedServiceKey = "selectedService";
  static const _itemsKey = "items";

  
  static Future<void> saveSelectedCategory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_selectedCategoryKey, index);
  }

  
  static Future<int> getSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedCategoryKey) ?? 0;
  }

  
  static Future<void> saveSelectedService(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_selectedServiceKey, index);
  }

  
  static Future<int> getSelectedService() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedServiceKey) ?? 0;
  }

  
  static Future<void> saveItems(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_itemsKey, jsonEncode(items));
  }


  static Future<List<Map<String, dynamic>>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_itemsKey);
    if (data != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    }
    return [];
  }
}
