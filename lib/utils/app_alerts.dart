

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppAlerts{


  AppAlerts._();

 static success({required String message}){
    Get.closeAllSnackbars();
    Get.snackbar(
      'success'.tr,
        message,backgroundColor: Colors.black12,
    );
  }

  static error({required String message}){
    Get.closeAllSnackbars();
    Get.snackbar('error'.tr,
        message,backgroundColor: Colors.black12);
  }

  static alert({required String message}){
    Get.closeAllSnackbars();
    Get.snackbar('alert'.tr,
        message,backgroundColor: Colors.black12,);
  }

 static custom({required String title,required String message}){
    Get.closeAllSnackbars();
    Get.snackbar(title.tr, message,backgroundColor: Colors.black12);
  }
}