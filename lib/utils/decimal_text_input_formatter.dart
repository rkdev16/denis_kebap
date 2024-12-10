
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {


    debugPrint("newValue = ${newValue.text}");
    debugPrint("oldValue = ${oldValue.text}");

  //  final regExp= RegExp(r'^\d*\.?\d{0,3}');
    final regExp= RegExp(r'^(\d+)?\.?\d{0,3}');
    final String newString = regExp.stringMatch(newValue.text.replaceAll(',', ''))??'';
    return newString == newValue.text.replaceAll(',', '') ? newValue : oldValue;


  }
  
}