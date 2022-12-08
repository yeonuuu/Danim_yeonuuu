// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
////파란 줄을 없애기 위한 빠른 수정

import 'package:danim/src/login.dart';
import 'package:danim/temp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:danim/src/app.dart';
import 'package:danim/my_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //home: Temp(),
      theme: ThemeData(
          //primarySwatch: Colors.green,
          scaffoldBackgroundColor: Color.fromARGB(255, 245, 250, 253),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(194, 233, 252, 1),
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 102, 202, 252),
          ),
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(194, 233, 252, 1),
            titleTextStyle: TextStyle(color: Colors.black),
          )),
      debugShowCheckedModeBanner: false,
      routes: {
        '/app': (context) => App(),
        '/mea': (context) => const MyHomePage(),
      },
      home: Temp(),
      //home: const Map(),
      //home: const MyHomePage(),
    );
  }
}
