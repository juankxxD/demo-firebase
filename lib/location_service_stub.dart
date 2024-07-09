import 'package:flutter/material.dart';

class LocationService {
  void getLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Plataforma no soportada para obtener la ubicación'),
      ),
    );
  }
}
