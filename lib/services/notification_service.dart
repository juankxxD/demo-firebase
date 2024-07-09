
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocalNotificationService {
//   Future<void> requestPermission() async {
//     PermissionStatus status = await Permission.notification.request();
//     if (status != PermissionStatus.granted) {
//       throw Exception('Permission not granted');
//     }
//   }

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final _currentUser = FirebaseAuth.instance.currentUser;

//   Future<void> uploadFcmToken() async {
//     try{
//       await FirebaseMessaging.instance.getToken().then((token) async {
//         print('Token :: $token');
//         await FirebaseFirestore
//       });
//     } catch(e) {
//       print(e.toString());
//     }
//   }
// }