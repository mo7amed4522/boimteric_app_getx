// ignore_for_file: unused_field

import 'dart:convert';

// import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:boimteric_app_getx/core/constants/curd.dart';
import 'package:boimteric_app_getx/core/constants/loader.dart';
import 'package:boimteric_app_getx/core/routes/app_route.dart';
import 'package:boimteric_app_getx/core/server/serves.dart';
import 'package:boimteric_app_getx/model/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class LoginScreenController extends GetxController {
  void onSubmit();
  void changeShowPassword();
  void saveBaseUrl(String url);
}

class LoginScreenControllerImpl extends LoginScreenController {
  late TextEditingController baseUrlController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isShowPassword = true;
  IconData iconDate = CupertinoIcons.eye_slash_fill;
  MyServices myServices = Get.find();
  final Crud _crud = Crud();
  LoginModel? _loginModel;

  @override
  void onInit() {
    baseUrlController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    String? savedBaseUrl = myServices.sharedPreferences.getString('baseUrl');
    if (savedBaseUrl != null) {
      baseUrlController.text = savedBaseUrl;
    }

    super.onInit();
  }

  @override
  void onSubmit() async {
    Loader().lottieLoader();
    String baseUrl = myServices.sharedPreferences.getString('baseUrl') ?? '';
    String loginUrl = '$baseUrl/api/attendance/login';
    var response = await _crud.postRequest(loginUrl, {
      "username": emailController.text,
      "password": passwordController.text,
    });
    debugPrint("response is $response");
    if (response['success'] == true) {
      _loginModel = LoginModel.fromJson(response);
      debugPrint("response is ${_loginModel!}");
      Get.back();
      await myServices.sharedPreferences.setBool('isLogin', true);
      await myServices.sharedPreferences.setString(
        'userdata',
        jsonEncode(response),
      );
      emailController.clear();
      passwordController.clear();
      Get.offAndToNamed(AppRouter.homeScreen);
      update();
    } else {
      Get.back();
      Get.snackbar(
        "Error",
        response['error'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    baseUrlController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void saveBaseUrl(String url) async {
    await myServices.sharedPreferences.setString('baseUrl', url);
  }

  @override
  void changeShowPassword() {
    if (isShowPassword == true) {
      isShowPassword = false;
      iconDate = CupertinoIcons.eye_solid;
    } else {
      isShowPassword = true;
      iconDate = CupertinoIcons.eye_slash_fill;
    }
    update();
  }
}
