import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
import 'package:forekast_app/presentations/landing_page.dart';
import 'package:forekast_app/services/cities_service.dart';
import 'package:forekast_app/services/location_service.dart';
import 'package:forekast_app/utils/themes.dart';
import 'package:get/route_manager.dart';

Future<String> getLocationInfo() async {
  LocationData locationData = LocationData();
  final defaultLocation = await locationData.getManualCity();
  if (defaultLocation.isNotEmpty) {
    return defaultLocation;
  }
  try {
    final bool? isLocationServiceAllowed =
        await LocationData().getLocationPermissionStatus();
    if (!isLocationServiceAllowed!) return '';
    final location = await LocationService.getCurrentLocation();
    final currentCity = await LocationService.getAddressFromLatLng(
        location.latitude, location.longitude);
    if (currentCity!.isNotEmpty) {
      return currentCity;
    } else {
      return defaultLocation;
    }
  } catch (e) {
    return defaultLocation;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CitiesApi cities = CitiesApi();
  CitiesData citiesData = CitiesData();
  // Get location
  final String currentLocation = await getLocationInfo();
  // Store cities
  List<String> data = await cities.getCities();
  await citiesData.storeCities(data);
  // Theming
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(MyApp(
    savedThemeMode: savedThemeMode,
    currentLocation: currentLocation,
  ));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final String currentLocation;
  const MyApp({
    super.key,
    this.savedThemeMode,
    required this.currentLocation,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final weatherNotifier = ValueNotifier<String>('');
  @override
  void initState() {
    super.initState();
    setState(() => weatherNotifier.value = widget.currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          home: weatherNotifier.value == ''
              ? const LandingPage()
              : BasePage(
                  weatherNotifier: weatherNotifier,
                ),
          // home: const LandingPage(),
        );
      },
    );
  }
}
