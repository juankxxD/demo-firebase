import 'package:demo_firebase/config/router/app_router.dart';
import 'package:demo_firebase/models/auth_model.dart';
import 'package:demo_firebase/models/user_model.dart';
import 'package:demo_firebase/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
  // ..loadUserFromStorage(); // Llama explícitamente a loadUserFromStorage()
});

class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(null) {
    // loadUserFromStorage();
  }

  Future<void> signIn(AuthModel authData) async {
    UserModel? user = await _authService.sign(authData);
    if (user != null) {
      state = user;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }

  // Future<void> loadUserFromStorage() async {
  //   UserModel? user = await _authService.getUserFromStorage();

  //   if (user != null) {
  //     state = user;
  //     // Notifica que el usuario está listo después de cargarlo desde el almacenamiento
  //     appRouter.go(
  //         '/view-products'); // Actualiza la ruta a /view-products si el usuario se carga correctamente
  //   } else {
  //     // Si no hay usuario, redirige a /login
  //     appRouter.go('/login');
  //   }
  // }
}
