import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_boilerplate/data/app_preference.dart';
import '/modules/setting/views/settingPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GETX BOILERPLATE"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.to(SettingPage());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppPreference().saveToken("Jackie"),
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
