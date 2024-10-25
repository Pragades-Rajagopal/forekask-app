import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
import 'package:forekast_app/presentations/widgets/cities_search_sheet.dart';
import 'package:forekast_app/services/location_service.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<void> getLocation() async {
    final location = await LocationService.getCurrentLocation(context);
    final currentCity = await LocationService.getAddressFromLatLng(
        location.latitude, location.longitude);
    await CitiesData.storeDefaultCity(currentCity!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  'forekast',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () async {
                    await getLocation();
                    Get.to(() => const BasePage());
                  },
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'allow location',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: 300,
                  child: Divider(
                    height: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 12.0),
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
}
