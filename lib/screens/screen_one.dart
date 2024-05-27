import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tutorial_getx/screens/screen_two.dart';

class ScreenOne extends StatefulWidget {
  // const ScreenOne({super.key, required this.name});
  // final String name;
  ScreenOne({super.key, this.name});
  var name;

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  @override
  Widget build(context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Screen One ' + widget.name),
        //title: Text('Screen One ' + Get.arguments[0]),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              //Get.to(const ScreenTwo());
              Get.toNamed('/screenTwo');
            },
            child: const Center(child: Text('Go to next screen')),
          ),
        ],
      ),
    ));
  }
}
