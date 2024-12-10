// To parse this JSON data, do
//
//     final cartStatusResModel = cartStatusResModelFromJson(jsonString);

import 'dart:convert';

CartStatusResModel cartStatusResModelFromJson(String str) => CartStatusResModel.fromJson(json.decode(str));

String cartStatusResModelToJson(CartStatusResModel data) => json.encode(data.toJson());

class CartStatusResModel {
  final bool success;
  final String message;
  final CartState? cartState;

  CartStatusResModel({
    required this.success,
    required this.message,
    this.cartState,
  });

  factory CartStatusResModel.fromJson(Map<String, dynamic> json) => CartStatusResModel(
    success: json["success"],
    message: json["message"],
    cartState: json["data"] == null ? null : CartState.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": cartState?.toJson(),
  };
}

class CartState {
  final bool? isEmpty;

  CartState({
    this.isEmpty,
  });

  factory CartState.fromJson(Map<String, dynamic> json) => CartState(
    isEmpty: json["isEmpty"],
  );

  Map<String, dynamic> toJson() => {
    "isEmpty": isEmpty,
  };
}
