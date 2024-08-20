import 'package:flutter/material.dart';
import 'package:forekast_app/presentations/widgets/weather_widgets.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List data = [
    {
      "tempMin": 13,
      "tempMax": 18,
      "temp": 15,
      "city": "Noril'sk",
      "icon": "11d",
      "description": "Scattered thunderstorm"
    },
    {
      "tempMin": 12,
      "tempMax": 19,
      "temp": 13,
      "city": "Casablanca",
      "icon": "13d",
      "description": "Snowy"
    },
    {
      "tempMin": 9,
      "tempMax": 16,
      "temp": 10,
      "city": "Pretoria",
      "icon": "02d",
      "description": "Cloudy"
    },
    {
      "tempMin": 13,
      "tempMax": 16,
      "temp": 18,
      "city": "Svalbard",
      "icon": "01d",
      "description": "Sunny"
    },
    {
      "tempMin": 10,
      "tempMax": 16,
      "temp": 20,
      "city": "Madrid",
      "icon": "50d",
      "description": "Haze"
    },
    {
      "tempMin": 8,
      "tempMax": 18,
      "temp": 24,
      "city": "Delhi",
      "icon": "01n",
      "description": "Clear sky"
    },
    {
      "tempMin": 9,
      "tempMax": 16,
      "temp": 10,
      "city": "Naples",
      "icon": "10d",
      "description": "Heavy intensity rain"
    },
    {
      "tempMin": 12,
      "tempMax": 15,
      "temp": 11,
      "city": "Canberra",
      "icon": "09d",
      "description": "Moderate rain"
    }
  ];
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            width: 400.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(
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
                                    child: getIcon(data[index]["icon"]),
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
                                          Expanded(
                                            child: Text(
                                              data[index]["city"],
                                              style: cardCityStyle,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data[index]["description"],
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
                                              "${data[index]["temp"]}°C",
                                              style: cardTempStyle,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${data[index]["tempMax"]}/${data[index]["tempMin"]}°C",
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
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
