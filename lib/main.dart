import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
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
  final appSettings = await SettingsData.getPreferences();
  theme = appSettings["selectedTheme"];

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: theme == 'light' ? ThemeMode.light : ThemeMode.dark,
      home: const BasePage(),
    );
  }
}
