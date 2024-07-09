import 'package:demo_firebase/config/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cargar datos del almacenamiento seguro
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String initialRoute = await determineInitialRoute();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while in foreground: ${message.data}');
      // Aquí puedes manejar la notificación.
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // Aquí puedes manejar la acción al abrir la app desde la notificación.
    });

    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("FirebaseMessaging token: $token");
      // Aquí puedes enviar el token al servidor para enviar notificaciones dirigidas.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter(widget.initialRoute),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
