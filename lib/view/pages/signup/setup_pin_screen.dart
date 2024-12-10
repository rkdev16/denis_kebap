import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/controller/signup/signup_controller.dart';

import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_pin_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SetupPinScreen extends StatelessWidget {
  SetupPinScreen({Key? key}) : super(key: key);

  final _authController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.imgBgSignup),
                      fit: BoxFit.cover)),
              child: Stack(
                children: [
                  Column(
                    children: [
                      CommonAppBar(
                        systemUiOverlayStyle: SystemUiOverlayStyle.light
                            .copyWith(statusBarColor: Colors.transparent),
                        titleTextColor: Colors.white,
                        title: '',
                        backgroundColor: Colors.transparent,
                        onBackTap: () {
                          Get.back();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Image.asset(
                          AppImages.imgAppLogo,
                          height: 120,
                        ),
                      ),
                      Text(
                        'setup_new_pin'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 26.fontMultiplier,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8),
                        child: Text(
                          'setup_new_pin_instructions'.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 16),
                        child: Text(
                          'pin_code'.tr.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                        ),
                      ),
                      CommonPinField(
                          focusNode: _authController.pinFN,
                          textEditingController: _authController.pinController,
                          onComplete: (String pin) {
                            FocusScope.of(context)
                                .requestFocus(_authController.confirmPinFN);
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0, bottom: 16),
                        child: Text(
                          'confirm_your_pin_code'.tr.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                        ),
                      ),
                      CommonPinField(
                          focusNode: _authController.confirmPinFN,
                          textEditingController:
                              _authController.confirmPinController,
                          onComplete: (String pin) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CommonButton(
                        text: 'save'.tr,
                        isLoading: _authController.isLoading,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 32),
                        clickAction: () {
                          if (_authController.validateSetupPinForm()) {
                            _authController.createPin();
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
