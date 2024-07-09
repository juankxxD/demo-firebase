import 'package:demo_firebase/create_product_screen.dart';
import 'package:demo_firebase/login_screen.dart';
import 'package:demo_firebase/register_screen.dart';
import 'package:demo_firebase/view_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

GoRouter appRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) {
          return RedirectRoute(
            route: LoginScreen(),
            currentRoute: state.path,
          );
        },
      ),
      GoRoute(
        path: '/view-products',
        name: ViewProductsScreen.name,
        builder: (context, state) {
          return RedirectRoute(
            route: ViewProductsScreen(),
            currentRoute: state.path,
          );
        },
        routes: [
          GoRoute(
            path: 'create-products',
            name: CreateProductScreen.name,
            builder: (context, state) {
              return CreateProductScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/sing-in',
        name: RegisterScreen.name,
        builder: (context, state) {
          return RedirectRoute(
            route: RegisterScreen(),
            currentRoute: state.path,
          );
        },
      ),
      GoRoute(
        path: '/',
        redirect: (_, __) async => initialRoute,
      ),
    ],
  );
}

class RedirectRoute extends StatelessWidget {
  final Widget route;
  final String? currentRoute;

  const RedirectRoute({
    Key? key,
    required this.route,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildRoute(context, route);
  }
}

Future<String> determineInitialRoute() async {
  final storedUser = await _secureStorage.read(key: 'user');
  if (storedUser != null) {
    return '/view-products';
  } else {
    return '/login';
  }
}

Widget _buildRoute(BuildContext context, Widget route) {
  return route;
}
