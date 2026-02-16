// ignore_for_file: deprecated_member_use

import 'package:boimteric_app_getx/controller/home_screen_controller/home_screen_controller.dart';
import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:boimteric_app_getx/model/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  bool get isRTL {
    final locale = Get.locale;
    return locale?.languageCode == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<HomeScreenControllerImpl>(
        builder: (controller) {
          final rtl = isRTL;
          final menuIcons = rtl
              ? controller.browseMenuIcons.reversed.toList()
              : controller.browseMenuIcons;
          return Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            padding: const EdgeInsets.all(1),
            constraints: const BoxConstraints(maxWidth: 768),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  Theme.of(context).colorScheme.onBackground.withOpacity(0),
                ],
              ),
            ),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.background.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.background.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Row(
                textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(menuIcons.length, (index) {
                  MenuItemModel menuItem = menuIcons[index];

                  return Expanded(
                    key: menuItem.id,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12),
                      onPressed: () {
                        controller.selectedTab = index;
                        controller.changeScreen(index);
                      },
                      child: AnimatedOpacity(
                        opacity: controller.selectedTab == index ? 1 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 36,
                              width: 36,
                              child: RiveAnimation.asset(
                                AppRive.icons,
                                artboard: menuItem.riveIcon.artboard,
                                onInit: (artboard) {
                                  final riveController =
                                      StateMachineController.fromArtboard(
                                        artboard,
                                        menuItem.riveIcon.stateMachine,
                                      );
                                  artboard.addController(riveController!);
                                },
                              ),
                            ),
                            Positioned(
                              top: -4,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 4,
                                width: controller.selectedTab == index ? 20 : 0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
