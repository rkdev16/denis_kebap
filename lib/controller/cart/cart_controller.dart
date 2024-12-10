import 'dart:async';

import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/cart_res_model.dart';
import 'package:denis_kebap/model/time_slots_res_model.dart';
import 'package:denis_kebap/network/get_requests.dart';
import 'package:denis_kebap/network/post_requests.dart';
import 'package:denis_kebap/network/put_requests.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/dialogs/common/common_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  // final formKey = GlobalKey<FormState>();
  final TextEditingController tipTextController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isLoadingAddToCart = false.obs;

  RxBool isCartEmpty = true.obs;

  RxBool isLoadingTimeSlots = false.obs;
  RxBool isLoadingPlaceOrder = false.obs;
  RxDouble progressCurrentValue = 0.0.obs;
  var counter = RxInt(0);

  //final selectedTipType = Rx<TipType>(TipType.noTip);
  // final autoCalculatedTip = Rx<double>(0.0);

  Rx<Cart?> cart = Rx<Cart?>(null);
  List<CartItem> cartItems = <CartItem>[].obs;

  var timeSlots = <TimeSlot>[].obs;
  Timer? _timer;
  RxBool showProgressAnimation = false.obs;
  Rx<TimeSlot?> selectedTimeSlot = Rx<TimeSlot?>(null);

  @override
  void onInit() {
    super.onInit();
    if (PreferenceManager.userToken != '') {
      getCartState();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> addItemToCart({
    required String productId,
    required List<String> removedIngredients,
    required List<String> selectedAddons,
    required int quantity,
  }) async {
    try {
      isLoadingAddToCart.value = true;
      Map<String, dynamic> requestBody = {
        "location": PreferenceManager.restaurantLocation?.id,
        "product": productId,
        "removedIngredients": removedIngredients,
        "selectedAddOns": selectedAddons,
        "qty": quantity
      };

      debugPrint("Add_product_req_body = $requestBody");

      var result = await PostRequests.addProductToCart(requestBody);
      if (result != null) {
        if (result.success) {
          isCartEmpty.value = false;
          AppAlerts.custom(title: '', message: result.message);
          return true;
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoadingAddToCart.value = false;
    }
//default case
    return false;
  }

  Future<bool> editCartItem({
    required String cartItemId,
    required List<String> removedIngredients,
    required List<String> selectedAddons,
    required int quantity,
  }) async {
    try {
      isLoadingAddToCart.value = true;
      Map<String, dynamic> requestBody = {
        "removedIngredients": removedIngredients,
        "selectedAddOns": selectedAddons,
        "qty": quantity
      };

      debugPrint("Edit_product_req_body = $requestBody");

      var result = await PutRequests.editProductInCart(cartItemId, requestBody);
      if (result != null) {
        if (result.success) {
          AppAlerts.custom(title: '', message: result.message);
          return true;
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoadingAddToCart.value = false;
    }
//default case
    return false;
  }

  Future<bool> decQtyProductList(String productId) async {
    try {
      isLoading.value = true;
      var result = await GetRequests.decQtyProductList(productId);
      if (result != null) {
        if (result.success) {
          getCartState();
          return true;
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error');
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> changeQtyCart(
      {required String? cartItemId,
      required QtyChangeType qtyChangeType}) async {
    try {
      isLoading.value = true;

      var result;

      if (qtyChangeType == QtyChangeType.increase) {
        result = await GetRequests.incQtyCart(cartItemId);
      } else {
        result = await GetRequests.decQtyCart(cartItemId ?? '');
      }

      if (result != null) {
        if (result.success) {
          getCartState();
          return true;
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error');
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> cartBulkUpdate(Map<String, dynamic> requestBody) async {
    try {
      isLoading.value = true;
      var result = await PostRequests.cartBulkUpdate(requestBody);
      if (result != null) {
        if (result.success) {
          getCartState();
          return true;
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error');
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> getCart() async {
    debugPrint("getCart ==");
    try {
      isLoading.value = true;
      var result = await GetRequests.fetchCart(
          PreferenceManager.restaurantLocation?.id ?? '');
      debugPrint("getCart = $result");
      if (result != null) {
        if (result.success) {
          cart.value = result.cart;
          //  autoCalculatedTip.value = calculateTip((result.cart?.cartGrandTotal??0).toDouble());
          //  debugPrint("CalculatedTip: ${autoCalculatedTip.value}");
          cartItems.assignAll(result.cart?.cartItems ?? []);
          isCartEmpty.value = cartItems.isEmpty;
          selectedTimeSlot.value = null;
        } else {
          cart.value = null;
          cartItems.assignAll([]);
          isCartEmpty.value = cartItems.isEmpty;
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  getTimeSlots() async {
    try {
      isLoadingTimeSlots.value = true;
      var result = await GetRequests.fetchTimeSlots(
          PreferenceManager.restaurantLocation?.id ?? '');
      if (result != null) {
        if (result.success) {
          timeSlots.assignAll(result.timeSlots ?? []);
        }
      }
    } finally {
      isLoadingTimeSlots.value = false;
    }
  }

  getCartState() async {
    try {
      String? locationId = PreferenceManager.restaurantLocation?.id;
      if (locationId == null || locationId.isEmpty) return;
      var result = await GetRequests.fetchCartState(locationId);
      if (result != null) {
        if (result.success) {
          isCartEmpty.value = result.cartState?.isEmpty ?? true;
        }
      }
    } on Exception catch (e) {
      debugPrint("CheckCartStatusException = $e");
    }
  }

  double calculateTip(double totalAmount) {
    if (totalAmount == 0) return 0;
    final ceilTotalAmount = totalAmount.ceil();
    return double.parse((ceilTotalAmount - totalAmount).toStringAsFixed(2));
  }

  showPreOrderConfirmationAlert() {
    CommonAlertDialog.showDialog(
      title: 'confirm_order'.tr,
      // message: 'message_pre_order_confirmation'.tr,
      message: '',
      positiveText: 'yes'.tr,
      negativeText: 'no'.tr,
      positiveBtCallback: () {
        Get.back();
        placeOrder();
      },
      negativeBtCallback: () {
        Get.back();
      },
    );
  }

  placeOrder() async {
    try {
      isLoadingPlaceOrder.value = true;
      Map<String, dynamic> requestBody = {
        'time': selectedTimeSlot.value?.time,

        // 'tip': selectedTipType.value == TipType.autoCalculated
        //     ? autoCalculatedTip.value
        //     : selectedTipType.value == TipType.userDefined ?
        // tipTextController.text.toString().trim().replaceAll(',',''): 0
      };

      debugPrint("RequestBody: $requestBody");

      var result = await PostRequests.placeOrder(
          PreferenceManager.restaurantLocation?.id ?? '', requestBody);
      if (result != null) {
        if (result.success) {
          startProgress();
        } else {
          AppAlerts.error(message: result.message);
        }
      }
    } finally {
      isLoadingPlaceOrder.value = false;
    }
  }

  selectTimeSlot(int selectedIndex) {
    for (int i = 0; i < timeSlots.length; i++) {
      timeSlots[i].isSelected = i == selectedIndex;
    }
    timeSlots.refresh();
  }

  startProgress() {
    stopProgress();
    progressCurrentValue.value = 0;
    showProgressAnimation.value = true;
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      var currentValue = progressCurrentValue.value;
      if (currentValue >= 100) {
        stopProgress();
        getCartState();
        Get.toNamed(AppRoutes.routeOrderConfirmationScreen);
      } else {
        progressCurrentValue.value = progressCurrentValue.value + 10.0;
      }
    });
  }

  stopProgress() {
    showProgressAnimation.value = false;
    _timer?.cancel();
    _timer = null;
  }
}
