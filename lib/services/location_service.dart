import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/widgets/common_widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Location service model
/// - Handles device location information to get current location
class LocationService {
  /// Validates if the device location permission is allowed
  static Future<Position> getLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await LocationData().saveLocationPermissionStatus(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets.mySnackBar(context, 'Location services are disabled'),
        );
      }
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await LocationData().saveLocationPermissionStatus(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets.mySnackBar(context, 'Location permission denied'),
        );
      }
      return Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      await LocationData().saveLocationPermissionStatus(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets.mySnackBar(
              context, 'Location permission denied permanently'),
        );
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    await LocationData().saveLocationPermissionStatus(true);
    return await Geolocator.getCurrentPosition();
  }

  /// Retrieves the current device location information
  ///
  /// This will return the location info only if the device location permission is allowed
  static Future<Position> getCurrentLocation() async =>
      await Geolocator.getCurrentPosition();

  /// Retrieves the city for the given coordinates
  ///
  /// Returns city name with country code. Ex: `Svalbard, Svalbard`
  static Future<String?> getAddressFromLatLng(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return '${place.locality}, ${place.country}';
  }
}
