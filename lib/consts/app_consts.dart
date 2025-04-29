
import 'package:denis_kebap/config/size_config.dart';
import 'package:denis_kebap/utils/decimal_text_input_formatter.dart';
import 'package:flutter/services.dart';

class AppConsts {
  AppConsts._();

  static const String appName = 'DennisKebap';
  static const double tabFontFactor = 1.5;
  static const double mobileFontFactor = 1.0;
  static const locale = 'en_US';

  static const String googleApiKey = "<Google API KEY>";

  static const String stripePK = "<STRIPE KEY>";
  static const String stripeSK = "<STRIPE KEY>";


  static double commonFontSizeFactor =
      SizeConfig.isMobile ? mobileFontFactor : tabFontFactor;

  static const String baseUrl = "";
  static const String urlTerms = "<TERMS AND CONDITIONS>";
  static const String urlPrivacyPolicy = "<PRIVACY POLICY>";


  static const currencySign = '€';

  static var   amountInputFormatter = <TextInputFormatter>[
    // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
    DecimalTextInputFormatter(),
    LengthLimitingTextInputFormatter(15)
  ];

  //false on release

  static const bool isLog = true;
  static const bool isDebug = true;

  //data transfer keys
  static String keyBusinessId = 'key_business_id';
  static String keyServiceId = 'key_service_id';
  static String keyServiceIdsArray = 'key_service_ids_array';

  static const double mapCameraTilt = 50.440717697143555;
  static const double mapCameraZoom = 19.151926040649414;




  //keys

static const keyRegistrationType = 'key_registration_type';
static const keyOTPVerificationType = 'key_otp_verification_type';
static const keyCountryCode = 'key_country_code';
static const keyEmail= 'key_email';
static const keyMobile = 'key_mobile';
static const keyOTP = 'key_otp';
static const keyIsNewUser = 'key_is_new_user';
static const keyPaymentLinkData = 'key_payment_link_data';
}
