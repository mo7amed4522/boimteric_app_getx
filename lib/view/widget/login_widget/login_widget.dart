import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LogoImageWidget extends StatelessWidget {
  const LogoImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.sp),
        child: Image.asset(AppImages.logo, fit: BoxFit.cover),
      ),
    );
  }
}
