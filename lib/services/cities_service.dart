import 'dart:convert';
import 'package:http/http.dart' as http;

class CitiesApi {
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

  // Convert country code to country name
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
