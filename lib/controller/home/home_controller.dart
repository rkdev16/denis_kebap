import 'package:denis_kebap/controller/cart/cart_controller.dart';
import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/categories_res_model.dart';
import 'package:denis_kebap/model/ingredient.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/preference_manager.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/restaurant_locations_res_model.dart';
import '../../network/get_requests.dart';
import '../../utils/app_alerts.dart';

import '../restaurant_locations/restaurant_locations_controller.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  RestaurantLocationController? restaurantLocationController;
  RxBool isLoading = false.obs;
  RxInt selectTab = 0.obs;

  RxBool isLoadingCategories = false.obs;
  var restaurantLocations = <RestaurantLocation>[].obs;
  String? categoryId;

  var categories = <Category>[].obs;

  Rx<String?> restaurantTagLine = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    tabController.addListener(() {
      selectTab.value  =tabController.index;
    });
  }

  @override
  void onReady() {
    super.onReady();
    getHomeData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  onTab(int index) {
    tabController.index = index;
  }


  getHomeData() {
    if (PreferenceManager.restaurantLocation == null) {
      Get.toNamed(AppRoutes.routeRestaurantLocationsScreen);
    } else {
      getCategories();
    }
  }

  getCategories() async {
    try {
      isLoading.value = true;
      var result = await GetRequests.fetchCategories(
          PreferenceManager.restaurantLocation?.id ?? ""
      );
      if (result != null) {
        if (result.success) {
          categories.assignAll(result.data ?? []);
          tabController = TabController(length: categories.length, vsync: this);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error');
      }
    } finally {
      isLoading.value = false;
    }
  }


  Future<List<Product>> getProducts(String categoryId) async {
    var result = await GetRequests.fetchProducts(categoryId);
    var products = <Product>[];

    if (result != null) {
      if (result.success) {
        products = result.products ?? [];
      } else {
        AppAlerts.error(message: result.message);
      }
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
    }


    return products;
  }


  addToCart(Product product,int qty) async{

    List<Ingredient> removedIngredients = product.ingredients.where((element) => element.isChecked == false).toList();
    List<AddOn> selectedAddons = product.addOns.where((element) => element.isChecked == true).toList();


    var result = await Get.find<CartController>().addItemToCart(
        productId: product.id,
        removedIngredients: List.generate(removedIngredients.length, (index) => removedIngredients[index].id),
        selectedAddons: List.generate(selectedAddons.length, (index) => selectedAddons[index].id),
        quantity: qty);


  }
}