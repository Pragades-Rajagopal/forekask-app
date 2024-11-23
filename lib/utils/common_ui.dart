import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const bottomNavBarItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.sun_max),
    activeIcon: Icon(Icons.sunny_snowing),
    label: 'weather',
  ),
  BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.heart),
    activeIcon: Icon(CupertinoIcons.heart_fill),
    label: 'favorites',
  ),
];

Widget errorWidget(BuildContext context,
    {String? message = 'something went wrong'}) {
  return Center(
    child: Text(
      message!,
      style: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Map<String, TextStyle> cardStyleComponents(BuildContext context) {
  TextTheme textTheme = Theme.of(context).textTheme;
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return {
    "cardDescrSmall": TextStyle(
      fontSize: textTheme.bodySmall?.fontSize,
      color: colorScheme.secondary,
    ),
    "cardTempLargeBold": TextStyle(
      fontSize: textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
      color: colorScheme.secondary,
    ),
    "cardTempSmallBold": TextStyle(
      fontSize: textTheme.bodySmall?.fontSize,
      fontWeight: FontWeight.bold,
      color: colorScheme.secondary,
    ),
    "cardCityLargeBold": TextStyle(
      fontSize: textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
      color: colorScheme.secondary,
    ),
    "cardDateSmall": TextStyle(
      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      color: Theme.of(context).colorScheme.secondary,
    ),
    "cardTempMediumBold": TextStyle(
      fontSize: textTheme.bodyMedium?.fontSize,
      fontWeight: FontWeight.bold,
      color: colorScheme.secondary,
    ),
    "containerTitleMedium": TextStyle(
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
      color: Theme.of(context).colorScheme.tertiary,
    ),
    "containerInfoLarge": TextStyle(
      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    ),
  };
}

Text commonText(
  BuildContext context,
  String message, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign? textAlign,
}) {
  TextTheme textTheme = Theme.of(context).textTheme;
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  color ??= colorScheme.primary;
  fontSize ??= textTheme.bodySmall?.fontSize;
  fontWeight ??= FontWeight.normal;
  textAlign ??= TextAlign.start;
  return Text(
    message,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}
