import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tutorial_getx/screens/screen_one.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('GetX Tutorial'),
      ),
      body: /*
      Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('GetX Dialog Alert'),
              subtitle: const Text('Dialog alert using Getx'),
              onTap: () {
                Get.defaultDialog(
                  title: 'Delete Chat',
                  titlePadding: const EdgeInsets.only(top: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  middleText: 'Are you sure you want to delete this chat?',
                  //textConfirm: 'Yes',
                  //textCancel: 'No');
                  confirm: TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      Get.back();
                    },
                    child: const Text('Ok'),
                  ),
                  cancel: TextButton(
                    onPressed: () {},
                    child: const Text('Cancel'),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('GetX Bottom Sheet'),
              subtitle: const Text('Bottom Sheet using Getx'),
              onTap: () {
                Get.bottomSheet(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[300],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.light_mode_sharp),
                          title: const Text('Light Mode'),
                          onTap: () {
                            Get.changeTheme(ThemeData.light());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.dark_mode_sharp),
                          title: const Text('Dark Mode'),
                          onTap: () {
                            Get.changeTheme(ThemeData.dark());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),*/
          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: TextButton(
                  onPressed: () {
                    /*
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ScreenOne(
                          name: '23 May',
                        );
                      },
                    ));
                    */
                    //Get.to(const ScreenOne(name: '23 May'));
                    // Navigation using route method
                    Get.toNamed('/screenOne', arguments: ['22th May']);
                  },
                  child: const Text('Go to next screen')))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            'GetX Snackbar',
            'Snackbar displayed using GetX',
            //snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
          );
        },
      ),
    ));
  }
}
