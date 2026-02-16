// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:boimteric_app_getx/controller/login_screen_controller/login_screen_controller.dart';
import 'package:boimteric_app_getx/core/constants/companent.dart';
import 'package:boimteric_app_getx/core/func/auth/valid_input.dart';
import 'package:boimteric_app_getx/view/widget/login_widget/login_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formState = GlobalKey();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: GetBuilder<LoginScreenControllerImpl>(
          init: LoginScreenControllerImpl(),
          builder: (controller) => Column(
            children: [
              LogoImageWidget(),
              Expanded(
                // Expanded moved here
                child: Form(
                  key: formState,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: Get.height - 33.h),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0.sp,
                            vertical: 16.sp,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 9.h),
                              CustomTextFormField(
                                mycontroller: controller.baseUrlController,
                                hintText: "Enter your base url".tr,
                                label: "Base URL".tr,
                                prefixIcon: Icon(CupertinoIcons.link),
                                textInputType: TextInputType.text,
                                validator: (val) {
                                  return validInput(val!, 3, 100, "baseurl");
                                },
                              ),
                              SizedBox(height: 2.h),
                              CustomTextFormField(
                                mycontroller: controller.emailController,
                                hintText: "Enter your username".tr,
                                label: "Username".tr,
                                prefixIcon: Icon(CupertinoIcons.envelope_fill),
                                textInputType: TextInputType.text,
                                validator: (val) {
                                  return validInput(val!, 3, 25, "Username");
                                },
                              ),
                              SizedBox(height: 2.h),
                              CustomTextFormField(
                                mycontroller: controller.passwordController,
                                hintText: "Enter your password".tr,
                                label: "password".tr,
                                prefixIcon: Icon(CupertinoIcons.lock_fill),
                                suffixIcon: controller.iconDate,
                                isShowText: controller.isShowPassword,
                                sufficsIconTap: controller.changeShowPassword,
                                textInputType: TextInputType.visiblePassword,
                                validator: (val) {
                                  return validInput(val!, 5, 100, "password");
                                },
                              ),
                              SizedBox(height: 2.h),
                              Spacer(),
                              ButtonLoginWidget(
                                buttonName: 'Login to my account'.tr,
                                ontap: () {
                                  if (formState.currentState!.validate()) {
                                    controller.saveBaseUrl(
                                      controller.baseUrlController.text,
                                    );
                                    controller.onSubmit();
                                  }
                                },
                              ),
                              SizedBox(height: 30.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
