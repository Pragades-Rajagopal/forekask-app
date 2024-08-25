import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/widgets/weather_widgets.dart';
import 'package:forekast_app/services/favorites_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<dynamic> favoritesList = [];
  List<dynamic> favoritesData = [];
  List<String> favoriteCities = [];
  late Future _favoritesWeatherFuture;
  // Services
  FavoriteWeather favoritesApi = FavoriteWeather();

  @override
  void initState() {
    super.initState();
    _favoritesWeatherFuture = _getFavoritesWeather();
  }

  Future<void> _getFavoritesWeather() async {
    // await FavoritesData.saveFavorites();
    List<Map<String, dynamic>> data = await FavoritesData.getFavorites();
    List<String> cities = data.map((city) => city["city"].toString()).toList();
    final weatherData = await favoritesApi.getWeatherForAllFavorites(cities);
    setState(() {
      favoritesList.clear();
      favoritesData.clear();
      favoritesList.addAll(data);
      favoritesData.addAll(weatherData);
    });
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
                child: Text(
                  "It's empty!\nAdd favorites by searching a city",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  children: [favoriteCards(favoritesData)],
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

  Container favoriteCards(List<dynamic> favoritesData) {
    var cardDescrStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      // fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    var cardTempStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    var cardTempStyle2 = TextStyle(
      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    var cardCityStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    var cardCityStyleItalic = TextStyle(
      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: Theme.of(context).colorScheme.secondary,
    );
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
                    // set default logic
                    print('set default');
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
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: favoritesList[index]["default"] == 'false'
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      : RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.3),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                // vertical: 20,
                              ),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: getIcon(favoritesData[index]["icon"]),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 14,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      if (favoritesList[index]["default"] ==
                                          'true') ...{
                                        Expanded(
                                          child: Text(
                                            favoritesData[index]["city"],
                                            style: cardCityStyleItalic,
                                            softWrap: true,
                                          ),
                                        ),
                                      } else ...{
                                        Expanded(
                                          child: Text(
                                            favoritesData[index]["city"],
                                            style: cardCityStyle,
                                            softWrap: true,
                                          ),
                                        ),
                                      }
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          favoritesData[index]["description"],
                                          style: cardDescrStyle,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${favoritesData[index]["temp"]}°C",
                                          style: cardTempStyle,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${favoritesData[index]["tempMax"]}/${favoritesData[index]["tempMin"]}°C",
                                        style: cardTempStyle2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
