import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/modules/modules.dart';
import '/util/constants/locale_keys.dart';
import 'city_search_page.dart';

// ignore: must_be_immutable
class HomeWeatherPage extends StatelessWidget {
  final WeatherController _controller = Get.put(WeatherController());

  HomeWeatherPage({String? city}) {
    _controller.apiGetWeatherInfo(city);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: buildAppBar(),
            body: Obx(() => Stack(
                  children: [
                    weatherInfo(),
                    LazyLoadWidget(_controller.isLoading.value)
                  ],
                ))));
  }

  Column weatherInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('${LocaleKeys.location} ${_controller.weather.value.location}',
            ),
        Text(
            '${LocaleKeys.min_temp} ${_controller.weather.value.minTemp} ${LocaleKeys.celsius}',
            ),
        Text(
            '${LocaleKeys.max_temp} ${_controller.weather.value.maxTemp} ${LocaleKeys.celsius}',
            ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        title: Text(LocaleKeys.weather_app.tr),
        actions: <Widget>[ searchButton(), settingButton(),]);
  }

  IconButton settingButton() {
    return IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          // Get.to(SettingLangPage());
          Get.to(SettingPage());
        });
  }

  IconButton searchButton() {
    return IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          Get.to(() => CitySearchPage());
        });
  }
}
