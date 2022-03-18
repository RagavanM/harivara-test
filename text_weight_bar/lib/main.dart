import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:text_weight_bar/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'text_weight_bar',
      options: const FirebaseOptions(
        appId: 'xxxxxxxxxxxxxxxxxxxxxx',
        apiKey: 'xxxxxxxxxxxxxxxxxxxxxxxx',
        projectId: 'asdfjhhsgdkjd',
        messagingSenderId: '0000000000',
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text weight bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Testing(),
      // home: const MyHomePage(),
    );
  }
}
