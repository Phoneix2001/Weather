import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/utils/functions/logs.dart';

Future<Position?> fetchCurrentLocation(BuildContext context) async {
  LocationPermission permission;

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled && context.mounted) {
    showManualSearchDialog(context, "Location services are disabled.");
    return null;
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied && context.mounted) {
      showManualSearchDialog(context, "Location permission denied.");
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever && context.mounted) {
    showManualSearchDialog(context, "Location permission permanently denied.");
    return null;
  }

  try {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
    );
    logV("position", position.toJson());
    return position;
  } catch (e) {
    if (context.mounted) {
      showManualSearchDialog(
        context,
        "Failed to get location. Please search manually.",
      );
    }
  }
}

void showManualSearchDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("Location Access Needed"),
          content: Text(
            "$message\n\nPlease use the search bar to find your city.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
  );
}
