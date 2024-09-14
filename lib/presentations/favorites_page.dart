import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/data/models/weather_model.dart';
import 'package:forekast_app/presentations/widgets/favorites_widgets.dart';
import 'package:forekast_app/services/favorites_service.dart';
import 'package:forekast_app/services/weather_service.dart';

class FavoritesPage extends StatefulWidget {
  final Function(String) onCitySelected;
  final String currentLocation;
  const FavoritesPage({
    super.key,
    required this.onCitySelected,
    required this.currentLocation,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<dynamic> favoritesList = [];
  List<dynamic> favoritesData = [];
  List<String> favoriteCities = [];
  String temperatureUnit = '°C';
  late Future _favoritesWeatherFuture;
  // Services
  FavoriteWeather favoritesApi = FavoriteWeather();
  WeatherApi weatherApi = WeatherApi();
  Map<String, dynamic> currentLocationWeatherData = {};

  @override
  void initState() {
    super.initState();
    _favoritesWeatherFuture = _getFavoritesWeather();
  }

  Future<void> _getFavoritesWeather() async {
    Map<String, dynamic> settings = await SettingsData.getPreferences();
    List<Map<String, dynamic>> data = await FavoritesData.getFavorites();
    List<String> cities = data.map((city) => city["city"].toString()).toList();
    final weatherData = await favoritesApi.getWeatherForAllFavorites(cities);
    if (widget.currentLocation.isNotEmpty) {
      Weather currentLocationWeather_ =
          await weatherApi.getCurrentWeather(widget.currentLocation);
      print(currentLocationWeather_.cityName!.isEmpty);
      setState(() {
        currentLocationWeatherData["city"] =
            currentLocationWeather_.cityName!.isEmpty
                ? ''
                : currentLocationWeather_.cityName;
        currentLocationWeatherData["temp"] = currentLocationWeather_.temp;
        currentLocationWeatherData["tempMax"] = currentLocationWeather_.tempMax;
        currentLocationWeatherData["tempMin"] = currentLocationWeather_.tempMin;
        currentLocationWeatherData["icon"] = currentLocationWeather_.icon;
        currentLocationWeatherData["description"] =
            currentLocationWeather_.description;
      });
    }
    setState(() {
      temperatureUnit = settings["selectedUnit"] == 'metric' ? '°C' : '°F';
      favoritesList.clear();
      favoritesData.clear();
      favoritesList.addAll(data);
      favoritesData.addAll(weatherData);
    });
  }

  Future<void> _setFavoriteToDefault(String city) async {
    await FavoritesData.setFavoriteToDefault(city);
  }

  Future<void> _removeFavorites(String city) async {
    await FavoritesData.removeFavorites(city);
    await _getFavoritesWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: weatherFutureBuilder(),
    );
  }

  FutureBuilder<void> weatherFutureBuilder() {
    return FutureBuilder(
      future: _favoritesWeatherFuture,
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            if (favoritesData.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (currentLocationWeatherData["city"] != '') ...{
                      currentLocationWeatherCard(
                        context,
                        currentLocationWeatherData,
                      )
                    },
                    Text(
                      "It's empty!\nAdd favorites by searching a city",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    if (currentLocationWeatherData["city"] != '') ...{
                      currentLocationWeatherCard(
                        context,
                        currentLocationWeatherData,
                      )
                    },
                    favoriteCards(favoritesData),
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          }
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          );
        } catch (e) {
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          );
        }
      },
    );
  }

  Widget currentLocationWeatherCard(
    BuildContext context,
    Map<String, dynamic> currentLocationWeather,
  ) {
    if (currentLocationWeather["city"] != null) {
      return GestureDetector(
        onTap: () {
          widget.onCitySelected(currentLocationWeather["city"]);
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          width: 400.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              currentLocationCardWidget(
                context,
                currentLocationWeather,
                temperatureUnit,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Container favoriteCards(List<dynamic> favoritesData) {
    void updateFavoriteCard(int setDefaultIndex, int prevDefaultIndex) {
      setState(() {
        favoritesList[setDefaultIndex]["default"] = true;
        if (prevDefaultIndex != -1) {
          favoritesList[prevDefaultIndex]["default"] = false;
        }
      });
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      width: 400.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(favoritesList[index]["city"]),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // if (favoritesList[index]["default"] == true) return false;
                    await _setFavoriteToDefault(favoritesList[index]["city"]);
                    int prevDefaultIndex = favoritesList
                        .indexWhere((city) => city["default"] == true);
                    updateFavoriteCard(index, prevDefaultIndex);
                    return false;
                  }
                  final removeCity = favoritesList[index]["city"];
                  favoritesList.removeAt(index);
                  _removeFavorites(removeCity);
                  return true;
                },
                background: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                  padding: const EdgeInsets.only(left: 14.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'set as default',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                  padding: const EdgeInsets.only(right: 14.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'remove',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.red.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.onCitySelected(favoritesData[index]["city"]);
                  },
                  child: favoriteCardsWidget(
                    context,
                    favoritesData,
                    favoritesList,
                    temperatureUnit,
                    index,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
