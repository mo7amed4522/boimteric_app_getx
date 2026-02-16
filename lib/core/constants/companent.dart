// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? label;
  final IconData? suffixIcon;
  final TextEditingController? mycontroller;
  final String? Function(String?) validator;
  final TextInputType? textInputType;
  bool? enabled = true;
  final bool? isShowText;
  Widget? prefixIcon;
  final void Function()? sufficsIconTap;
  CustomTextFormField({
    super.key,
    this.sufficsIconTap,
    this.isShowText,
    this.prefixIcon,
    this.textInputType,
    required this.validator,
    this.mycontroller,
    this.hintText,
    this.label,
    this.suffixIcon,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      child: TextFormField(
        enabled: enabled,
        keyboardType: textInputType,
        obscureText: isShowText == null || isShowText == false ? false : true,
        validator: validator,
        style: Theme.of(context).textTheme.bodyMedium,
        controller: mycontroller,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          fillColor: Theme.of(context).colorScheme.background,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14.0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 30,
          ),
          suffixIcon: InkWell(
            onTap: sufficsIconTap,
            child: Icon(suffixIcon, color: Theme.of(context).primaryColorLight),
          ),
          label: Container(
            margin: const EdgeInsets.symmetric(horizontal: 9),
            child: Text(label!),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.sp),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.ontap,
    required this.buttonName,
  });

  final VoidCallback ontap;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: Get.width / 1.3,
        height: Get.height / 15,
        decoration: ShapeDecoration(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x19C94210),
              blurRadius: 30,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(buttonName, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

class ButtonLoginWidget extends StatelessWidget {
  const ButtonLoginWidget({
    super.key,
    required this.ontap,
    required this.buttonName,
  });

  final VoidCallback ontap;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height / 15,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x19C94210),
              blurRadius: 30,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          buttonName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}

class GradientWidget extends StatelessWidget {
  final Widget child;
  final Color? color1;
  final Color? color2;

  const GradientWidget({
    super.key,
    required this.child,
    this.color1,
    this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          transform: GradientRotation(1),
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Theme.of(context).colorScheme.inversePrimary,
            Theme.of(context).colorScheme.onInverseSurface,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

Widget boxPriceWidget(String text1, String txt2, context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.sp),
    height: 10.h,
    width: 30.w,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Theme.of(context).colorScheme.error.withOpacity(0.2),
          offset: const Offset(1.1, 1.1),
          blurRadius: 8.0,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          txt2,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    ),
  );
}
