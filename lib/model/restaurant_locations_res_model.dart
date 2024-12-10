// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

Temperatures temperaturesFromJson(String str) => Temperatures.fromJson(json.decode(str));

String temperaturesToJson(Temperatures data) => json.encode(data.toJson());

class Temperatures {
  final bool success;
  final String message;
  final List<RestaurantLocation>? data;

  Temperatures({
   required this.success,
   required this.message,
    this.data,
  });

  factory Temperatures.fromJson(Map<String, dynamic> json) => Temperatures(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<RestaurantLocation>.from(json["data"]!.map((x) => RestaurantLocation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class RestaurantLocation {
  final String? id;
  final String? name;
  final String? address;
  final String? tagLine;
  final bool? isDefault;

  RestaurantLocation({
    this.id,
    this.name,
    this.address,
    this.tagLine,
    this.isDefault,
  });

  factory RestaurantLocation.fromJson(Map<String, dynamic> json) => RestaurantLocation(
    id: json["_id"],
    name: json["name"],
    address: json["address"],
    tagLine: json["tagLine"],
    isDefault: json["isDefault"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "address": address,
    "tagLine": tagLine,
    "isDefault": isDefault,
  };
}
