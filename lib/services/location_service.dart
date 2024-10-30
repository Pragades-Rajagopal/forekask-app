import 'package:flutter/material.dart';
import 'package:forekast_app/presentations/widgets/common_widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Location service model
/// - Handles device location information to get current location
class LocationService {
  /// Retieves the current location of the device
  static Future<Position> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets.mySnackBar(context, 'Location permission denied'),
        );
      }
      return Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets.mySnackBar(
              context, 'Location permission denied permanently'),
        );
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  /// Retrieves the city for the given coordinates
  ///
  /// Returns city name with country code. Ex: `Svalbard,SJ`
  static Future<String?> getAddressFromLatLng(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return '${place.locality},${place.isoCountryCode}';
  }
}
