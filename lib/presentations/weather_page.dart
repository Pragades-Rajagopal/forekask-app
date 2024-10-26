import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/data/models/weather_model.dart';
import 'package:forekast_app/presentations/widgets/weather_widgets.dart';
import 'package:forekast_app/services/cities_service.dart';
import 'package:forekast_app/services/favorites_service.dart';
import 'package:forekast_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  final ValueNotifier<String> selectedCity;
  const WeatherPage({super.key, required this.selectedCity});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final textController = TextEditingController();
  WeatherApi client = WeatherApi();
  CitiesApi citiesApi = CitiesApi();
  FavoriteWeather favoriteWeather = FavoriteWeather();
  Weather? data;
  DailyWeather? dailyData;
  String? country;
  bool isFavorite = false;
  int favoriteCount = 0;
  String temperatureUnit = '°C';
  String windSpeed = 'm/s';
  Icon addedFavText = const Icon(
    CupertinoIcons.heart_fill,
    color: Colors.red,
    size: 28.0,
  );
  Icon addToFavText = const Icon(
    CupertinoIcons.heart,
    color: Color(0xFFFA877F),
    size: 28.0,
  );
  final ValueNotifier<Icon> favoriteButton = ValueNotifier<Icon>(const Icon(
    CupertinoIcons.heart,
    color: Colors.grey,
  ));

  @override
  void initState() {
    super.initState();
    widget.selectedCity.addListener(_handleCityChange);
    checkFavorite(widget.selectedCity.value);
  }

  @override
  void dispose() {
    widget.selectedCity.removeListener(_handleCityChange);
    super.dispose();
  }

  void _handleCityChange() async {
    await checkFavorite(widget.selectedCity.value);
  }

  Future<void> checkFavorite(String city) async {
    isFavorite = await favoriteWeather.favoriteExists(city);
    favoriteCount = await favoriteWeather.favoritesCount();
    favoriteButton.value = isFavorite ? addedFavText : addToFavText;
  }

  Future<void> getData(String city) async {
    data = await client.getCurrentWeather(city);
    dailyData = await client.getDailyWeather(data?.lat, data?.lon);
    country = await citiesApi.getCountryName('${data?.country}');
    Map<String, dynamic> settings = await SettingsData.getPreferences();
    temperatureUnit = settings["selectedUnit"] == 'metric' ? '°C' : '°F';
    windSpeed = settings["selectedUnit"] == 'metric' ? 'm/s' : 'mph';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: weatherFutureBuilder(widget.selectedCity.value),
    );
  }

  FutureBuilder<void> weatherFutureBuilder(String city) {
    return FutureBuilder(
      future: getData(city),
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            if (data?.cityName == '') {
              return Center(
                child: Text(
                  "Oops! \nWeather info not available\nfor city '${widget.selectedCity.value}'.\nPlease search for another city.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [weatherData(data)],
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

  Container weatherData(data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          currentWeather(
            getIcon(data!.icon),
            "${data!.temp}$temperatureUnit",
            "${data!.cityName}",
            "${data!.description}",
            "$country",
            context,
          ),
          const SizedBox(
            height: 18.0,
          ),
          Text(
            'additional information',
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
          additionalInformation(
            "${data!.wind}$windSpeed ${data!.degree}",
            "${data!.humidity}%",
            "${data!.pressure}mBar",
            "${data!.feelsLike}$temperatureUnit",
            "${data!.degree}",
            context,
          ),
          const SizedBox(
            height: 18.0,
          ),
          Text(
            'daily forecast',
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          dailyForecast(dailyData!.model, temperatureUnit, context),
          const SizedBox(
            height: 8.0,
          ),
          addToFavButton(),
        ],
      ),
    );
  }

  Container addToFavButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
      ),
      child: favoriteCount < 8
          ? ValueListenableBuilder<Icon>(
              valueListenable: favoriteButton,
              builder: (context, icon, child) {
                return IconButton(
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  onPressed: () async {
                    if (favoriteButton.value == addToFavText) {
                      await favoriteWeather
                          .saveFavorites(widget.selectedCity.value);
                    }
                    favoriteButton.value = addedFavText;
                  },
                  icon: icon,
                );
              },
            )
          : null,
    );
  }
}
