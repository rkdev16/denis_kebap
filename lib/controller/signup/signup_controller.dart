import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/auth_req_model.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/dialogs/common/common_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../consts/app_consts.dart';
import '../../consts/app_icons.dart';
import '../../network/post_requests.dart';
import '../../routes/app_routes.dart';
import '../../utils/enums/otp_verification_for.dart';
import '../../utils/helpers.dart';


const int timerLength = 59;

class SignupController extends GetxController {
  RxBool isEnableVerifyOtpBtn = false.obs;
  RegistrationType registrationType = RegistrationType.newCustomer;
  var selectedCountry = Rx<Country>(Country.parse('US'));
  final formKey = GlobalKey<FormState>();
  RxBool isPhoneNoExist = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingVerifyOtp = false.obs;


  late final FocusNode pinFN = FocusNode();
  late final FocusNode confirmPinFN = FocusNode();

  late final TextEditingController phoneController = TextEditingController();
  late final TextEditingController otpController = TextEditingController();
  late final TextEditingController pinController = TextEditingController();
  late final TextEditingController confirmPinController = TextEditingController();

  OtpVerificationFor? verificationFor;

  final AuthRequestModel authRequestModel = AuthRequestModel();

  var inputBorderSearchCountryCode = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: AppColors.kPrimaryColor.withOpacity(0.28)));

  Timer? _timer;
  RxInt countDown = timerLength.obs;

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
      registrationType = data[AppConsts.keyRegistrationType];
    }
  }

  validatePhoneNumForm() {
    FocusManager.instance.primaryFocus?.unfocus();
    var countryCode = selectedCountry.value.phoneCode;
    String phone = phoneController.text.toString().trim();
    if (formKey.currentState!.validate()) {
      authRequestModel.phone = phone;
      authRequestModel.countryCode = '+$countryCode';
      requestOtp();
    }
  }

  Future<void> requestOtp() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> requestBody = {
        "countryCode": authRequestModel.countryCode,
        "mobile": authRequestModel.phone,
      };
      debugPrint("requestBody = $requestBody");

      var result = await PostRequests.requestOtp(requestBody);
      if (result != null) {
        if (result.success) {
         // authRequestModel.otp = result.requestOtpData?.otpCode;
          authRequestModel.phone = result.requestOtpData?.mobile;
          authRequestModel.countryCode = result.requestOtpData?.countryCode;
          Get.toNamed(AppRoutes.routeOtpVerificationScreen);
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
    countDown.value =timerLength;
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



  verifyOtp() async {

    try {
      isLoadingVerifyOtp.value = true;
      Map<String, dynamic> requestBody = {
        "countryCode": authRequestModel.countryCode,
        "mobile": authRequestModel.phone,
        "otpCode": authRequestModel.otp,
      };
      var result = await PostRequests.verifyOtp(requestBody);
      if (result != null) {
        if (result.success) {
          Get.toNamed(AppRoutes.routeSetupPinScreen);
        } else {
          AppAlerts.error(message: result.message);
        }
      }
    } finally {
      isLoadingVerifyOtp.value = false;
    }
  }

   pickCountryCode(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showCountryPicker(
      context: context,
      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
      exclude: <String>['KN', 'MF'],
      favorite: <String>['US'],
      //Optional. Shows phone code before the country name.
      showPhoneCode: true,
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        print('Select country: ${country.flagEmoji}');
        selectedCountry.value = country;
      },
      // Optional. Sets the theme for the country list picker.
      countryListTheme: CountryListThemeData(
        flagSize: 15,

        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        textStyle: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: AppColors.colorTextPrimary, fontSize: 15),
        // Optional. Styles the search field.
        inputDecoration: InputDecoration(
            hintText: 'Start typing to search',
            hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 12.fontMultiplier,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.4)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8),
              child: SvgPicture.asset(
                AppIcons.icSearch,
                height: 18,
                width: 18,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 18, minHeight: 18),
            filled: true,
            fillColor: AppColors.kPrimaryColor.withOpacity(0.02),
            border: inputBorderSearchCountryCode,
            errorBorder: inputBorderSearchCountryCode,
            enabledBorder: inputBorderSearchCountryCode,
            disabledBorder: inputBorderSearchCountryCode,
            focusedBorder: inputBorderSearchCountryCode,
            focusedErrorBorder: inputBorderSearchCountryCode),
      ),
    );
  }


bool  validateSetupPinForm(){

   String? pin = pinController.text.toString().trim();
   String? confirmPin = confirmPinController.text.toString().trim();

   authRequestModel.pin = pin;
   authRequestModel.confirmPin = confirmPin;

   bool isValidate =true;

   if(pin.isEmpty || pin.length <4){
     AppAlerts.alert(message: 'message_enter_pin'.tr);
     isValidate = false;

   }
  else if(confirmPin.isEmpty || confirmPin.length <4){
     AppAlerts.alert(message: 'message_enter_confirm_pin'.tr);
     isValidate = false;
   }
  else if(pin != confirmPin){
     AppAlerts.alert(message: 'message_pin_does_not_matched'.tr);
     isValidate = false;
   }

  return   isValidate ;
  }





  
  createPin() async{
    
    try{
      isLoading.value = true;
      Map<String,dynamic> requestBody = {
        "countryCode": authRequestModel.countryCode,
        "mobile": authRequestModel.phone,
        "otpCode": authRequestModel.otp,
        "pin": authRequestModel.pin,
        "confirmPin": authRequestModel.confirmPin
      };
      
      
      var result = await PostRequests.createPin(requestBody);
      if(result !=null){
        if(result.success){
          PreferenceManager.user = result.user;
          PreferenceManager.userToken = result.user?.token;
          showCreatePinSuccessDialog();

        }else{
          AppAlerts.error(message: result.message);
        }

      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }

    }finally{
      isLoading.value =false;
    }
  }
  showCreatePinSuccessDialog(){
    CommonAlertDialog.showDialog(
      title: 'success'.tr,
        message: 'message_pin_created'.tr,
        positiveText: 'ok'.tr, positiveBtCallback: (){
        Get.back();
      Get.offAllNamed(AppRoutes.routeDashboardScreen);
    });
  }



}
