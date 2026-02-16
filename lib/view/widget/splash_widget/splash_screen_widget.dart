// ignore_for_file: deprecated_member_use

import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:boimteric_app_getx/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondaryDark,
            AppColors.primary.withOpacity(0.5),
            AppColors.secondaryDark.withOpacity(0.5),
            AppColors.primary,
          ],
        ),
      ),
      child: Center(
        child: Image.asset(
          AppImages.logo,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
