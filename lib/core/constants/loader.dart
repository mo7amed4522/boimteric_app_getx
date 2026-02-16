import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Loader {
  Future<void> lottieLoader() {
    return Future.delayed(const Duration(seconds: 0), () {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Lottie.asset(AppJson.load, height: 100, width: 100),
          );
        },
        barrierLabel: '',
      );
    });
  }

  Widget lottieWidget() {
    return Center(child: Lottie.asset(AppJson.load, height: 100, width: 100));
  }
}
