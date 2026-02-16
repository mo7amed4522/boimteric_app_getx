import 'dart:io';

import 'package:boimteric_app_getx/controller/binding/initial_bindings.dart';
import 'package:boimteric_app_getx/core/routes/routes.dart';
import 'package:boimteric_app_getx/core/server/serves.dart';
import 'package:boimteric_app_getx/core/theme/theme_color.dart';
import 'package:boimteric_app_getx/core/translation/my_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeMode _getInitialThemeMode() {
    final myServices = Get.find<MyServices>();
    final themeValue = myServices.sharedPreferences.getBool('theme');
    if (themeValue == true) {
      return ThemeMode.dark;
    } else if (themeValue == false) {
      return ThemeMode.light;
    }
    return ThemeMode.system;
  }

  Locale _getInitialLocale() {
    final myServices = Get.find<MyServices>();
    final langCode = myServices.sharedPreferences.getString('lang') ?? 'en';
    return Locale(langCode);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, devicetype) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: MyTranslation(),
        theme: AppTheme.lightTheme,
        locale: _getInitialLocale(),
        fallbackLocale: const Locale('en'),
        darkTheme: AppTheme.darkTheme,
        themeMode: _getInitialThemeMode(),
        title: 'OptiSpa'.tr,
        initialBinding: InitialBindings(),
        getPages: routes,
      ),
    );
  }
}
