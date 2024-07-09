import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase/models/products.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('productos');

  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot querySnapshot = await _productsCollection.get();
      List<ProductModel> products = querySnapshot.docs.map((doc) {
        return ProductModel(
          name: doc['name'],
          description: doc['description'],
          quantity: doc['quantity'],
          value: doc['value'] ?? 0.0, // Manejo de valor opcional
        );
      }).toList();
      return products;
    } catch (e) {
      print('Error al obtener productos: $e');
      return []; // Retorna una lista vacía o maneja el error según tu lógica
    }
  }

  Stream<List<ProductModel>> getProductsStream() {
    return _productsCollection
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => ProductModel(
                  name: doc['name'],
                  description: doc['description'],
                  quantity: doc['quantity'],
                  value: doc['value'] ?? 0.0,
                ))
            .toList());
  }
}
