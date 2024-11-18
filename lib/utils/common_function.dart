import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forekast_app/presentations/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Rounds the temperature to integer
int roundTempValue(dynamic temp) => temp.round();

/// Handles latitude and longitude type conversion
double convertIntToDouble(dynamic value) =>
    value is int ? value.toDouble() : value;

/// Converts Unix epoch into date format 'Fri, Oct 6'
///
/// To display the dates in daily forekast
String? getDateFromEpoch(int epoch) {
  var timestamp = epoch;
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return "${getWeekday(date.weekday)},\n${getMonth(date.month)} ${date.day}";
}

/// Gets the weekday
String? getWeekday(int weekday) {
  const values = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };
  return values[weekday];
}

/// Gets the month
String? getMonth(int month) {
  const values = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };
  return values[month];
}

/// Converts degree to direction like N, NE, ...
String? getDirection(int degree) {
  if (degree >= 0 && degree <= 45) {
    return 'N';
  }
  if (degree == 360) {
    return 'N';
  }
  const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  final direction = directions[((degree / 45) % 8).round() - 1];
  return direction;
}

/// Trims description to 12 character
String rangeDescription(String descr) {
  if (descr.split('').length > 12) {
    return "${descr.split('').getRange(0, 12).join()}...";
  }
  return descr;
}

/// Converts the `epoch` time to format `Mon 28 Oct 22:00`
///
/// To display the date time of the city
String getTime(int epochTime, {format = 'datetime'}) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
    epochTime * 1000,
    isUtc: true,
  );
  String day = dateTime.day.toString().padLeft(2, '0');
  int weekday = dateTime.weekday;
  int month = dateTime.month.toInt();
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  return format == 'datetime'
      ? '${getWeekday(weekday)} $day ${getMonth(month)} $hour:$minute'
      : '$hour:$minute';
}

/// Launches Google or Apple maps of the city
void launchMapsUrl(BuildContext context, double lat, double lon) async {
  try {
    late String url;
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    }
    if (Platform.isIOS) {
      url = 'https://maps.apple.com/?q=$lat,$lon';
    }
    Uri uri = Uri.parse(url);
    await launchUrl(uri);
  } catch (_) {
    if (context.mounted) {
      CommonWidgets.mySnackBar(context, 'Unable to open maps');
    }
  }
}
