import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
import 'package:forekast_app/presentations/landing_page.dart';
import 'package:forekast_app/services/cities_service.dart';
import 'package:forekast_app/utils/themes.dart';
import 'package:get/route_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Store cities
  CitiesApi cities = CitiesApi();
  CitiesData citiesData = CitiesData();
  List<String> data = await cities.getCities();
  await citiesData.storeCities(data);
  // Get default/ current location
  final defaultLocation = await citiesData.getDefaultCity() ?? '';
  // Theming
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(
    savedThemeMode: savedThemeMode,
    defaultLocation: defaultLocation,
  ));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final String defaultLocation;
  const MyApp({
    super.key,
    this.savedThemeMode,
    required this.defaultLocation,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final weatherNotifier = ValueNotifier<String>('');
  @override
  void initState() {
    super.initState();
    setState(() => weatherNotifier.value = widget.defaultLocation);
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
          home: widget.defaultLocation == ''
              ? const LandingPage()
              : BasePage(
                  weatherNotifier: weatherNotifier,
                ),
        );
      },
    );
  }
}
