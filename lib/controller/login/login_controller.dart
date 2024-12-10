import 'package:country_picker/country_picker.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/app_formatters.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/network/post_requests.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/app_alerts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {

  final formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  var selectedCountry = Rx<Country>(Country.parse('AT'));

  final isNewUser = false.obs;
  final isPhoneExists = false.obs;
  final RxBool isLoading = false.obs;
  final RxString enteredEmail = ''.obs;
  final RxString enteredPhone = ''.obs;
  final RxBool isLoadingCheckEmail = false.obs;
  final RxBool isLoadingCheckPhone = false.obs;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Worker? checkEmailExistWorker;

  Worker? checkPhoneExistWorker;

  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();
   // initWorkers();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
   // disposeWorkers();
    disposeTextEditingControllers();
    super.onClose();
  }

  initTextEditingControllers() {
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  disposeTextEditingControllers() {
    emailController.dispose();
    phoneController.dispose();
  }

  initWorkers() {
    checkEmailExistWorker =
        debounce(enteredEmail, (callback) => checkEmailExists());
    checkPhoneExistWorker =
        debounce(enteredPhone, (callback) => checkPhoneExists());
  }

  disposeWorkers() {
    checkEmailExistWorker?.dispose();
    checkPhoneExistWorker?.dispose();
  }

  checkEmailExists() async {
    final String email = enteredEmail.value;
    debugPrint("Check Email Exists for = $email");

    if (email.isEmpty) {
      isNewUser.value = false;
      debugPrint("Empty Email");
      return;
    }

    if (!AppFormatters.validEmailExp.hasMatch(email)) {
      debugPrint("Email not valid");
      return;
    }

    try {
      isLoadingCheckEmail.value = true;
      final Map<String, dynamic> requestBody = {'email': email};

      final result = await PostRequests.checkEmailExists(requestBody);
      if (result != null) {
        isNewUser.value = !result.success;
      } else {
        isNewUser.value = false;
      }
    } finally {
      isLoadingCheckEmail.value = false;
    }
  }

  checkPhoneExists() async {
    final String phone = enteredPhone.value;
    debugPrint("Check Phone Exists for = $phone");
    if (phone.isEmpty) {
      isPhoneExists.value = false;

      return;
    }

    if (!AppFormatters.validPhoneExp.hasMatch(phone)) {
      return;
    }

    try {
      isLoadingCheckPhone.value = true;
      final Map<String, dynamic> requestBody = {
        "countryCode": '+${selectedCountry.value.phoneCode}',
        'mobile': phone
      };

      final result = await PostRequests.checkPhoneExists(requestBody);
      if (result != null) {
        isPhoneExists.value = result.success;
      } else {
        isPhoneExists.value = false;
      }
    } finally {
      isLoadingCheckPhone.value = false;
    }
  }

  googleLogin() async {
    try {
      var result = await googleSignIn.signIn();
      Get.toNamed(AppRoutes.routeDashboardScreen);
      if (result == null) {
        return;
      }
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("finalResult$finalResult");
      debugPrint("userData${userData}");
    } finally {}
  }

  appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print(credential);

    // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
    // after they have been validated with Apple (see `Integration` section for more information on how to do this)
  }

  Future<void> signOutFromGoogle() async {
    await googleSignIn.signOut();
    // await auth.signOut();
  }

  // bool validateLoginForm() {
  //   String email = enteredEmail.value;
  //   String phone = enteredPhone.value;
  //
  //   if (isLoadingCheckEmail.value || isLoadingCheckPhone.value) {
  //     return false;
  //   }
  //
  //   if (email.isEmpty) {
  //     return false;
  //   }
  //   if (isNewUser.value && phone.isEmpty) {
  //     return false;
  //   }
  //
  //   if (isPhoneExists.value) {
  //     return false;
  //   }
  //   return true;
  // }



  Future<void> requestOtp() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> requestBody = {
       // "email": enteredEmail.value,
        "email": emailController.text.toString().trim(),
      };

      debugPrint("requestBody = $requestBody");
      var result = await PostRequests.requestOtp(requestBody);
      if (result != null) {
        if (result.success) {
          Get.toNamed(AppRoutes.routeOtpVerificationScreen, arguments: {
            // AppConsts.keyOTP : result.requestOtpData?.otpCode,
           // AppConsts.keyMobile: enteredPhone.value,
           // AppConsts.keyCountryCode: '+${selectedCountry.value.phoneCode}',
            AppConsts.keyEmail: result.requestOtpData?.email,
          //  AppConsts.keyIsNewUser: isNewUser.value,
          });
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

  selectCountry(Country country) {
    selectedCountry.value = country;
    checkPhoneExists();
  }
}
