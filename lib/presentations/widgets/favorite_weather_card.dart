import 'package:flutter/material.dart';
import 'package:forekast_app/presentations/widgets/rich_text.dart';
import 'package:forekast_app/utils/common_function.dart';
import 'package:forekast_app/utils/common_ui.dart';

class FavoriteWeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final String temperatureUnit;
  final IconData? icon;
  const FavoriteWeatherCard({
    super.key,
    required this.weatherData,
    required this.temperatureUnit,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, TextStyle> styleComponents = cardStyleComponents(context);
    List<String> cityParts = getParts(weatherData["city"].toString());
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
                    child: getIcon(weatherData["icon"]),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    textAlign: TextAlign.start,
                                    inlineSpans: [
                                      TextSpan(
                                        text: cityParts[0],
                                        style: styleComponents[
                                            "cardCityLargeBold"],
                                      ),
                                    ],
                                  ),
                                ),
                                if (icon != null) ...{
                                  Icon(
                                    icon,
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
                            child: RichTextWidget(
                              color: Theme.of(context).colorScheme.primary,
                              textAlign: TextAlign.start,
                              inlineSpans: [
                                if (cityParts[1].isNotEmpty) ...{
                                  TextSpan(
                                    text: '${cityParts[1]} • ',
                                    style: styleComponents["cardCountryStyle"],
                                  ),
                                },
                                TextSpan(
                                  text: weatherData["description"],
                                  style: styleComponents["cardDescrSmall"],
                                )
                              ],
                            ),
                          )
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
                              "${weatherData["temp"]}$temperatureUnit",
                              style: styleComponents["cardTempLargeBold"],
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${weatherData["tempMax"]}/${weatherData["tempMin"]}$temperatureUnit",
                            style: styleComponents["cardTempSmallBold"],
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
}
