// To parse this JSON data, do
//
//     final cartResModel = cartResModelFromJson(jsonString);

import 'dart:convert';

import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/ingredient.dart';
import 'package:denis_kebap/model/product.dart';

CartResModel cartResModelFromJson(String str) => CartResModel.fromJson(json.decode(str));

String cartResModelToJson(CartResModel data) => json.encode(data.toJson());

class CartResModel {
  final bool success;
  final String message;
  final Cart? cart;

  CartResModel({
    required this.success,
    required this.message,
    this.cart,
  });

  factory CartResModel.fromJson(Map<String, dynamic> json) => CartResModel(
        success: json["success"],
        message: json["message"],
        cart: json["data"] == null || json['data'].isEmpty ? null  :    Cart.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": cart?.toJson(),
      };
}

class Cart {
  final List<CartItem>? cartItems;
  final num? cartTotal;
  final num? cartTax;
  final num? cartGrandTotal;

  Cart({
    this.cartItems,
    this.cartTotal,
    this.cartTax,
    this.cartGrandTotal,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartItems: json["cartItems"] == null
            ? []
            : List<CartItem>.from(
                json["cartItems"]!.map((x) => CartItem.fromJson(x))),
        cartTotal: json["cartTotal"]?.toDouble(),
        cartTax: json["cartTax"]?.toDouble(),
        cartGrandTotal: json["cartGrandTotal"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "cartItems": cartItems == null
            ? []
            : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
        "cartTotal": cartTotal,
        "cartTax": cartTax,
        "cartGrandTotal": cartGrandTotal,
      };
}

class CartItem {
  final String? id;
  final String? user;
  final String? location;
  final Product? product;
  final List<Ingredient>? removedIngredients;
  final List<AddOn>? selectedAddOns;
  final String? removedIngredientNames;
  final String? selectedAddOnNames;
  int? qty;
  final DateTime? time;
  final int? v;
  final double? selectedAddOnsTotal;
  final double? total;

  CartItem({
    this.id,
    this.user,
    this.location,
    this.product,
    this.removedIngredients,
    this.selectedAddOns,
    this.removedIngredientNames,
    this.selectedAddOnNames,
    this.qty,
    this.time,
    this.v,
    this.selectedAddOnsTotal,
    this.total,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["_id"],
        user: json["user"],
        location: json["location"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        removedIngredients:  json["removedIngredients"] == null ? [] : getRemovedIngredients(List<Ingredient>.from(json["removedIngredients"]!.map((x) => Ingredient.fromJson(x)))) ,

    removedIngredientNames: json["removedIngredients"] == null ? null : createIngredientsNamesString(List<Ingredient>.from(json["removedIngredients"]!.map((x) => Ingredient.fromJson(x)))),



        selectedAddOns: json["selectedAddOns"] == null ? [] : getSelectedAddOns(List<AddOn>.from(json["selectedAddOns"]!.map((x) => AddOn.fromJson(x)))),
        selectedAddOnNames: json["selectedAddOns"] == null ? null : createAddOnsNamesString(List<AddOn>.from(json["selectedAddOns"]!.map((x) => AddOn.fromJson(x)))),
        qty: json["qty"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        v: json["__v"],
        selectedAddOnsTotal: json["selectedAddOnsTotal"]?.toDouble(),
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "location": location,
        "product": product?.toJson(),
        "removedIngredients": removedIngredients == null ? [] :List<dynamic>.from(removedIngredients!.map((x) => x.toJson())),
        "selectedAddOns": selectedAddOns == null ? [] : List<dynamic>.from(selectedAddOns!.map((x) => x.toJson())),
        "removedIngredientNames": removedIngredientNames,
        "selectedAddOnNames": selectedAddOnNames,
        "qty": qty,
        "time": time?.toIso8601String(),
        "__v": v,

        "selectedAddOnsTotal": selectedAddOnsTotal,
        "total": total,
      };




  static String? createIngredientsNamesString(List<Ingredient> ingredients) {
    String? result;

    if (ingredients.isNotEmpty) {
      StringBuffer names = StringBuffer();

      for (var element in ingredients) {
        names.write(element.name);
        names.write(', ');
      }
      result = names.toString().substring(0, names.length - 2);
    }
    return result;
  }



  static String? createAddOnsNamesString(List<AddOn> addOns) {
    String? result;

    if (addOns.isNotEmpty) {
      StringBuffer names = StringBuffer();

      for (var element in addOns) {
        names.write(element.name);
        names.write(', ');
      }
      result = names.toString().substring(0, names.length - 2);
    }
    return result;
  }
  
  
  static List<Ingredient> getRemovedIngredients(List<Ingredient> ingredients){
    for (var element in ingredients) {
     element.isChecked = false;
    }
    return ingredients;
  }

  static List<AddOn> getSelectedAddOns(List<AddOn> addOns){
    for (var element in addOns) {
      element.isChecked = true;
    }
    return addOns;
  }

}
