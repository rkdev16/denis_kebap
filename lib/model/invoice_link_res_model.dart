// To parse this JSON data, do
//
//     final invoiceLinkResModel = invoiceLinkResModelFromJson(jsonString);

import 'dart:convert';

InvoiceLinkResModel invoiceLinkResModelFromJson(String str) => InvoiceLinkResModel.fromJson(json.decode(str));

String invoiceLinkResModelToJson(InvoiceLinkResModel data) => json.encode(data.toJson());

class InvoiceLinkResModel {
  final bool success;
  final String message;
  final InvoiceLinkData? invoiceLinkData;

  InvoiceLinkResModel({
   required this.success,
   required this.message,
    this.invoiceLinkData,
  });

  factory InvoiceLinkResModel.fromJson(Map<String, dynamic> json) => InvoiceLinkResModel(
    success: json["success"],
    message: json["message"],
    invoiceLinkData: json["data"] == null ? null : InvoiceLinkData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": invoiceLinkData?.toJson(),
  };
}

class InvoiceLinkData {
  final String? invoiceUrl;

  InvoiceLinkData({
    this.invoiceUrl,
  });

  factory InvoiceLinkData.fromJson(Map<String, dynamic> json) => InvoiceLinkData(
    invoiceUrl: json["invoiceUrl"],
  );

  Map<String, dynamic> toJson() => {
    "invoiceUrl": invoiceUrl,
  };
}
