import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CitiesData {
  static final CitiesData instance = CitiesData.internal();
  static SharedPreferences? preferences;

  CitiesData.internal();

  factory CitiesData() {
    return instance;
  }

  Future<void> _init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> storeDefaultCity(String city) async {
    await _init();
    await preferences!.setString('default_city', city);
  }

  Future<String?> getDefaultCity() async {
    await _init();
    return preferences!.getString('default_city');
  }

  Future<void> removeDefaultCity() async {
    await _init();
    await preferences!.remove('default_city');
  }

  Future<void> storeCities(List<String> data) async {
    await _init();
    await preferences!.setStringList('cities_list', data);
  }

  Future<List<String>?> getCities() async {
    await _init();
    return preferences!.getStringList('cities_list');
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
      // Remove the city from favorite
      list
          .cast<Map<String, dynamic>>()
          .removeWhere((item) => item["city"] == city);
      // // If the removed city was set to default, update the first favorite
      // // to default
      // bool wasDefault = list.any((item) => item["default"] == true);
      // if (list.isNotEmpty && !wasDefault) {
      //   list.first["default"] = true;
      // }
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
        if (city_["city"] == city) {
          city_["default"] = city_["default"] == true ? false : true;
        } else if (city_["city"] != city) {
          city_["default"] = false;
        }
      }
      final encodedData = jsonEncode(list);
      await preferences.setString('favorites', encodedData);
    }
  }

  static Future<String> getDefaultFavorite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final favData = preferences.getString('favorites');
    if (favData != null) {
      final List<dynamic> list = jsonDecode(favData);
      String? city = list.firstWhere((city) => city["default"] == true,
          orElse: () => null)?['city'];
      return city ?? '';
    }
    return '';
  }
}

class SettingsData {
  static Future<void> storeUnitPreference(String selectedTheme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('selected_unit', selectedTheme);
  }

  static Future<Map<String, dynamic>> getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final selectedUnit = preferences.getString('selected_unit') ?? 'metric';
    return {
      "selectedUnit": selectedUnit,
    };
  }
}
