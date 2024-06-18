import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('productos');

  String _syncMessage = ''; // Mensaje de estado de sincronización

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  void _initConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        _syncMessage = 'Conexión perdida.';
      });
    } else {
      setState(() {
        _syncMessage = 'Conexión establecida.';
      });
      _syncData(); // Iniciar sincronización
    }

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connResult) {
      if (connResult != ConnectivityResult.none) {
        setState(() {
          _syncMessage = 'Conexión restablecida. Sincronizando cambios...';
        });
        _syncData(); // Iniciar sincronización al restablecerse la conexión
      } else {
        setState(() {
          _syncMessage = 'Conexión perdida.';
        });
      }
    });
  }

  Future<void> _addProduct(BuildContext context) async {
    try {
      await _productsCollection.add({
        'name': _nameController.text.trim(),
        'quantity': int.parse(_quantityController.text.trim()),
        'description': _descriptionController.text.trim(),
        'value': double.parse(_valueController.text.trim()),
      });
      setState(() {
        _syncMessage =
            'Producto agregado localmente. Esperando conexión para subir.';
      });
    } catch (e) {
      setState(() {
        _syncMessage =
            'Error al agregar producto. Esperando conexión para intentar nuevamente.';
      });
    }
  }

  void _syncData() async {
    QuerySnapshot pendingSnapshot = await _productsCollection.get();
    if (pendingSnapshot.docs.isNotEmpty) {
      for (var doc in pendingSnapshot.docs) {
        try {
          await _productsCollection.doc(doc.id).set(doc.data());
        } catch (e) {
          setState(() {
            _syncMessage =
                'Error al sincronizar datos. Intente nuevamente más tarde.';
          });
          return; // Salir del método si hay un error
        }
      }
      setState(() {
        _syncMessage = 'Datos sincronizados correctamente.';
      });
    } else {
      if (_syncMessage == 'Conexión restablecida. Sincronizando cambios...') {
        setState(() {
          _syncMessage = 'No hay datos pendientes para sincronizar.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addProduct(context),
              child: Text('Crear Producto'),
            ),
            SizedBox(height: 20),
            Text(
              _syncMessage,
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
