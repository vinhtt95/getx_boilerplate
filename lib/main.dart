import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_boilerplate/modules/modules.dart';

import 'data/app_preference.dart';
import 'modules/modules.dart';
import 'app_routes.dart';
import 'util/lang/translation_service.dart';
import 'util/theme/app_themes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  AppPreference().init();
  Get.put<ThemeController>(ThemeController());
  runApp(
    LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        ScreenUtil.init(
          constraints,
          designSize: Size(375, 667),
        );
        return MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromStore();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      unknownRoute: AppRoutes.unknownRoute,
      initialRoute: AppRoutes.INITIAL,
      getPages: AppRoutes.routes,
      locale: TranslationService.fallbackLocale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
    );
  }
}