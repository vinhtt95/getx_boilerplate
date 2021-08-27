import '/data/request.dart';
import '/models/common/error_model.dart';
import '/models/module1/weather_model.dart';
import '/util/common/common_util.dart';
import '/util/constants/locale_keys.dart';
import '../database.dart';
import '../url_api.dart';

final locationUrl = (getLocalUrl, city) => '${getLocalUrl}=${city}';
final weatherUrl =
    (fetchWeatherUrl, locationId) => '${fetchWeatherUrl}${locationId}';

class Module1Repository {
  Request _request = Request();
  // late SharedPreferences preferences;

  LocalDatabaseHelper dbLocal = LocalDatabaseHelper.dbHelper;

  Module1Repository() {
    installPreferences();
  }

  Future<void> installPreferences() async {
    dbLocal.delDatabase(DB_NAME_WEATHER);
    dbLocal.delDatabase(DB_NAME_PRODUCT);
    // this.preferences = await SharedPreferences.getInstance();
  }

  Future<Object> getLocationFromCity(String city) async {
    var url = locationUrl(getLocalUrl, city);
    var res = await _request.requestApi(method: MethodType.GET, url: url);
    if (res is ErrorModel) return res;
    var cities = (res as List<dynamic>);
    if (!CommonUtil.isEmpty(cities) &&
        !CommonUtil.isEmpty(cities[0][LocaleKeys.weather_key_woeid])) {
      return cities[0][LocaleKeys.weather_key_woeid];
    } else
      return 0;
  }

  Future<Object> fetchWeather(int locationId) async {
    var url = weatherUrl(fetchWeatherUrl, locationId);
    var res = await _request.requestApi(method: MethodType.GET, url: url);
    return res;
  }

  Future<Object> getWeatherFromCity(String city) async {
    //get data form WEATHER DB
    Object? dataLocal = await dbLocal.getWeatherByLocation(city);
    if (!CommonUtil.isEmpty(dataLocal)) {
      return WeatherModel.dataLocalFromJson(dataLocal);
    }
    var locationId = await getLocationFromCity(city);
    if (locationId is! int) return locationId;
    if (locationId == 0) {
      return {LocaleKeys.detail: LocaleKeys.not_found};
    }
    dynamic res = await fetchWeather(locationId);
    if (res is ErrorModel) {
      return res;
    } else if (res[LocaleKeys.detail] == LocaleKeys.not_found) {
      return WeatherModel();
    } else {
      WeatherModel weather = WeatherModel.fromJson(res);
      //save data to WEATHER DB (dùng cái này data lần tiếp theo lấy ra sẽ đk lấy từ local)
      // await dbLocal.addWeather(weather,dbName: DB_NAME_WEATHER);
      //save data to PRODUCT DB
      await dbLocal.addWeather(weather, dbName: DB_NAME_PRODUCT);
      WeatherModel weatherReturn = WeatherModel();
      weatherReturn.location = weather.location + "(data API)";
      weatherReturn.minTemp = weather.minTemp;
      weatherReturn.maxTemp = weather.maxTemp;
      return weatherReturn;
    }
  }
}
