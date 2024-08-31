import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    final appSettings = await SettingsData.getPreferences();
    setState(() {
      selectedTheme = appSettings["selectedTheme"];
      selectedUnit = appSettings["selectedUnit"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
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
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 280.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 8, 4),
                      child: DropdownButtonFormField(
                        elevation: 2,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                        ),
                        value: selectedTheme,
                        onChanged: (String? newTheme) async {
                          await SettingsData.storeThemePreference(newTheme!);
                        },
                        items: themes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    'close the app and reopen to apply the selected theme!',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 28.0,
                  ),
                  const Text(
                    'units',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 280.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 8, 4),
                      child: DropdownButtonFormField(
                        elevation: 2,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                        ),
                        value: selectedUnit,
                        onChanged: (String? newUnit) async {
                          await SettingsData.storeUnitPreference(newUnit!);
                        },
                        items: units.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
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
