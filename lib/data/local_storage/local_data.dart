import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CitiesData {
  static Future<void> storeCities(List<String> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('cities_list', data);
  }

  static Future<List<String>?> getCities() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final list = preferences.getStringList('cities_list');
    return list;
  }
}

class FavoritesData {
  static Future<void> saveFavorites(List<Map<String, dynamic>> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(data);
    await preferences.setString('favorites', encodedData);
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final favData = preferences.getString('favorites');
    if (favData != null) {
      final List<dynamic> list = jsonDecode(favData);
      return list.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<void> removeFavorites(String city) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final favData = preferences.getString('favorites');
    if (favData != null) {
      final List<dynamic> list = jsonDecode(favData);
      list
          .cast<Map<String, dynamic>>()
          .removeWhere((item) => item["city"] == city);
      final encodedData = jsonEncode(list);
      await preferences.setString('favorites', encodedData);
    }
  }

  static Future<void> setFavoriteToDefault(String city) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final favData = preferences.getString('favorites');
    if (favData != null) {
      final List<dynamic> list = jsonDecode(favData);
      for (var city_ in list) {
        city_["default"] = city_["city"] == city;
      }
      final encodedData = jsonEncode(list);
      await preferences.setString('favorites', encodedData);
    }
  }
}
