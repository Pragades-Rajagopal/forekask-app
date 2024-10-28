import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
import 'package:forekast_app/presentations/widgets/cities_search_sheet.dart';
import 'package:forekast_app/presentations/widgets/common_widgets.dart';
import 'package:forekast_app/presentations/widgets/gesture_button.dart';
import 'package:forekast_app/services/location_service.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  CitiesData citiesData = CitiesData();
  IconData themeIcon = Icons.dark_mode;

  Future<void> getLocation() async {
    try {
      final location = await LocationService.getCurrentLocation(context);
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => CommonWidgets.myLoadingIndicator(
            context,
            text1: 'determining current location',
          ),
        );
      }
      final currentCity = await LocationService.getAddressFromLatLng(
          location.latitude, location.longitude);
      await citiesData.storeDefaultCity(currentCity!);
      Get.offAll(() => const BasePage());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _appBar(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 96.0,
                  height: 96.0,
                  child: CircleAvatar(
                    foregroundImage: AssetImage('assets/app_icon.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  'forekast',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                GestureButton(
                  onTap: () async => await getLocation(),
                  buttonText: 'allow device location',
                ),
                const SizedBox(height: 24.0),
                CitiesSearchSheet(
                  usageType: 'landing_page',
                  onValueChanged: (String _) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: [
        TextButton(
          onPressed: () {
            if (AdaptiveTheme.of(context).mode.isLight) {
              AdaptiveTheme.of(context).setDark();
              setState(() => themeIcon = Icons.wb_sunny);
            } else {
              AdaptiveTheme.of(context).setLight();
              setState(() => themeIcon = Icons.dark_mode);
            }
          },
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.fromLTRB(0, 4, 18, 0),
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
          ),
          child: Icon(themeIcon),
        ),
      ],
    );
  }
}
