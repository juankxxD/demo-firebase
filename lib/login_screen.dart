import 'package:demo_firebase/models/auth_model.dart';
import 'package:demo_firebase/models/user_model.dart';
import 'package:demo_firebase/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const name = 'login-screen';
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    AuthModel authData = AuthModel(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    await ref.read(authNotifierProvider.notifier).signIn(authData);
    UserModel? user = ref.read(authNotifierProvider);
    print(user?.email);
    if (user != null) {
      context.go('/view-products');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de inicio de sesión')),
      );
    }
  }

  void _goToRegisterScreen() {
    context.go('/sing-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _goToRegisterScreen,
              child: Text('¿No tienes una cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
