import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  late SharedPreferences prefs;
  final keyToken = "token";
  final keyDeviceId = "deviceId";
  final keyCity = "cityName";

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveToken(String value) async {
    await prefs.setString(keyToken, value);
  }

  String getToken() {
    return prefs.getString(keyToken) ?? "";
  }

  void saveCityName(String value) async{
    await prefs.setString(keyCity, value);
  }

  String getCityName(){
    return prefs.getString(keyCity) ?? "";
  }

  void clear() async {
    await prefs.clear();
  }

  // Singleton
  static final AppPreference _appPreference = AppPreference._internal();

  factory AppPreference() {
    return _appPreference;
  }

  AppPreference._internal();
}
