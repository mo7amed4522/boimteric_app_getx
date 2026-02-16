import 'package:boimteric_app_getx/core/routes/app_route.dart';
import 'package:boimteric_app_getx/core/server/serves.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class SettingScreenController extends GetxController {
  void changeLanguage(String languageCode);
  void logout();
}

class SettingScreenControllerImpl extends SettingScreenController {
  MyServices myServices = Get.find();
  String languageCode = "en";

  @override
  void onInit() {
    languageCode = myServices.sharedPreferences.getString('lang') ?? 'en';
    super.onInit();
  }

  @override
  void changeLanguage(String newLanguageCode) {
    languageCode = newLanguageCode;
    myServices.sharedPreferences.setString('lang', newLanguageCode);
    Get.updateLocale(Locale(newLanguageCode));
    update();
  }

  @override
  void logout() async {
    await myServices.sharedPreferences.clear();
    Get.offAllNamed(AppRouter.loginScreen);
    update();
  }
}
