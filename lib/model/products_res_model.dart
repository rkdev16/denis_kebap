// To parse this JSON data, do
//
//     final productsResModel = productsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:denis_kebap/model/product.dart';

ProductsResModel productsResModelFromJson(String str) => ProductsResModel.fromJson(json.decode(str));

String productsResModelToJson(ProductsResModel data) => json.encode(data.toJson());

class ProductsResModel {
  final bool success;
  final String message;
  final List<Product>? products;

  ProductsResModel({
   required this.success,
   required this.message,
    this.products,
  });

  factory ProductsResModel.fromJson(Map<String, dynamic> json) => ProductsResModel(
    success: json["success"],
    message: json["message"],
    products: json["data"] == null ? [] : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}


