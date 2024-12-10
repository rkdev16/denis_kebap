import 'package:denis_kebap/consts/enums.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color kPrimaryColor = Color(0xFF000000);
  static const Color kPrimaryDarkColor = Color(0xFF000000);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color colorTextPrimary = Color(0xFF000000);
  static const Color colorDC = Color(0xFFDCDCDC);
  static  Color colorTextSecondary = Colors.black.withOpacity(0.8);
  static const Color colorE6 = Color(0xFFE6E6E6);
  static const Color color70 = Color(0xFF707070);
  static const Color color13 = Color(0xffD81313);
  static const Color color21 = Color(0xFF212121);


  //order status color




  static Map<OrderStatus,Color> orderStatusBgColor = {

    OrderStatus.cancelled : Colors.red,
    OrderStatus.inQueue : Colors.blueGrey,
    OrderStatus.preparing : Colors.lightGreen,
    OrderStatus.ready : Colors.green,
    OrderStatus.completed : Colors.green,
    OrderStatus.delayed : Colors.orange,
  };

  static Map<OrderStatus,Color> orderStatusTitleColor = {
    OrderStatus.cancelled : Colors.white,
    OrderStatus.inQueue : Colors.white,
    OrderStatus.preparing : Colors.white,
    OrderStatus.ready : Colors.white,
    OrderStatus.completed : Colors.white,
    OrderStatus.delayed : Colors.white,

  };










}
