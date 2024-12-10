import 'dart:async';

import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/network/post_requests.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


const int timerLength = 60;
class OtpVerificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingVerifyOtp = false.obs;
  RxBool isEnableVerifyOtpBtn = false.obs;
 // String? countryCode;
 // String? mobile;
  String? email;
 // bool isNewUser = false;
 // String? otp;
  Timer? _timer;
  RxInt countDown = timerLength.obs;

  late final TextEditingController otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getArguments();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  getArguments() {
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
    //  countryCode = data[AppConsts.keyCountryCode];
    //  mobile = data[AppConsts.keyMobile];
      email = data[AppConsts.keyEmail];
    //  isNewUser = data[AppConsts.keyIsNewUser];
     // otp = data[AppConsts.keyOTP];
    }
  }
  Future<void> requestOtp() async {

    try {
      isLoading.value = true;
      Map<String, dynamic> requestBody = {
        "email": email,
      };
      debugPrint("requestBody = $requestBody");
      var result = await PostRequests.requestOtp(requestBody);
      if (result != null) {
        if (result.success) {
         // otp = result.requestOtpData?.otpCode;
          //for now set otp on pin will change it later once we integrate otp on Messages.
         // otpController.text = otp??'';
         // isEnableVerifyOtpBtn.value =true

        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  startResendOtpTimer() {
    debugPrint("startResendOtpTimer");
    cancelResendOtpTimer();
    countDown.value = timerLength;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown.value == 0) {
        _timer?.cancel();
      } else {
        countDown.value--;
      }
    });
  }

  cancelResendOtpTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
    }
  }

  otpSignIn() async {
    try {
      isLoadingVerifyOtp.value = true;
      Map<String, dynamic> requestBody = {
        "email": email,
        "otpCode": otpController.text.toString().trim(),
      };
    //  requestBody.addIf(isNewUser, 'countryCode', countryCode);
    //  requestBody.addIf(isNewUser, 'mobile', mobile);


      var result = await PostRequests.otpSignIn(requestBody);
      if (result != null) {
        if (result.success) {
          PreferenceManager.token = result.user?.token;
          PreferenceManager.user = result.user;
          Get.offAllNamed(AppRoutes.routeDashboardScreen);

        } else {
          AppAlerts.error(message: result.message);
        }
      }
    } finally {
      isLoadingVerifyOtp.value = false;
    }
  }



}
