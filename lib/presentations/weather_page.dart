import 'package:flutter/material.dart';
import 'package:forekast_app/data/models/weather_model.dart';
import 'package:forekast_app/presentations/widgets/weather_widgets.dart';
import 'package:forekast_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final textController = TextEditingController();
  // setting default search city
  var searchCity = 'dakar';

  WeatherApi client = WeatherApi();
  Weather? data;
  DailyWeather? dailyData;
  String? country;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getData(String city) async {
    data = await client.getCurrentWeather(city);
    dailyData = await client.getDailyWeather(data?.lat, data?.lon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: weatherFutureBuilder(searchCity),
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
                  "Oops! \nWeather info not available.\nPlease search for another city.",
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

  SingleChildScrollView weatherData(data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          currentWeather(
            getIcon(data!.icon),
            "${data!.temp}°C",
            "${data!.cityName}",
            "${data!.description}",
            context,
          ),
          const SizedBox(
            height: 18.0,
          ),
          Text(
            'additional information',
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          additionalInformation(
            "${data!.wind}m/s ${data!.degree}",
            "${data!.humidity}%",
            "${data!.pressure}hPa",
            "${data!.feelsLike}°C",
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
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          dailyForecast(dailyData!.model, context),
        ],
      ),
    );
  }
}
