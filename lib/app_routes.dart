import 'package:get/get.dart';
import 'modules/modules.dart';
import 'models/models.dart';

abstract class Routes {
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const HOMEWEATHER = '/homeWeather';
  static const SETTING = '/setting';
  static const ERROR = '/error';
}

/* * Routes cho app
* Dùng được để deep link
! Giá trị truyền vào giống với uri
? https://github.com/jonataslaw/getx/blob/master/documentation/en_US/route_management.md
* */
class AppRoutes {
  static const INITIAL = Routes.SPLASH;
  static final unknownRoute =
      GetPage(name: Routes.ERROR, page: () => ErrorPage(error: ErrorModel()));
  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage()),
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.HOMEWEATHER, page: () => HomeWeatherPage()),
    GetPage(name: Routes.SETTING, page: () => SettingPage()),
  ];
}
