

import 'package:denis_kebap/model/restaurant_locations_res_model.dart';
import 'package:denis_kebap/network/put_requests.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/utils/socket_helper.dart';
import 'package:denis_kebap/view/pages/account/account_screen.dart';
import 'package:denis_kebap/view/pages/cart/cart_screen.dart';
import 'package:denis_kebap/view/pages/home/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController{

  RxInt currentTabPosition = 0.obs;
  Rx<RestaurantLocation?> selectedLocation = Rx<RestaurantLocation?>(null);


  var tabs = <Widget>[
    HomeScreen(),
    CartScreen(),
    const AccountScreen()
  ].obs;


  @override
  void onInit() {
    super.onInit();
    selectedLocation.value = PreferenceManager.restaurantLocation;
  }
  
  @override
  void onReady() {
    super.onReady();
    if(PreferenceManager.userToken != '' ){
      updateFcmToken();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  onTabChange(int position){
    currentTabPosition.value =position;
  }

  void updateFcmToken() async{
    var messaging = FirebaseMessaging.instance;

    String? fcmToken = await messaging.getToken();
    debugPrint("FcmToken = $fcmToken");

    if(fcmToken!=null){
      PreferenceManager.save2Pref(PreferenceManager.prefKeyFcmToken, fcmToken);
      PutRequests.updateFcmToken(fcmToken);

    }
  }

}