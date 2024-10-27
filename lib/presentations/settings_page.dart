import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/landing_page.dart';
import 'package:forekast_app/presentations/widgets/common_widgets.dart';
import 'package:forekast_app/presentations/widgets/dropdown_bar.dart';
import 'package:forekast_app/presentations/widgets/gesture_button.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsData settingsData = SettingsData();
  CitiesData citiesData = CitiesData();
  String selectedTheme = 'light';
  String selectedUnit = 'metric';
  List<String> themes = [
    'light',
    'dark',
  ];
  List<String> units = [
    'metric',
    'imperial',
  ];

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    final appSettings = await settingsData.getPreferences();
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    setState(() {
      selectedTheme =
          savedThemeMode == AdaptiveThemeMode.light ? themes[0] : themes[1];
      selectedUnit = appSettings["selectedUnit"];
    });
  }

  void themeOnChanged(String? newTheme) async {
    if (newTheme == 'light') {
      AdaptiveTheme.of(context).setLight();
    } else {
      AdaptiveTheme.of(context).setDark();
    }
  }

  void unitOnChanged(String? newUnit) async {
    await settingsData.storeUnitPreference(newUnit!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'app theme',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 280.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 8, 4),
                      child: DropdownBar(
                        selectedValue: selectedTheme,
                        items: themes,
                        onChanged: themeOnChanged,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  const Text(
                    'units',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 280.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 8, 4),
                      child: DropdownBar(
                        selectedValue: selectedUnit,
                        items: units,
                        onChanged: unitOnChanged,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 14, bottom: 14),
                    child: Divider(
                      thickness: 0.5,
                    ),
                  ),
                  const Text(
                    'reset current location',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will reset the current location from the app. If the weather information is not available for your current location, you can choose the nearest location manually',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: GestureButton(
                      onTap: () async {
                        await citiesData.removeDefaultCity();
                        Get.offAll(() => const LandingPage());
                      },
                      buttonText: 'reset location',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 14, bottom: 14),
                    child: Divider(
                      thickness: 0.5,
                    ),
                  ),
                  CommonWidgets.myRichText(
                    context,
                    'Weather data provided by',
                    text2: 'openweathermap.org',
                  ),
                  const SizedBox(height: 18),
                  CommonWidgets.myRichText(
                    context,
                    'Cities data provided by',
                    text2: 'countriesnow.space',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
