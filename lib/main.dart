import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/pages/home.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(index: 0,),
      },
    );
  }
}
     
//      void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     initialRoute: '/login',
//     routes: {
//       '/login': (context) => const Login(),
//     },
//   ));
// }