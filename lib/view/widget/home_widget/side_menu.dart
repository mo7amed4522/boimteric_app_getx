// ignore_for_file: deprecated_member_use

import 'package:boimteric_app_getx/controller/home_screen_controller/home_screen_controller.dart';
import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:boimteric_app_getx/core/constants/menu_row.dart';
import 'package:boimteric_app_getx/model/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

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
        return Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          constraints: const BoxConstraints(maxWidth: 288),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: rtl
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.2),
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.inversePrimary,
                      child: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: rtl
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.loginModel?.employeeName ?? "",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 17,
                            fontFamily: "Inter",
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MenuButtonSection(
                        title: "main_screen".tr,
                        selectedMenu: controller.selectedMenu,
                        menuIcons: controller.browseMenuIcons,
                        isRTL: rtl,
                        onMenuPress: (menu) =>
                            controller.onMenuPressSideMenu(menu),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Opacity(
                        opacity: 0.6,
                        child: RiveAnimation.asset(
                          AppRive.icons,
                          stateMachines: [
                            controller
                                .settingsMenuIcons[0]
                                .riveIcon
                                .stateMachine,
                          ],
                          artboard:
                              controller.settingsMenuIcons[0].riveIcon.artboard,
                          onInit: (artboard) =>
                              controller.onThemeRiveIconInit(artboard),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "dark_mode".tr,
                        textAlign: rtl ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 17,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CupertinoSwitch(
                      value: controller.isDarkMode,
                      onChanged: controller.onThemeToggle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection({
    super.key,
    required this.title,
    required this.menuIcons,
    this.selectedMenu = "Home",
    this.isRTL = false,
    this.onMenuPress,
  });

  final String title;
  final String selectedMenu;
  final List<MenuItemModel> menuIcons;
  final bool isRTL;
  final Function(MenuItemModel menu)? onMenuPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isRTL
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 40,
            bottom: 8,
          ),
          child: Text(
            title,
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
              fontSize: 15,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var menu in menuIcons) ...[
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onBackground.withOpacity(0.1),
                  thickness: 1,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  isRTL: isRTL,
                  onMenuPress: () => onMenuPress!(menu),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
