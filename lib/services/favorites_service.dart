import 'dart:convert';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/data/models/favorites_model.dart';
import 'package:http/http.dart' as http;
import 'package:forekast_app/config/dotenv.dart';

class FavoriteWeather {
  Future<SingleFavoriteWeather> getWeatherForFavoriteCity(String city) async {
    try {
      final env = await parseStringToMap(assetsFileName: '.env');
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${env["OPENWEATHER_API_KEY_DAILY"]}&units=metric');
      var response = await http.get(url);
      var body = jsonDecode(response.body);
      SingleFavoriteWeather weather = SingleFavoriteWeather.fromJSON(body);
      return weather;
    } catch (e) {
      throw Exception('Failed to load data for $city');
    }
  }

  Future<List<Map<String, dynamic>>> getWeatherForAllFavorites(
      List<String> cities) async {
    try {
      List<Future<SingleFavoriteWeather>> futures = cities.map((city) {
        return getWeatherForFavoriteCity(city);
      }).toList();
      List<SingleFavoriteWeather> responses = await Future.wait(futures);
      List<Map<String, dynamic>> list = [];
      for (var i in responses) {
        list.add({
          "tempMin": i.tempMin,
          "tempMax": i.tempMax,
          "temp": i.temp,
          "city": i.cityName,
          "icon": i.icon,
          "description": i.description,
        });
      }
      return list;
    } catch (e) {
      throw Exception('Failed to load data for $cities');
    }
  }

  Future<bool> saveFavorites(String city) async {
    try {
      List<Map<String, dynamic>> data = await FavoritesData.getFavorites();
      if (data.length > 7) return false;
      List<Map<String, dynamic>> newData = [
        ...data,
        {"city": city, "default": "false"}
      ];
      await FavoritesData.saveFavorites(newData);
      return true;
    } catch (e) {
      throw Exception('Failed to add $city as favorite');
    }
  }

  Future<bool> favoriteExists(String city_) async {
    List<Map<String, dynamic>> data = await FavoritesData.getFavorites();
    final cityData = data.any((city) {
      return city["city"].toString().toLowerCase() ==
          city_.toString().toLowerCase();
    });
    if (cityData) return true;
    return false;
  }

  Future<int> favoritesCount() async {
    List<Map<String, dynamic>> data = await FavoritesData.getFavorites();
    return data.length;
  }
}
