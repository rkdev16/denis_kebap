// To parse this JSON data, do
//
//     final requestOtpResModel = requestOtpResModelFromJson(jsonString);

import 'dart:convert';

RequestOtpResModel requestOtpResModelFromJson(String str) => RequestOtpResModel.fromJson(json.decode(str));

String requestOtpResModelToJson(RequestOtpResModel data) => json.encode(data.toJson());

class RequestOtpResModel {
  final bool success;
  final String message;
  final RequestOtpData? requestOtpData;

  RequestOtpResModel({
   required this.success,
   required this.message,
    this.requestOtpData,
  });

  factory RequestOtpResModel.fromJson(Map<String, dynamic> json) => RequestOtpResModel(
    success: json["success"],
    message: json["message"],
    requestOtpData: json["data"] == null ? null : RequestOtpData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": requestOtpData?.toJson(),
  };
}

class RequestOtpData {
 // final String? otpCode;
  final String? countryCode;
  final String? mobile;
  final String? email;

  RequestOtpData({
   // this.otpCode,
    this.countryCode,
    this.mobile,
    this.email,
  });

  factory RequestOtpData.fromJson(Map<String, dynamic> json) => RequestOtpData(
    //otpCode: json["otpCode"],
    countryCode: json["countryCode"],
    mobile: json["mobile"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
   // "otpCode": otpCode,
    "countryCode": countryCode,
    "mobile": mobile,
    "email": email,
  };
}
