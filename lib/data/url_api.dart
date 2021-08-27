const demoApiUrl = "/location/search/?query=Chicago";
const getLocalUrl = "/location/search/?query";
const fetchWeatherUrl = "/location/";

class ProdEnvironment{
  final baseUrl = "https://www.metaweather.com";
  final baseApi = "/api";
  final baseVersion = "";
  final receiveTimeout = 2 * 60 * 1000;
  final connectTimeout = 2 * 60 * 1000;

  String get apiUrl => "$baseUrl$baseApi$baseVersion";
}

final environment = ProdEnvironment();
