import 'dart:convert';
import 'package:http/http.dart' as http;

/// Cities API model
/// - Retrieves all cities for city search
/// - Retrieves country name by country code
class CitiesApi {
  /// Retrieves all cities for city search
  Future<List<String>> getCities() async {
    List<String> cities = [];
    var url = Uri.parse('https://countriesnow.space/api/v0.1/countries');
    var response = await http.get(url);
    var body = jsonDecode(response.body);
    for (var element in body['data']) {
      for (var city in element["cities"]) {
        cities.add(city);
      }
    }
    return cities;
  }

  /// Retrieves country name by country code
  Future<String> getCountryName(String code) async {
    try {
      var url = Uri.parse('https://restcountries.com/v3.1/alpha/$code');
      var response = await http.get(url);
      var body = jsonDecode(response.body);
      return body[0]['name']["common"];
    } catch (e) {
      return "";
    }
  }
}
