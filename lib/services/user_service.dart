import 'package:cloud_firestore/cloud_firestore.dart';

class UsersService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('usuarios');

  final CollectionReference<Map<String, dynamic>> _usersCollection2 =
      FirebaseFirestore.instance.collection('usuarios');

  // Future<DocumentReference<Object?>> createUsers() async {
  //   try {
  //     List<Map<String, dynamic>> beneficiarios = [];
  //     for (int i = 0; i < 15; i++) {
  //       beneficiarios.add({
  //         'nombre': 'manolo${i + 2}',
  //         'identificacion': '14785${i}',
  //       });
  //     }

  //     List<Map<String, dynamic>> suertes = [];
  //     for (int i = 0; i < 15; i++) {
  //       suertes.add({
  //         'nombre': 'manolo${i + 2}',
  //         'identificacion': '1${i}',
  //         'denominacion': 'deno${i}',
  //         'area': '300${i}',
  //         'distancia': '10${i}',
  //       });
  //     }

  //     List<Map<String, dynamic>> sectores = [];
  //     for (int j = 0; j < 53; j++) {
  //       sectores.add({
  //         'identificacion': '12547${j + 1}',
  //         'nombre': 'hacienda${j + 1}',
  //         'denominacion': 'denom${j + 1}',
  //         'beneficiarios': beneficiarios,
  //         'suertes': suertes,
  //       });
  //     }

  //     // Usar la identificación del primer beneficiario como documentId
  //     String documentId = beneficiarios[0]['identificacion'];

  //     // Obtener la referencia del documento
  //     DocumentReference<Object?> docRef =
  //         FirebaseFirestore.instance.doc('usuarios/$documentId');

  //     // Establecer los datos en Firestore
  //     await docRef.set({
  //       'nombre': 'manolo',
  //       'rol': 'proveedor',
  //       'identificacion': '100026547',
  //       'sectores': sectores,
  //     });

  //     // Devolver la referencia del documento
  //     return docRef;
  //   } catch (e) {
  //     print('Error al crear usuarios: $e');
  //     throw e; // Relanzar el error para manejarlo en un nivel superior si es necesario
  //   }
  // }

  Future<DocumentReference<Object?>> createUsers() async {
    try {
      // Crear beneficiarios
      List<DocumentReference> beneficiariosRefs = [];
      for (int i = 0; i < 15; i++) {
        DocumentReference beneficiarioRef =
            await FirebaseFirestore.instance.collection('beneficiarios').add({
          'nombre': 'manolo${i + 2}',
          'identificacion': '14785${i}',
        });
        beneficiariosRefs.add(beneficiarioRef);
      }

      // Crear suertes
      List<DocumentReference> suertesRefs = [];
      for (int i = 0; i < 15; i++) {
        DocumentReference suerteRef =
            await FirebaseFirestore.instance.collection('suertes').add({
          'nombre': 'manolo${i + 2}',
          'identificacion': '1${i}',
          'denominacion': 'deno${i}',
          'area': '300${i}',
          'distancia': '10${i}',
        });
        suertesRefs.add(suerteRef);
      }

      // Crear sectores
      List<DocumentReference> sectoresRefs = [];
      for (int j = 0; j < 53; j++) {
        List<DocumentReference> beneficiariosInSector = [];
        for (int k = 0; k < beneficiariosRefs.length; k++) {
          beneficiariosInSector.add(beneficiariosRefs[k]);
        }
        List<DocumentReference> suertesInSector = [];
        for (int k = 0; k < suertesRefs.length; k++) {
          suertesInSector.add(suertesRefs[k]);
        }

        DocumentReference sectorRef =
            await FirebaseFirestore.instance.collection('sectores').add({
          'identificacion': '12547${j + 1}',
          'nombre': 'hacienda${j + 1}',
          'denominacion': 'denom${j + 1}',
          'beneficiarios': beneficiariosInSector,
          'suertes': suertesInSector,
        });
        sectoresRefs.add(sectorRef);
      }

      // Crear usuario con referencia al sector
      String documentId = '10002654789'; // Documento ID para el usuario
      DocumentReference<Object?> docRef =
          FirebaseFirestore.instance.doc('usuarios/$documentId');
      await docRef.set({
        'nombre': 'manolo',
        'rol': 'proveedor',
        'identificacion': documentId,
        'sectores': sectoresRefs,
      });

      return docRef;
    } catch (e) {
      print('Error al crear usuarios: $e');
      throw e;
    }
  }

  Stream<List<dynamic>> getProductsStream() {
    print('Entré a esta función');
    return _usersCollection.snapshots().map((querySnapshot) {
      List<dynamic> documents = [];
      querySnapshot.docs.forEach((doc) {
        // Aquí puedes imprimir cada documento si lo deseas
        print(doc.data()); // Imprime los datos del documento
        documents.add(doc.data()); // Agrega el documento a la lista
      });
      return documents;
    });
  }

  Future<List<dynamic>> getUserData(String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _usersCollection2.doc(documentId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;

        // Verificar y obtener los datos completos de los sectores referenciados
        if (userData.containsKey('sectores') && userData['sectores'] is List) {
          List<dynamic> sectorRefs = userData['sectores'];

          // Obtener los datos completos de cada sector referenciado
          List<Map<String, dynamic>> sectors = [];
          for (var sectorRef in sectorRefs) {
            DocumentSnapshot sectorSnapshot = await sectorRef.get();
            if (sectorSnapshot.exists) {
              sectors.add(sectorSnapshot.data() as Map<String, dynamic>);
            }
          }

          // Reemplazar las referencias con los datos completos de los sectores
          userData['sectores'] = sectors;
        }

        // Devolver los datos del usuario
        return [userData];
      } else {
        throw Exception('Usuario con ID $documentId no encontrado.');
      }
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      throw e; // Relanzar el error para manejarlo en un nivel superior si es necesario
    }
  }
}
