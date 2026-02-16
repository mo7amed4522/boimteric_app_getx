// ignore_for_file: deprecated_member_use

import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:boimteric_app_getx/model/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.menu,
    this.selectedMenu = "Home",
    this.isRTL = false,
    this.onMenuPress,
  });

  final MenuItemModel menu;
  final String selectedMenu;
  final bool isRTL;
  final Function? onMenuPress;

  void _onMenuIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      menu.riveIcon.stateMachine,
    );
    artboard.addController(controller!);
    menu.riveIcon.status = controller.findInput<bool>("active") as SMIBool;
  }

  void onMenuPressed() {
    if (selectedMenu != menu.title) {
      onMenuPress!();
      if (menu.riveIcon.status != null) {
        menu.riveIcon.status!.change(true);
        Future.delayed(const Duration(seconds: 1), () {
          menu.riveIcon.status?.change(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
      children: [
        // The menu button background that animates as we click on it
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: selectedMenu == menu.title ? 288 - 16 : 0,
          height: 56,
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        CupertinoButton(
          padding: const EdgeInsets.all(12),
          pressedOpacity: 1, // disable touch effect
          onPressed: onMenuPressed,
          child: Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              SizedBox(
                // color: Theme.of(context).colorScheme.primaryContainer,
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: 0.6,
                  child: RiveAnimation.asset(
                    AppRive.icons,
                    stateMachines: [menu.riveIcon.stateMachine],
                    artboard: menu.riveIcon.artboard,
                    onInit: _onMenuIconInit,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                menu.title,
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
