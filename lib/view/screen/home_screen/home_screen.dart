// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:boimteric_app_getx/controller/home_screen_controller/home_screen_controller.dart';
import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:boimteric_app_getx/view/widget/home_widget/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' hide LinearGradient;

// Common Tab Scene for the tabs other than 1st one, showing only tab name in center
Widget commonTabScene(String tabName, BuildContext context) {
  return Container(
    color: Theme.of(context).colorScheme.background,
    alignment: Alignment.center,
    child: Text(
      tabName,
      style: const TextStyle(
        fontSize: 28,
        fontFamily: "Poppins",
        color: Colors.black,
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  bool get isRTL {
    final locale = Get.locale;
    return locale?.languageCode == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenControllerImpl>(
      init: HomeScreenControllerImpl(),
      builder: (controller) {
        final rtl = isRTL;
        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              Positioned(
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              // Side Menu - positioned based on RTL
              Positioned(
                left: rtl ? null : 0,
                right: rtl ? 0 : null,
                top: 0,
                bottom: 0,
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: controller.sidebarAnim,
                    builder: (BuildContext context, Widget? child) {
                      final translateX =
                          (1 - controller.sidebarAnim.value) *
                          (rtl ? 300 : -300);
                      final rotateY =
                          ((1 - controller.sidebarAnim.value) *
                              (rtl ? 30 : -30)) *
                          math.pi /
                          180;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(rotateY)
                          ..translate(translateX),
                        child: child,
                      );
                    },
                    child: FadeTransition(
                      opacity: controller.sidebarAnim,
                      child: const SideMenu(),
                    ),
                  ),
                ),
              ),
              // Main Content
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: controller.showOnBoarding
                      ? controller.onBoardingAnim
                      : controller.sidebarAnim,
                  builder: (context, child) {
                    final translateX =
                        controller.sidebarAnim.value * (rtl ? -265 : 265);
                    final rotateY =
                        (controller.sidebarAnim.value * (rtl ? -30 : 30)) *
                        math.pi /
                        180;
                    return Transform.scale(
                      scale:
                          1 -
                          (controller.showOnBoarding
                              ? controller.onBoardingAnim.value * 0.08
                              : controller.sidebarAnim.value * 0.1),
                      child: Transform.translate(
                        offset: Offset(translateX, 0),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(rotateY),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: controller.tabBody,
                ),
              ),
              // Menu Button
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: controller.sidebarAnim,
                  builder: (context, child) {
                    return SafeArea(
                      child: Stack(
                        children: [
                          // Position the button based on RTL
                          Positioned(
                            left: rtl
                                ? null
                                : controller.sidebarAnim.value * 216 + 16,
                            right: rtl ? 16 : null,
                            top: 16,
                            child: child!,
                          ),
                        ],
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: controller.onMenuPress,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(44 / 2),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.shadow.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(rtl ? -1.0 : 1.0, 1.0, 1.0),
                          child: RiveAnimation.asset(
                            AppRive.menuButton,
                            stateMachines: const ["State Machine"],
                            animations: const ["open", "close"],
                            onInit: controller.onMenuIconInit,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (controller.showOnBoarding) Center(),

              // White underlay behind the bottom tab bar
            ],
          ),
        );
      },
    );
  }
}
