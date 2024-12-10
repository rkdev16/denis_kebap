// To parse this JSON data, do
//
//     final paymentLinkResModel = paymentLinkResModelFromJson(jsonString);

import 'dart:convert';

PaymentLinkResModel paymentLinkResModelFromJson(String str) => PaymentLinkResModel.fromJson(json.decode(str));

String paymentLinkResModelToJson(PaymentLinkResModel data) => json.encode(data.toJson());

class PaymentLinkResModel {
  final bool success;
  final String message;
  final PaymentLinkData? paymentLinkData;

  PaymentLinkResModel({
   required this.success,
   required this.message,
    this.paymentLinkData,
  });

  factory PaymentLinkResModel.fromJson(Map<String, dynamic> json) => PaymentLinkResModel(
    success: json["success"],
    message: json["message"],
    paymentLinkData: json["data"] == null ? null : PaymentLinkData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": paymentLinkData?.toJson(),
  };
}

class PaymentLinkData {
  final String? checkoutUrl;
  final PaymentIntent? paymentIntent;

  PaymentLinkData({
    this.checkoutUrl,
    this.paymentIntent,
  });

  factory PaymentLinkData.fromJson(Map<String, dynamic> json) => PaymentLinkData(
    checkoutUrl: json["checkoutUrl"],
    paymentIntent: json["paymentIntent"] == null ? null : PaymentIntent.fromJson(json["paymentIntent"]),
  );

  Map<String, dynamic> toJson() => {
    "checkoutUrl": checkoutUrl,
    "paymentIntent": paymentIntent?.toJson(),
  };
}

class PaymentIntent {
  final String? id;
  final String? user;
  final String? order;
  final String? status;
  final DateTime? time;
  final int? v;
  final String? checkoutId;

  PaymentIntent({
    this.id,
    this.user,
    this.order,
    this.status,
    this.time,
    this.v,
    this.checkoutId,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) => PaymentIntent(
    id: json["_id"],
    user: json["user"],
    order: json["order"],
    status: json["status"],
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    v: json["__v"],
    checkoutId: json["checkoutId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "order": order,
    "status": status,
    "time": time?.toIso8601String(),
    "__v": v,
    "checkoutId": checkoutId,
  };
}
