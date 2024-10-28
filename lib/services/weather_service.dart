import 'dart:convert';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:http/http.dart' as http;
import 'package:forekast_app/config/dotenv.dart';
import 'package:forekast_app/data/models/weather_model.dart';

/// Weather API model
/// - Handles weather information for a city
class WeatherApi {
  SettingsData settingsData = SettingsData();

  /// Retieves the unit preference
  ///
  /// Internally calls `Settings` model from local data
  Future<String> getUnitPreference() async {
    Map<String, dynamic> settings = await settingsData.getPreferences();
    return settings["selectedUnit"];
  }

  /// Retrieves the weather information of a city
  Future<Weather> getCurrentWeather(String? city) async {
    try {
      // Get the API key from .env file
      final env = await parseStringToMap(assetsFileName: '.env');
      String unit = await getUnitPreference();
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${env["OPENWEATHER_API_KEY_DAILY"]}&units=$unit');
      var response = await http.get(url);
      var body = jsonDecode(response.body);
      Weather weather = Weather.fromJSON(body);
      return weather;
    } catch (e) {
      return Weather.voidData();
    }
  }

  /// Retrieves the daily forecast information of a city
  Future<DailyWeather> getDailyWeather(double? lat, double? lon) async {
    try {
      final env = await parseStringToMap(assetsFileName: '.env');
      String unit = await getUnitPreference();
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=$unit&appid=${env["OPENWEATHER_API_KEY_DAILY"]}');
      var response = await http.get(url);
      var body = jsonDecode(response.body);
      DailyWeather data = DailyWeather.fromJSON(body["daily"]);
      return data;
    } catch (e) {
      return DailyWeather.voidData();
    }
  }
}
