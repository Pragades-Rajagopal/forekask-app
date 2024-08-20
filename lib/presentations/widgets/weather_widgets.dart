import 'package:flutter/material.dart';

Image getIcon(String? icon) {
  String url = "https://openweathermap.org/img/wn/$icon@4x.png";
  return Image.network(url);
}

Image getSmallIcon(String icon) {
  String url = "https://openweathermap.org/img/wn/$icon@2x.png";
  return Image.network(url);
}

SizedBox div = const SizedBox(height: 16);

Widget currentWeather(
  Image icon,
  String temp,
  String location,
  String description,
  String country,
  BuildContext context,
) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 220,
            height: 220,
            child: FittedBox(
              child: icon,
            ),
          ),
        ),
        Text(
          temp,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(
          width: 340,
          child: Text(
            "$location, $country",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
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
            description,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

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
                      Expanded(
                        child: Text(
                          pressure,
                          style: containerInfoStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
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

Widget dailyForecast(List data, BuildContext context) {
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            alignment: Alignment.center,
                            // margin: const EdgeInsets.symmetric(
                            //   horizontal: 10,
                            // ),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: getSmallIcon(data[index]["icon"]),
                              ),
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
