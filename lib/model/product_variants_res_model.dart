// To parse this JSON data, do
//
//     final productVariantsResModel = productVariantsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:denis_kebap/model/product.dart';

ProductVariantsResModel productVariantsResModelFromJson(String str) => ProductVariantsResModel.fromJson(json.decode(str));

String productVariantsResModelToJson(ProductVariantsResModel data) => json.encode(data.toJson());

class ProductVariantsResModel {
  final bool success;
  final String message;
  final Product? product;

  ProductVariantsResModel({
   required this.success,
   required this.message,
    this.product,
  });

  factory ProductVariantsResModel.fromJson(Map<String, dynamic> json) => ProductVariantsResModel(
    success: json["success"],
    message: json["message"],
    product: json["data"] == null ? null : Product.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": product?.toJson(),
  };
}

