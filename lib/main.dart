import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:tutorial_getx/screens/home_screen.dart';
import 'package:tutorial_getx/screens/screen_one.dart';
import 'package:tutorial_getx/screens/screen_two.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/screenOne', page: () => ScreenOne(name: 'as')),
        GetPage(name: '/screenTwo', page: () => ScreenTwo())
      ],
    );
  }
}
