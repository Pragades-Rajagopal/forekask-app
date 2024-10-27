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
  static final FavoritesData instance = FavoritesData.internal();
  static SharedPreferences? preferences;

  FavoritesData.internal();

  factory FavoritesData() => instance;

  Future<void> _init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> saveFavorites(List<Map<String, dynamic>> data) async {
    await _init();
    final encodedData = jsonEncode(data);
    await preferences?.setString('favorites', encodedData);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    await _init();
    final favData = preferences?.getString('favorites');
    if (favData != null) {
      final List<dynamic> list = jsonDecode(favData);
      return list.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> removeFavorites(String city) async {
    await _init();
    final favData = preferences?.getString('favorites');
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
      await preferences?.setString('favorites', encodedData);
    }
  }

  Future<void> setFavoriteToDefault(String city) async {
    await _init();
    final favData = preferences?.getString('favorites');
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
      await preferences?.setString('favorites', encodedData);
    }
  }

  Future<String> getDefaultFavorite() async {
    await _init();
    final favData = preferences?.getString('favorites');
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
  static final SettingsData instance = SettingsData.internal();
  static SharedPreferences? preferences;

  SettingsData.internal();

  factory SettingsData() => instance;

  Future<void> _init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> storeUnitPreference(String selectedTheme) async {
    await _init();
    await preferences?.setString('selected_unit', selectedTheme);
  }

  Future<Map<String, dynamic>> getPreferences() async {
    await _init();
    final selectedUnit = preferences?.getString('selected_unit') ?? 'metric';
    return {
      "selectedUnit": selectedUnit,
    };
  }
}
