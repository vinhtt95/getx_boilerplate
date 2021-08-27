import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_boilerplate/data/app_preference.dart';
import '../../app_routes.dart';

  /*
  * Chờ ở màn hình này vài giây rồi chuyển qua màn khác
  ? Đây không phải là màn launch thực sự
  */
class SplashPage extends StatelessWidget {
  SplashPage() {
    fetchSomething();
  }

  void fetchSomething() async {
    //TODO Call API from server and do sth
    await new Future.delayed(const Duration(seconds: 2));
    checkLogin();
  }

  Future<void> checkLogin() async {
    var token = AppPreference().getToken();
    if (token.isEmpty) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.HOMEWEATHER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromRGBO(255, 17, 17, 100), Color.fromRGBO(255, 129, 38, 100)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Center(
                  child: Container(
                    width: 268.0,
                    height: 268.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                        Text('Copyright © 2021 All right reserved to Jackie'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
