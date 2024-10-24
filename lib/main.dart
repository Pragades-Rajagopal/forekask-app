import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
import 'package:forekast_app/presentations/landing_page.dart';
import 'package:forekast_app/services/cities_service.dart';
import 'package:forekast_app/utils/themes.dart';
import 'package:get/route_manager.dart';

String? theme;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Store cities
  CitiesApi cities = CitiesApi();
  List<String> data = await cities.getCities();
  await CitiesData.storeCities(data);
  // Theming
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(
    savedThemeMode: savedThemeMode,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          home: const LandingPage(),
        );
      },
    );
  }
}
