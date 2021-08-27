import 'package:my_boilerplate/data/app_preference.dart';

import '/data/repository/module1_repository.dart';
import 'package:get/get.dart';
import '/models/common/error_model.dart';
import '/models/module1/weather_model.dart';
import '/modules/common/error_page.dart';

class WeatherController extends GetxController {
  var weather = WeatherModel().obs;
  var isLoading = false.obs;
  final Module1Repository repository = Get.put(Module1Repository());

  WeatherController();

  @override
  void onInit() {
    super.onInit();
  }

  void changeLazyLoad() {
    this.isLoading.value = !this.isLoading.value;
  }

  void apiGetWeatherInfo(String? city) async {
    // _preferences = await SharedPreferences.getInstance();
    if (city == null) {
      // city = _preferences.getString("cityName") ?? "";
      city = AppPreference().getCityName();
      // _preferences.setString("cityName", city);
      AppPreference().saveCityName(city);
    } else {
      // _preferences.setString("cityName", city);
      AppPreference().saveCityName(city);
    }

    if (city == "") {
      this.weather.value = WeatherModel();
      return;
    }
    isLoading.value = true;
    try {
      repository.getWeatherFromCity(city).then((dynamic res) {
        isLoading.value = false;
        if (res is ErrorModel) {
          Get.to(ErrorPage(error: res));
        } else if (res is WeatherModel) {
          this.weather.value = res;
        } else {
          this.weather.value = WeatherModel();
        }
      });
    } catch (e) {
      isLoading.value = false;
      Get.to(ErrorPage(error: ErrorModel(message: e.toString())));
    }
  }
}
