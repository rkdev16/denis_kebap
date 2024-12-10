class AuthRequestModel{
  String? countryCode;
  String? phone;
  String? otp;
  String? pin;
  String? confirmPin;





  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "phone": phone,
    "otp": otp,
    "pin": confirmPin,
  };



}