import 'package:flutter/cupertino.dart';
import 'package:forekast_app/presentations/widgets/favorite_weather_card.dart';

Widget favoriteCardsWidget(
  BuildContext context,
  Map<String, dynamic> weatherData, // weather info of a favorites city
  Map<String, dynamic> favoriteMap, // city with default flag
  String temperatureUnit,
  int index,
) {
  IconData? icon =
      favoriteMap["default"] == true ? CupertinoIcons.house_alt_fill : null;
  return FavoriteWeatherCard(
    weatherData: weatherData,
    temperatureUnit: temperatureUnit,
    icon: icon,
  );
}

Widget currentLocationCardWidget(
  BuildContext context,
  Map<String, dynamic> data,
  String temperatureUnit,
) {
  return FavoriteWeatherCard(
    weatherData: data,
    temperatureUnit: temperatureUnit,
    icon: CupertinoIcons.location_fill,
  );
}
