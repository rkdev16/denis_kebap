
import 'package:denis_kebap/controller/account/account_controller.dart';
import 'package:denis_kebap/controller/dashboard/dashboard_controller.dart';
import 'package:denis_kebap/controller/home/home_controller.dart';
import 'package:denis_kebap/controller/order/orders_controller.dart';
import 'package:denis_kebap/controller/restaurant_locations/restaurant_locations_controller.dart';
import 'package:denis_kebap/controller/search/search_controller.dart';
import 'package:get/get.dart';

import '../controller/cart/cart_controller.dart';

class DashboardBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => DashboardController());
   Get.lazyPut(() => HomeController());
   Get.lazyPut(() => SearchScreenController());
   Get.lazyPut(() => CartController(),fenix: true);
   Get.lazyPut(() => AccountController());
   Get.lazyPut(() => OrdersController());
   Get.lazyPut(() => RestaurantLocationController());
  }

}