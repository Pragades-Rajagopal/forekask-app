import 'package:flutter/material.dart';
import 'package:forekast_app/presentations/widgets/common_widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
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
      // Get.snackbar('Warning', 'Location permission denied permanently');
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

  static Future<String?> getAddressFromLatLng(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return place.locality;
  }
}
