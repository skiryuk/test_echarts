import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

void main() => runZonedGuarded(() => runApp(const MyApp()),
        (Object error, StackTrace stackTrace) {
      if (error is PlatformException) {
        print('platform exception');
      }
    });

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
