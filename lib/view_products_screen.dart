import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase/models/products.dart';
import 'package:demo_firebase/models/user_model.dart';
import 'package:demo_firebase/providers/auth_provider.dart';
import 'package:demo_firebase/services/user_service.dart';
import 'package:demo_firebase/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'location_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod
import 'package:go_router/go_router.dart';

class ViewProductsScreen extends ConsumerStatefulWidget {
  static const name = 'view-products-screen';

  const ViewProductsScreen({super.key});

  @override
  ViewProductsScreenState createState() => ViewProductsScreenState();
}

class ViewProductsScreenState extends ConsumerState<ViewProductsScreen> {
  final ProductService _productService = ProductService();
  final UsersService _userService = UsersService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
    _printUserData('10002654789');
  }

  Future<void> _checkUserLoggedIn() async {
    // Leer el usuario desde flutter_secure_storage
    String? storedUserJson = await _secureStorage.read(key: 'user');
    print('Storahe');
    print(storedUserJson);
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.read(
        authNotifierProvider); // Accede al estado del provider authServiceProvider
    print('Provider');
    print(user?.email); // Imprime el estado del provider (para depuración)
    return Scaffold(
      appBar: AppBar(title: Text('Productos')),
      body:
          // Column(
          //   children: [
          StreamBuilder<List<dynamic>>(
        stream: _userService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay productos disponibles.'));
          }
          List<dynamic> users = snapshot.data!;
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                dynamic user = users[index];
                return ListTile(
                  title: Text(user['nombre'] ?? 'Nombre no disponible'),
                  subtitle: Text(user['identificacion'] ?? 'ID no disponible'),
                );
              });
        },
      ),
      //   LayoutBuilder(
      //     builder: (context, constraints) {
      //       if (constraints.maxWidth > 600) {
      //         // Mostrar los datos en forma de tabla para pantallas más anchas
      //         return _buildDataTable(context);
      //       } else {
      //         // Mostrar los datos en forma de lista para dispositivos más pequeños
      //         return _buildListView(context);
      //       }
      //     },
      //   ),
      // ],
      // ),
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
            onPressed: () async {
              context.push('/view-products/create-products');
              setState(() {});
            },
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              logout(context);
            },
            child: Icon(Icons.logout),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              createUser(context);
            },
            child: Icon(Icons.create),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    await ref.read(authNotifierProvider.notifier).signOut();
    context.go('/login');
  }

  Widget _buildDataTable(BuildContext context) {
    print('Desde la web');
    return FutureBuilder(
      future: _productService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay productos disponibles.'));
        }
        return DataTable(
          columns: [
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Cantidad')),
            DataColumn(label: Text('Descripción')),
            DataColumn(label: Text('Valor')),
          ],
          rows: snapshot.data!.map((product) {
            return DataRow(cells: [
              DataCell(Text(product.name ?? 'Nombre no disponible')),
              DataCell(Text(
                  product.quantity.toString() ?? 'Cantidad no disponible')),
              DataCell(
                  Text(product.description ?? 'Descripción no disponible')),
              DataCell(Text(product.value.toString() ?? 'Valor no disponible')),
            ]);
          }).toList(),
        );
      },
    );
  }

  Widget printUser(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: _userService.getProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<dynamic> users = snapshot.data ?? [];
        print('Documentos recibidos: $users');
        // Aquí puedes realizar cualquier otra lógica con los datos recibidos
        return Container(); // Devuelve un widget según sea necesario
      },
    );
  }

  Future<void> _printUserData(String userId) async {
    try {
      List<dynamic> userData = await _userService.getUserData(userId);
      print('Datos del usuario:');
      print(userData);
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
    }
  }

  Widget _buildListView(BuildContext context) {
    print('Desde el movil');
    return StreamBuilder<List<ProductModel>>(
      stream: _productService.getProductsStream(),
      builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay productos disponibles.'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            ProductModel product = snapshot.data![index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text(
                  'Cantidad: ${product.quantity}\nDescripción: ${product.description}\nValor: ${product.value}'),
            );
          },
        );
      },
    );
  }

  void _getLocation(BuildContext context) async {
    final locationService = LocationService();
    locationService.getLocation(context);
  }

  void createUser(BuildContext context) async {
    DocumentReference? users = await _userService.createUsers();
    print(users);
  }
}
