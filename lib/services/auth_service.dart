import 'package:demo_firebase/models/auth_model.dart';
import 'package:demo_firebase/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<UserModel?> sign(AuthModel authData) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: authData.email,
        password: authData.password,
      );

      UserModel? user = _userFromFirebaseUser(userCredential.user);
      if (user != null) {
        await _saveUserToStorage(user);
      }
      return user;
    } catch (e) {
      print('Error en inicio de sesión: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _storage.delete(key: 'user');
      // Realizar otras acciones después del cierre de sesión si es necesario
    } catch (e) {
      print('Error al cerrar sesión: $e');
      // Manejar el error según tu lógica de la aplicación
    }
  }

  // Método para convertir un User de Firebase en un UserModel personalizado
  UserModel? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
    );
  }

  Future<void> _saveUserToStorage(UserModel user) async {
    await _storage.write(key: 'user', value: user.toJson());
  }

  Future<UserModel?> getUserFromStorage() async {
    String? userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }
    return null;
  }
}
