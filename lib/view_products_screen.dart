import 'package:demo_firebase/create_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ViewProductsScreen extends StatelessWidget {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('productos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos')),
      body: StreamBuilder(
        stream: _productsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay productos disponibles.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(
                    'Cantidad: ${data['quantity']} \nDescripción: ${data['description']} \nValor: ${data['value']}'),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _getLocation(context);
            },
            child: Icon(Icons.location_on),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProductScreen()),
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _getLocation(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
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
