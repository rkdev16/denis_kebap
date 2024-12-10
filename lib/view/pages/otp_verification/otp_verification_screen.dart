import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/controller/otp_verification/otp_verification_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_button_outline.dart';
import 'package:denis_kebap/view/widgets/common/common_pin_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpVerificationScreen extends StatefulWidget {
  OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//  final _authController = Get.find<SignupController>();
  final _otpVerificationController = Get.find<OtpVerificationController>();

  @override
  void initState() {
    super.initState();
    _otpVerificationController.startResendOtpTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.imgBgSignup), fit: BoxFit.cover)),
          child: Column(
            children: [
              CommonAppBar(
                systemUiOverlayStyle: SystemUiOverlayStyle.light
                    .copyWith(statusBarColor: Colors.transparent),
                titleTextColor: Colors.white,
                title: 'otp_verification'.tr,
                backgroundColor: Colors.transparent,
                onBackTap: () {
                  Get.back();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 32),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'please_enter_the_otp'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16.fontMultiplier),
                        children: [
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text: 'email'.tr,
                          ),
                          const TextSpan(
                            text: ' ',
                          ),
                          TextSpan(
                           // text: 'xxxxxxxx${_otpVerificationController.mobile?.substring((_otpVerificationController.mobile?.length ?? 0) - 2)}',
                            text: _otpVerificationController.email,
                          )
                        ])),
              ),
              CommonPinField(
                textEditingController: _otpVerificationController.otpController,
                onChanged: (String pin){
                  _otpVerificationController.isEnableVerifyOtpBtn.value = pin.length == 4;
                },
                onComplete: (String pin) {
                  _otpVerificationController.isEnableVerifyOtpBtn.value = pin.length == 4;
                //  _otpVerificationController.otp = pin;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              CommonButton(
                  isEnable: _otpVerificationController.isEnableVerifyOtpBtn,
                  text: 'submit_otp'.tr,
                  isLoading: _otpVerificationController.isLoadingVerifyOtp,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 40, bottom: 24),
                  clickAction: () {
                    if (_otpVerificationController.isEnableVerifyOtpBtn.value) {
                      _otpVerificationController.otpSignIn();
                    }
                  }),
              Obx(
                () => CommonButtonOutline(
                    text: _otpVerificationController.countDown.value == 0
                        ? 'resend_otp'
                        : '${'resend_otp'.tr} ${'in'.tr} 00:${_otpVerificationController.countDown.value > 10 ? _otpVerificationController.countDown.value : '0${_otpVerificationController.countDown}'}',
                    borderColor: Colors.white,
                    isLoading: _otpVerificationController.isLoading,
                    backgroundColor: Colors.black.withOpacity(0.8),
                    textColor: Colors.white,
                    clickAction: () {
                      if (_otpVerificationController.countDown.value == 0) {
                      _otpVerificationController.requestOtp().then(
                            (value) => _otpVerificationController.startResendOtpTimer());
                      }
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
                child: Text(
                  'valid_for_minutes'.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 12.fontMultiplier,
                        color: Colors.white,
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpVerificationController.cancelResendOtpTimer();
    super.dispose();
  }
}
