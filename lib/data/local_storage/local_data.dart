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
