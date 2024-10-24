import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Get.snackbar(
      //   'Warning',
      //   'Location permission denied',
      //   icon: const Icon(Icons.location_disabled_sharp),
      // );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location permission denied',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      // Get.snackbar('Warning', 'Location permission denied permanently');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission denied permanently',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future<String?> getAddressFromLatLng(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return place.locality;
  }
}
