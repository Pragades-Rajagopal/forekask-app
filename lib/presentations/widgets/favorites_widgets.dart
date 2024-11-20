import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/presentations/widgets/rich_text.dart';
import 'package:forekast_app/presentations/widgets/weather_widgets.dart';

Card favoriteCardsWidget(
  BuildContext context,
  List<dynamic> favoritesData,
  List<dynamic> favoritesList,
  String temperatureUnit,
  int index,
) {
  var cardDescrStyle = TextStyle(
    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
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
  var cardCityStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
      );
  var cardCountryStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
        color: Theme.of(context).colorScheme.secondary,
      );
  List<String> cityParts =
      favoritesData[index]["city"].toString().contains(', ')
          ? favoritesData[index]["city"].toString().split(', ')
          : [favoritesData[index]["city"], ''];
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
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: RichTextWidget(
                                  color: Theme.of(context).colorScheme.primary,
                                  textAlign: TextAlign.start,
                                  inlineSpans: [
                                    TextSpan(
                                      text: cityParts[0],
                                      style: cardCityStyle,
                                    ),
                                    if (cityParts[1].isNotEmpty) ...{
                                      TextSpan(
                                        text: ', ${cityParts[1]}',
                                        style: cardCountryStyle,
                                      )
                                    },
                                  ],
                                ),
                              ),
                              if (favoritesList[index]["default"] == true) ...{
                                Icon(
                                  CupertinoIcons.house_alt_fill,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              }
                            ],
                          ),
                        ),
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
                            "${favoritesData[index]["temp"]}$temperatureUnit",
                            style: cardTempStyle,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${favoritesData[index]["tempMax"]}/${favoritesData[index]["tempMin"]}$temperatureUnit",
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
}

Card currentLocationCardWidget(
  BuildContext context,
  Map<String, dynamic> data,
  String temperatureUnit,
) {
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
  var cardCityStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
      );
  var cardCountryStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
        color: Theme.of(context).colorScheme.secondary,
      );
  // TODO: Write a common function
  List<String> cityParts = data["city"].toString().contains(', ')
      ? data["city"].toString().split(', ')
      : [data["city"], ''];
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  // vertical: 20,
                ),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: getIcon(data["icon"]),
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
                          child: Row(
                            children: [
                              Expanded(
                                // child: Text(
                                //   data["city"],
                                //   style: cardCityStyle,
                                //   softWrap: true,
                                // ),
                                child: RichTextWidget(
                                  color: Theme.of(context).colorScheme.primary,
                                  textAlign: TextAlign.start,
                                  inlineSpans: [
                                    TextSpan(
                                      text: cityParts[0],
                                      style: cardCityStyle,
                                    ),
                                    if (cityParts[1].isNotEmpty) ...{
                                      TextSpan(
                                        text: ', ${cityParts[1]}',
                                        style: cardCountryStyle,
                                      )
                                    },
                                  ],
                                ),
                              ),
                              Icon(
                                CupertinoIcons.location_fill,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data["description"],
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
                            "${data["temp"]}$temperatureUnit",
                            style: cardTempStyle,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${data["tempMax"]}/${data["tempMin"]}$temperatureUnit",
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
}
