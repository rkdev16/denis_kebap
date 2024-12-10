
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController{

  final TextEditingController searchTextController = TextEditingController();
  RxList searchHistory = [
    "kebab".tr,
    "kebab_small".tr,
    "veggie_kebab".tr,
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}