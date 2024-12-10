import 'dart:async';
import 'dart:io';

import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/order/orders_res_model.dart';
import 'package:denis_kebap/network/get_requests.dart';
import 'package:denis_kebap/network/put_requests.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/download_service.dart';
import 'package:denis_kebap/utils/pdf_viewer.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/utils/socket_helper.dart';
import 'package:denis_kebap/view/dialogs/common/common_alert_dialog.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersController extends GetxController {
  RxBool isLoading = false.obs;

  final Duration _timerDuration = const Duration(seconds: 20);

  var orders = <Order>[].obs;
  Rx<DateTime> orderDate = Rx<DateTime>(DateTime.now());

  DateTime storeCurrentTime = DateTime.now();
  IO.Socket? _socket;

  Timer? timer;

  final _downloadService = DownloadService();

  @override
  void onInit() {
    super.onInit();
    if (PreferenceManager.userToken != '') {
      debugPrint("IntiOrderController");

      _downloadService.init();
      _socket = SocketHelper.getInstance();

      _socket?.on('orderReload', (data) {
        try {
          debugPrint("DataInSocket = $data");
          var locationId = data['data']['location'];
          debugPrint("location_id = $locationId");
          if (locationId == PreferenceManager.restaurantLocation?.id) {
            getOrders();
          }
        } on Exception catch (e) {
          debugPrint("OrderReloadException: $e");
        }
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _downloadService.dispose();
    super.onClose();
  }

  Future getOrders() async {
    try {
      isLoading.value = true;
      var result = await GetRequests.fetchOrders(
          PreferenceManager.restaurantLocation?.id ?? "",
          orderDate.value.millisecondsSinceEpoch / 1000);
      if (result != null) {
        if (result.success) {
          storeCurrentTime = createStoreCurrentDateTime(
              result.orderData?.today, result.orderData?.currentTime);
          orders.assignAll(result.orderData?.orders ?? []);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  DateTime createStoreCurrentDateTime(
      DateTime? storeCurrentDate, String? storeCurrentTime) {
    DateTime result = DateTime.now();

    if (storeCurrentDate != null && storeCurrentTime != null) {
      var timeComponentArr = storeCurrentTime.split(':');
      var hour = timeComponentArr.isNotEmpty
          ? int.parse(timeComponentArr[0])
          : DateTime.now().hour;
      var min = timeComponentArr.length > 1
          ? int.parse(timeComponentArr[1])
          : DateTime.now().minute;
      var sec = timeComponentArr.length > 2
          ? int.parse(timeComponentArr[2])
          : DateTime.now().second;

      result = DateTime(storeCurrentDate.year, storeCurrentDate.month,
          storeCurrentDate.day, hour, min, sec);
    }

    return result;
  }

  cancelOrder(String? orderId) async {
    try {
      isLoading.value = true;
      var result = await PutRequests.cancelOrder(orderId);
      if (result != null) {
        if (result.success) {
          getOrders();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  String? getOrderStatusTitle(OrderStatus? orderStatus) {
    String? result;
    switch (orderStatus) {
      case OrderStatus.ready:
        result = 'completed'.tr;
        break;
      case OrderStatus.inQueue:
        result = 'preparing'.tr;
        break;
      case OrderStatus.cancelled:
        result = 'cancelled'.tr;
        break;
      default:
    }
    return result;
  }

  showCancelOrderConfirmationAlert(String? orderId) {
    CommonAlertDialog.showDialog(
        message: 'message_confirm_cancel_order'.tr,
        positiveText: 'no'.tr,
        negativeText: 'yes'.tr,
        negativeBtCallback: () {
          Get.back();
          cancelOrder(orderId);
        },
        positiveBtCallback: () => {Get.back()});
  }

  initTimer(VoidCallback onRefresh) {
    cancelTimer();

    timer = Timer.periodic(_timerDuration, (timer) {
      onRefresh();
      storeCurrentTime = storeCurrentTime.add(_timerDuration);
      printTime(storeCurrentTime);
    });
  }

  cancelTimer() {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
      timer = null;
    }
  }

  printTime(DateTime dateTime) {
    debugPrint('Time = ${DateFormat('hh:mm:ss').format(dateTime)}');
  }

  Map<ButtonAttrType, dynamic> getButtonAttr(Order order) {
    debugPrint(
        "Difference = ${storeCurrentTime.difference(order.pickupTime ?? DateTime.now()).inMinutes}");
    debugPrint("PickupTime = ${order.pickupTime ?? DateTime.now()}");
    debugPrint("StoreTime = $storeCurrentTime");

    Map<ButtonAttrType, dynamic> result = {};
    switch (order.status) {
      case OrderStatus.inQueue:
        if (order.pickupTime!.difference(storeCurrentTime).inMinutes > 15) {
          result = {
            ButtonAttrType.title: 'cancel'.tr,
            ButtonAttrType.backgroundColor:
                AppColors.orderStatusBgColor[OrderStatus.cancelled],
            ButtonAttrType.titleColor:
                AppColors.orderStatusTitleColor[OrderStatus.cancelled],
            ButtonAttrType.clickEvent: () {
              showCancelOrderConfirmationAlert(order.id);
            },
          };
        } else if (storeCurrentTime.isAfter(order.preparationStartTime!) &&
            storeCurrentTime.difference(order.pickupTime!).inMinutes <= 2) {
          result = {
            ButtonAttrType.title: 'preparing'.tr,
            ButtonAttrType.backgroundColor:
                AppColors.orderStatusBgColor[OrderStatus.preparing],
            ButtonAttrType.titleColor:
                AppColors.orderStatusTitleColor[OrderStatus.preparing],
            ButtonAttrType.clickEvent: () {},
          };
        }
        // else if (storeCurrentTime.difference(order.pickupTime!).inMinutes >=
        //         0 &&
        //     storeCurrentTime.difference(order.pickupTime!).inMinutes <= 2) {
        //   result = {
        //     ButtonAttrType.title: 'ready'.tr,
        //     ButtonAttrType.backgroundColor:
        //         AppColors.orderStatusBgColor[OrderStatus.ready],
        //     ButtonAttrType.titleColor:
        //         AppColors.orderStatusTitleColor[OrderStatus.ready],
        //     ButtonAttrType.clickEvent: () {},
        //   };
        // }
        else if (storeCurrentTime.difference(order.pickupTime!).inMinutes > 2) {
          result = {
            ButtonAttrType.title: 'preparing'.tr,
            ButtonAttrType.backgroundColor:
                AppColors.orderStatusBgColor[OrderStatus.preparing],
            ButtonAttrType.titleColor:
                AppColors.orderStatusTitleColor[OrderStatus.preparing],
            ButtonAttrType.clickEvent: () {},

            //todo delayed feature removed by client
            // ButtonAttrType.title: 'delayed'.tr,
            // ButtonAttrType.backgroundColor:
            // AppColors.orderStatusBgColor[OrderStatus.delayed],
            // ButtonAttrType.titleColor:
            // AppColors.orderStatusTitleColor[OrderStatus.delayed],
            // ButtonAttrType.clickEvent: () {},
          };
        } else {
          result = {
            ButtonAttrType.title: 'in_queue'.tr,
            ButtonAttrType.backgroundColor:
                AppColors.orderStatusBgColor[OrderStatus.inQueue],
            ButtonAttrType.titleColor:
                AppColors.orderStatusTitleColor[OrderStatus.inQueue],
            ButtonAttrType.clickEvent: () {},
          };
        }

        break;

      case OrderStatus.ready:
        result = {
          ButtonAttrType.title: 'ready_for_pickup'.tr,
          ButtonAttrType.backgroundColor:
              AppColors.orderStatusBgColor[OrderStatus.ready],
          ButtonAttrType.titleColor:
              AppColors.orderStatusTitleColor[OrderStatus.ready],
          ButtonAttrType.clickEvent: () {},
        };
        break;

      case OrderStatus.completed:
        result = {
          ButtonAttrType.title: 'completed'.tr,
          ButtonAttrType.backgroundColor:
              AppColors.orderStatusBgColor[OrderStatus.ready],
          ButtonAttrType.titleColor:
              AppColors.orderStatusTitleColor[OrderStatus.ready],
          ButtonAttrType.clickEvent: () {},
        };
        break;

      case OrderStatus.cancelled:
        result = {
          ButtonAttrType.title: 'cancelled'.tr,
          ButtonAttrType.backgroundColor:
              AppColors.orderStatusBgColor[OrderStatus.cancelled],
          ButtonAttrType.titleColor:
              AppColors.orderStatusTitleColor[OrderStatus.cancelled],
          ButtonAttrType.clickEvent: () {},
        };

        break;

      default:
    }

    return result;
  }

  selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: orderDate.value,
        firstDate: PreferenceManager.user?.time ?? DateTime.now(),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black, // <-- SEE HERE
                onPrimary: Colors.white, // <-- SEE HERE
                onSurface: Colors.black, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });

    if (selectedDate != null && selectedDate != orderDate.value) {
      orderDate.value = selectedDate;
      getOrders();
    }
  }

  Future<void> pay(Order order) async {
    // await  getPaymentLink(orderId: orderId);

    // CommonAlertDialog.showDialog(
    //     title: 'tip'.tr,
    //     message: 'message_want_to_add_tip'.tr,
    //     positiveText: 'yes'.tr,
    //     negativeText: 'no'.tr,
    //     positiveBtCallback: (){
    //       Get.back();
    //       showAddTipInputDialog(orderId);
    //       },
    //   negativeBtCallback: (){
    //     Get.back();
    //     debugPrint("negative");
    //     getPaymentLink(orderId: orderId);
    //   }
    // );
  }

  showAddTipInputDialog(String? orderId) {
    // AddTipInputDialog.show(onTipAdded: (String? tip){
    //   if(tip ==null || tip.isEmpty) return;
    //   getPaymentLink(orderId: orderId,tip: tip);
    // });
  }

  Future<void> getPaymentLink(
      {required String? orderId, required num tip}) async {
    if (orderId == null || orderId.isEmail) {
      return;
    }
    try {
      final result = await GetRequests.getPaymentLink(orderId, tip);
      if (result != null) {
        if (result.success) {
          final isPaymentSuccess =
              await Get.toNamed(AppRoutes.routePaymentFormScreen, arguments: {
            AppConsts.keyPaymentLinkData: result.paymentLinkData
          });
          debugPrint("isPaymentSuccess = $isPaymentSuccess");
          if (isPaymentSuccess) {
            getOrders();
          }
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {}
  }

  Future<void> getInvoiceLink(String? orderId) async {
    if (orderId == null) return;

    try {
      // isLoadingDownloadInvoice.value= true;
      final result = await GetRequests.getInvoiceLink(orderId);
      if (result != null) {
        if (result.success) {
          final link = result.invoiceLinkData?.invoiceUrl;
          if (link != null && link.isNotEmpty) {
            try {
              Get.to(() => PdfViewer(url: link),
                  transition: Transition.downToUp, curve: Curves.ease);
              // launchUrl(Uri.parse(link));
              //  _downloadService.downloadLink(link);
              //  downloadFileFromLink(link);
            } on Exception catch (e) {
              debugPrint("Exception Launching Url = $e");
            }
          }
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      // isLoadingDownloadInvoice.value= false;
    }
  }
}

downloadFileFromLink(String? link) async {
  if (link == null) return;

  try {
    final externalDir = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    final externalDirPath = externalDir?.absolute.path;
    //ensure the directory exist
    if (externalDir != null) {
      String saveDir = externalDirPath ?? '';
      Directory(saveDir).createSync(recursive: true);

      final taskId = await FlutterDownloader.enqueue(
        url: link,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: saveDir,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );

      Get.closeAllSnackbars();
      Get.snackbar('Download completed', '',
          backgroundColor: Colors.black12,
          mainButton: TextButton(
              onPressed: () async {
                // await OpenFi.open('${(await getApplicationDocumentsDirectory()).path}/$taskId.pdf');
              },
              child: Text("Open")));
    } else {
      debugPrint("External storage directory is null");
    }
  } catch (e) {
    debugPrint("Error downloading file: $e");
  }
}
