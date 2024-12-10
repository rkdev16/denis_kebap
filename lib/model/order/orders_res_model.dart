// To parse this JSON data, do
//
//     final ordersResModel = ordersResModelFromJson(jsonString);

import 'dart:convert';

import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/cart_res_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

OrdersResModel ordersResModelFromJson(String str) =>
    OrdersResModel.fromJson(json.decode(str));

String ordersResModelToJson(OrdersResModel data) => json.encode(data.toJson());

class OrdersResModel {
  final bool success;
  final String message;
  final OrderData? orderData;

  OrdersResModel({
    required this.success,
    required this.message,
    this.orderData,
  });

  factory OrdersResModel.fromJson(Map<String, dynamic> json) => OrdersResModel(
        success: json["success"],
        message: json["message"],
        orderData:
            json["data"] == null ? null : OrderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": orderData?.toJson(),
      };
}

class OrderData {
  final String? currentDate;
  final String? currentTime;
  final DateTime? today;
  final List<Order>? orders;

  OrderData({
    this.currentDate,
    this.currentTime,
    this.today,
    this.orders,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        currentDate: json["currentDate"],
        currentTime: json["currentTime"],
        today: json["today"] == null ? null : DateTime.parse(json["today"]),
        orders: json["orderList"] == null
            ? []
            : List<Order>.from(
                json["orderList"]!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currentDate": currentDate,
        "currentTime": currentTime,
        "today": today?.toIso8601String(),
        "orderList": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

var orderStatusValues = EnumValues<OrderStatus>({
  'IN_QUE': OrderStatus.inQueue,
  'READY': OrderStatus.ready,
  'COMPLETED': OrderStatus.completed,
  'CANCELED': OrderStatus.cancelled
});

class Order {
  final String? id;
  final String? user;
  final String? location;
  final Cart? cart;
  final DateTime? pickupTime;
  final DateTime? preparationStartTime;
  final int? preparationTime;
  final DateTime? orderDate;
  final OrderStatus? status;
  final String? type;
  final DateTime? time;
  final int? v;
  final DateTime? orderDateTime;
  final String? orderItemNames;
  final String? invoiceId;


  Order(
      {this.id,
      this.user,
      this.location,
      this.cart,
      this.pickupTime,
      this.preparationStartTime,
      this.preparationTime,
      this.orderDate,
      this.status,
      this.type,
      this.time,
      this.v,
      this.orderDateTime,
      this.orderItemNames,
        this.invoiceId,

      });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json["_id"],
      user: json["user"],
      location: json["location"],
      cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
      pickupTime: getPickupTime(json["pickupTime"]),
      preparationStartTime: getPrepStartTime(
          getPickupTime(json["pickupTime"]), json["preprationTime"]),
      preparationTime: json["preprationTime"],
      orderDate:
          json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
      status: orderStatusValues.map[json["status"]],
      type: json["type"],

      time: json["time"] == null ? null : DateTime.parse(json["time"]),
      v: json["__v"],
      orderDateTime: createOrderDateTime(
          json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
          json["pickupTime"]),
      orderItemNames: createOrderItemNames(Cart.fromJson(json["cart"]).cartItems ?? []),
    invoiceId: json["invoiceId"],
  );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "location": location,
        "cart": cart?.toJson(),
        // "pickupTime": pickupTime?.toIso8601String(),
        "preprationTime": preparationTime,
        "preparationStartTime": preparationStartTime?.toIso8601String(),
        "orderDate": orderDate?.toIso8601String(),
        "status": orderStatusValues.reverse[status],
        "type": type,
        "time": time?.toIso8601String(),
        "orderDateTime": orderDateTime?.toIso8601String(),
        "__v": v,
        "invoiceId": invoiceId,
      };
}

DateTime? createOrderDateTime(DateTime? orderDate, String? time) {
  DateTime? result;

  try {
    if (orderDate != null && time != null) {
      var timeSplitArr = time.split(':');
      if (timeSplitArr.isNotEmpty && timeSplitArr.length >= 2) {
        result = DateTime(orderDate.year, orderDate.month, orderDate.day,
            int.parse(timeSplitArr.first), int.parse(timeSplitArr.last));
      }
    }
  } on Exception catch (e) {
    debugPrint("Exception on combining Order datetime = $e");
  }
  return result;
}

String? createOrderItemNames(List<CartItem> cartItems) {
  StringBuffer result = StringBuffer();

  for (var element in cartItems) {
    if (element.product?.name != null) {
      result.write(element.product?.name ?? '');
      result.write(',');
    }
  }
  return result.isEmpty
      ? null
      : result.toString().substring(0, result.length - 1);
}

DateTime? getPickupTime(String? timeString) {
  DateTime? result;
  debugPrint("timeString= $timeString");
  if (timeString != null) {
    TimeOfDay time = TimeOfDay(
        hour: int.parse(timeString.split(':').first),
        minute: int.parse(timeString.split(':').last));
    DateTime now = DateTime.now();
    result = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
  return result;
}

DateTime? getPrepStartTime(DateTime? pickupTime, int? totalPrepMin) {
  DateTime? result;
  if (pickupTime != null && totalPrepMin != null) {
    result = pickupTime.subtract(Duration(minutes: totalPrepMin));
  }
  return result;
}
