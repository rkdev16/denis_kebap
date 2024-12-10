// To parse this JSON data, do
//
//     final categoriesResModel = categoriesResModelFromJson(jsonString);

import 'dart:convert';

CategoriesResModel categoriesResModelFromJson(String str) => CategoriesResModel.fromJson(json.decode(str));

String categoriesResModelToJson(CategoriesResModel data) => json.encode(data.toJson());

class CategoriesResModel {
  final bool success;
  final String message;
  final List<Category>? data;

  CategoriesResModel({
    required this.success,
    required this.message,
     this.data,
  });

  factory CategoriesResModel.fromJson(Map<String, dynamic> json) => CategoriesResModel(
    success: json["success"],
    message: json["message"],
    data: List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data":  List<Category>.from(data!.map((x) => x.toJson())),
  };
}

class Category {
  final String id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "image": image,
  };
}


