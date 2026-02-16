import 'package:boimteric_app_getx/controller/splash_screen_controller/splash_screen_controller.dart';
import 'package:boimteric_app_getx/view/widget/splash_widget/splash_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashScreenControllerImpl>(
        init: SplashScreenControllerImpl(),
        builder: (controller) => const SplashScreenWidget(),
      ),
    );
  }
}
