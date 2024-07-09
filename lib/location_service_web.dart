import 'dart:html' as html;
import 'package:flutter/material.dart';

class LocationService {
  void getLocation(BuildContext context) async {
    html.window.navigator.geolocation.getCurrentPosition().then((position) {
      final latitude = position.coords?.latitude;
      final longitude = position.coords?.longitude;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ubicación obtenida: ${latitude}, ${longitude}'),
        ),
      );
    });
  }
}
