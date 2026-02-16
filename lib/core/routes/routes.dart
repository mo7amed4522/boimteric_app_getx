import 'package:boimteric_app_getx/core/routes/app_route.dart';
import 'package:boimteric_app_getx/view/screen/home_screen/home_screen.dart';
import 'package:boimteric_app_getx/view/screen/login_screen/login_screen.dart';
import 'package:boimteric_app_getx/view/screen/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: AppRouter.start,
    page: () => const SplashScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRouter.loginScreen,
    page: () => const LoginScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRouter.homeScreen,
    page: () => const HomeScreen(),
    transition: Transition.fadeIn,
  ),
];
