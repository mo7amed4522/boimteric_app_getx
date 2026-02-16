// ignore_for_file: prefer_final_fields, unused_field, strict_top_level_inference

import 'dart:convert';
import 'dart:ui';

import 'package:boimteric_app_getx/core/server/serves.dart';
import 'package:boimteric_app_getx/core/theme/app_colors.dart';
import 'package:boimteric_app_getx/model/login_model.dart';
import 'package:boimteric_app_getx/model/menu_item.dart';
import 'package:boimteric_app_getx/model/tab_item.dart';
import 'package:boimteric_app_getx/view/screen/home_tab_view_screen/home_tab_view_screen.dart';
import 'package:boimteric_app_getx/view/screen/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

abstract class HomeScreenController extends GetxController {
  LoginModel? getUserData();
}

class HomeScreenControllerImpl extends HomeScreenController
    with GetTickerProviderStateMixin {
  MyServices myServices = Get.find();
  LoginModel? loginModel;
  // Animation Controllers
  late AnimationController? animationController;
  late AnimationController? onBoardingAnimController;
  late Animation<double> onBoardingAnim;
  late Animation<double> sidebarAnim;

  bool showOnBoarding = false;

  List<MenuItemModel> get browseMenuIcons => [
    MenuItemModel(
      title: "home_screen".tr,
      riveIcon: TabItem(stateMachine: "HOME_interactivity", artboard: "HOME"),
    ),
    MenuItemModel(
      title: "setting_screen".tr,
      riveIcon: TabItem(
        stateMachine: "SETTINGS_Interactivity",
        artboard: "SETTINGS",
      ),
    ),
  ];

  List<MenuItemModel> get settingsMenuIcons => [
    MenuItemModel(
      title: "dark_mode".tr,
      riveIcon: TabItem(
        stateMachine: "SETTINGS_Interactivity",
        artboard: "SETTINGS",
      ),
    ),
  ];

  String _selectedMenu = "";
  String get selectedMenu =>
      _selectedMenu.isEmpty ? browseMenuIcons[0].title : _selectedMenu;
  set selectedMenu(String value) => _selectedMenu = value;
  bool isDarkMode = false;
  int selectedTab = 0;

  void presentOnBoarding(bool show) {
    if (show) {
      showOnBoarding = true;
      update();

      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      onBoardingAnimController?.animateWith(springAnim);
    } else {
      onBoardingAnimController?.reverse().whenComplete(
        () => {showOnBoarding = false, update()},
      );
    }
  }

  void onThemeRiveIconInit(artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      settingsMenuIcons[0].riveIcon.stateMachine,
    );
    artboard.addController(controller!);
    settingsMenuIcons[0].riveIcon.status =
        controller.findInput<bool>("active") as SMIBool;
  }

  void onMenuPressSideMenu(MenuItemModel menu) {
    selectedMenu = menu.title;
    // Find the index of the selected menu in browseMenuIcons
    int index = browseMenuIcons.indexWhere((item) => item.title == menu.title);
    if (index != -1) {
      changeScreen(index);
    }
    update();
  }

  void onThemeToggle(value) async {
    isDarkMode = value;
    await myServices.sharedPreferences.setBool('theme', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    update();
    settingsMenuIcons[0].riveIcon.status?.change(value);
  }

  // Rive State Machine Input
  late SMIBool menuBtn;

  Widget tabBody = Container(color: AppColors.background);
  final List<Widget> screens = [
    const HomeTabViewScreen(), // Home tab
    const SettingsScreen(), // Settings tab
  ];

  void changeScreen(int tabIndex) {
    tabBody = screens[tabIndex];
    update();
  }

  final springDesc = const SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  void onMenuIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine",
    );
    artboard.addController(controller!);
    menuBtn = controller.findInput<bool>("isOpen") as SMIBool;
    menuBtn.value = true;
  }

  void onMenuPress() {
    if (menuBtn.value) {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      animationController?.animateWith(springAnim);
    } else {
      animationController?.reverse();
    }
    menuBtn.change(!menuBtn.value);

    SystemChrome.setSystemUIOverlayStyle(
      menuBtn.value ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
  }

  @override
  void onInit() {
    getUserData();
    // Load saved theme preference
    // If null (system default), determine based on current platform brightness
    final themeValue = myServices.sharedPreferences.getBool('theme');
    if (themeValue != null) {
      isDarkMode = themeValue;
    } else {
      // System default - check current platform brightness
      final platformBrightness = PlatformDispatcher.instance.platformBrightness;
      isDarkMode = platformBrightness == Brightness.dark;
    }
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    onBoardingAnimController = AnimationController(
      duration: const Duration(milliseconds: 350),
      upperBound: 1,
      vsync: this,
    );

    sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController!, curve: Curves.linear),
    );

    onBoardingAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: onBoardingAnimController!, curve: Curves.linear),
    );

    tabBody = screens.first;
    super.onInit();
  }

  @override
  void dispose() {
    animationController?.dispose();
    onBoardingAnimController?.dispose();
    super.dispose();
  }

  @override
  LoginModel? getUserData() {
    String? userDataString = myServices.sharedPreferences.getString('userdata');
    if (userDataString != null) {
      loginModel = LoginModel.fromJson(jsonDecode(userDataString));
    }
    debugPrint(userDataString);
    return loginModel;
  }
}
