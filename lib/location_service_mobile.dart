import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  void getLocation(BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Servicio de ubicación desactivado.'),
        ),
      );
      return;
    }

    // Solicitar permisos de ubicación
    permission = await Permission.locationWhenInUse.request();
    if (permission != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permisos de ubicación denegados.'),
        ),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ubicación obtenida: ${position.latitude}, ${position.longitude}'),
        ),
      );
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener la ubicación'),
        ),
      );
    }
  }
}
