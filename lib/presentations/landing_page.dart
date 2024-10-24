import 'package:flutter/material.dart';
import 'package:forekast_app/services/location_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<void> getLocation() async {
    final location = await LocationService.getCurrentLocation(context);
    // final currentCity = await LocationService.getAddressFromLatLng(
    //     location.latitude, location.longitude);
    // setState(() {
    //   currentLocation = currentCity!;
    // });
    // String defaultCity = await FavoritesData.getDefaultFavorite();
    // if (defaultCity != '') {
    //   setState(() {
    //     _weatherNotifier.value = defaultCity;
    //   });
    // } else if (currentCity != '' || currentCity != null) {
    //   setState(() {
    //     _weatherNotifier.value = currentCity ?? searchCity;
    //   });
    // }
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
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 300,
                  child: Divider(
                    height: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 300,
                  child: TextField(
                    // controller: widget.controller,

                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 12.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.3),
                            width: 2,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.3),
                            width: 2.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100.0)),
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                        focusColor: Theme.of(context).colorScheme.surfaceBright,
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        hintText: 'search city manually'),
                    cursorColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
