/// roundTempValue
/// Rounds the temperature to integer
int roundTempValue(dynamic temp) {
  return temp.round();
}

/// getDateFromEpoch
/// Converts Unix epoch into date format 'Fri, Oct 6'
String? getDateFromEpoch(int epoch) {
  var timestamp = epoch;
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return "${getWeekday(date.weekday)},\n${getMonth(date.month)} ${date.day}";
}

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

/// getDirection
/// Converts degree to direction like N, NE, ...
String? getDirection(int degree) {
  if (degree == 0) {
    return 'N';
  } else {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final direction = directions[((degree / 45) % 8).round() - 1];
    return direction;
  }
}

/// rangeDescription
/// Trims description to 12 character
String rangeDescription(String descr) {
  if (descr.split('').length > 12) {
    return "${descr.split('').getRange(0, 12).join()}...";
  }
  return descr;
}
