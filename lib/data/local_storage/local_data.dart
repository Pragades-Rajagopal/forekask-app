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
  static Future<void> storeThemePreference(String selectedTheme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('selected_theme', selectedTheme);
  }

  static Future<void> storeUnitPreference(String selectedTheme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('selected_unit', selectedTheme);
  }

  static Future<Map<String, dynamic>> getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final selectedTheme = preferences.getString('selected_theme') ?? 'light';
    final selectedUnit = preferences.getString('selected_unit') ?? 'metric';
    return {
      "selectedTheme": selectedTheme,
      "selectedUnit": selectedUnit,
    };
  }
}
