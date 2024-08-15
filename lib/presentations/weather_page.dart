import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: FittedBox(
                        child: getIcon('11d'),
                      ),
                    ),
                  ),
                  Text(
                    '20°C',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Theme.of(context).textTheme.labelLarge?.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: 340,
                    child: Text(
                      'Chennai, Republic of India',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: 340,
                    child: Text(
                      'Scattered thunderstorms',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelSmall?.fontSize,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
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
              "3m/s SE",
              "80%",
              "1001hPa",
              "18°C",
              "270",
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
            dailyForecast(dailyForecastData),
          ],
        ),
      ),
    );
  }

  Image getIcon(String icon) {
    String url = "https://openweathermap.org/img/wn/$icon@4x.png";
    return Image.network(url);
  }

  SizedBox div = const SizedBox(height: 16);

  Widget additionalInformation(
    String wind,
    String humidity,
    String pressure,
    String feelsLike,
    String? degree,
    BuildContext context,
  ) {
    var containerTitleStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
      color: Theme.of(context).colorScheme.tertiary,
    );
    var containerInfoStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 165,
                height: 100,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "wind",
                          style: containerTitleStyle,
                        )
                      ],
                    ),
                    div,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            wind,
                            style: containerInfoStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 165,
                height: 100,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "humidity",
                          style: containerTitleStyle,
                        )
                      ],
                    ),
                    div,
                    Row(
                      children: [
                        Text(
                          humidity,
                          style: containerInfoStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          div,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 165,
                height: 100,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "pressure",
                          style: containerTitleStyle,
                        )
                      ],
                    ),
                    div,
                    Row(
                      children: [
                        Text(
                          pressure,
                          style: containerInfoStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 165,
                height: 100,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "feels like",
                          style: containerTitleStyle,
                        )
                      ],
                    ),
                    div,
                    Row(
                      children: [
                        Text(
                          feelsLike,
                          style: containerInfoStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Image getSmallIcon(String icon) {
    String url = "https://openweathermap.org/img/wn/$icon@4x.png";
    return Image.network(url);
  }

  List dailyForecastData = [
    {
      "tempMin": "20",
      "tempMax": "22",
      "dt": "Fri,\nAug 16",
      // "description": rangeDescription(json[i]["weather"][0]["description"]),
      "description": "Scattered Clouds",
      "icon": "01d",
    },
    {
      "tempMin": "20",
      "tempMax": "22",
      "dt": "Sat,\nAug 17",
      // "description": rangeDescription(json[i]["weather"][0]["description"]),
      "description": "Scattered Clouds",
      "icon": "02d",
    },
    {
      "tempMin": "20",
      "tempMax": "22",
      "dt": "Sun,\nAug 18",
      // "description": rangeDescription(json[i]["weather"][0]["description"]),
      "description": "Scattered Clouds and thunderstorms",
      "icon": "03d",
    },
    {
      "tempMin": "20",
      "tempMax": "22",
      "dt": "Mon,\nAug 19",
      // "description": rangeDescription(json[i]["weather"][0]["description"]),
      "description": "Scattered Clouds",
      "icon": "04d",
    },
    {
      "tempMin": "20",
      "tempMax": "22",
      "dt": "Tue,\nAug 20",
      // "description": rangeDescription(json[i]["weather"][0]["description"]),
      "description": "Scattered Clouds",
      "icon": "10d",
    }
  ];

  Widget dailyForecast(List data) {
    var cardDateStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      // fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    var cardTempStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    var cardDescrStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      color: Theme.of(context).colorScheme.secondary,
    );

    if (data[0]["err"] == 1) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          "Daily forecast data unavailable!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 368.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                              // width: 200.0,
                              // height: 100.0,
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                data[index]["dt"],
                                style: cardDateStyle,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
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
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                // vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${data[index]["tempMax"]} / ${data[index]["tempMin"]}°C",
                                        style: cardTempStyle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[index]["description"],
                                          style: cardDescrStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
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
      );
    }
  }
}
