import 'package:denis_kebap/controller/dashboard/dashboard_controller.dart';
import 'package:denis_kebap/controller/home/home_controller.dart';
import 'package:denis_kebap/model/restaurant_locations_res_model.dart';
import 'package:denis_kebap/network/get_requests.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantLocationController extends GetxController {
  RxBool isLoading = true.obs;

  var restaurantLocations = <RestaurantLocation>[].obs;
  Rx<RestaurantLocation?> selectedLocation = Rx<RestaurantLocation?>(null);

  @override
  void onInit() {
    super.onInit();
    selectedLocation.value = PreferenceManager.restaurantLocation;
    getRestaurantLocations();
  }
  @override
  void onReady() {
    super.onReady();

  }

  @override
  void onClose() {
    debugPrint("onCloseRestaurantLocationsController");
    super.onClose();

  }
  getRestaurantLocations() async {
    try {
      if(restaurantLocations.isEmpty)isLoading.value = true;
      var result = await GetRequests.fetchRestaurantLocations();
      if (result != null) {
        if (result.success) {
          restaurantLocations.assignAll(result.data ?? []);

          if(PreferenceManager.restaurantLocation ==null){
            for (var element in restaurantLocations) {
              if(element.isDefault == true){
              selectRestaurantLocation(element);
                return;
              }
            }}else{
           RestaurantLocation location =  restaurantLocations.firstWhere((element) => element.id == PreferenceManager.restaurantLocation?.id);
           PreferenceManager.restaurantLocation = location;
           Get.find<HomeController>().restaurantTagLine.value = location.tagLine;
          }
        }
        else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error');
      }
    } finally {
      isLoading.value = false;
    }
  }


  selectRestaurantLocation(RestaurantLocation location){
    selectedLocation.value = location;
    PreferenceManager.restaurantLocation = location;
    Get.find<HomeController>().restaurantTagLine.value = location.tagLine;
    Get.find<DashboardController>().selectedLocation.value = location;
    Get.find<HomeController>().getCategories();

  }
}
