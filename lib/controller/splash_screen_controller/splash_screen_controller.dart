import 'package:boimteric_app_getx/core/routes/app_route.dart';
import 'package:boimteric_app_getx/core/server/serves.dart';
import 'package:get/get.dart';

abstract class SplashScreenController extends GetxController {}

class SplashScreenControllerImpl extends SplashScreenController {
  MyServices myServices = Get.find();
  bool isLogin = false;
  

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3), () {
      getUserData();
      if (isLogin) {
        Get.toNamed(AppRouter.homeScreen);
      } else {
        Get.toNamed(AppRouter.loginScreen);
      }
    });
    super.onInit();
  }

  void getUserData() {
    isLogin = myServices.sharedPreferences.getBool('isLogin') ?? false;
    myServices.sharedPreferences.getString('userdata');
  }
}
