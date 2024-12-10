import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/controller/order/orders_controller.dart';
import 'package:denis_kebap/model/order/orders_res_model.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/view/bottom_sheets/tip_bottom_sheet.dart';
import 'package:denis_kebap/view/dialogs/common/add_tip_input_dialog.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderListTile extends StatelessWidget {
  OrderListTile({
    super.key,
    required this.order,
    required this.orderType,
    this.onTap,
  });

  final Order order;
  final OrderType orderType;
  final VoidCallback? onTap;

  final isLoadingDownloadInvoice = false.obs;
  final isLoadingGetPaymentLink = false.obs;

  final _orderController = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   order.orderItemNames ?? "",
                      //   style: Theme
                      //       .of(context)
                      //       .textTheme
                      //       .headlineSmall
                      //       ?.copyWith(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 14.fontMultiplier,
                      //       color: Colors.black),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'pickup_time'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.black,
                                          fontSize: 10.fontMultiplier,
                                          fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  // orderType == OrderType.current
                                  //  ?
                                  DateFormat("HH:mm").format(
                                      order.pickupTime ?? DateTime.now()),
                                  // : DateFormat("HH:mm").format(order.orderDateTime ?? DateTime.now()),

                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontSize: 18.fontMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.black,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                            ),
                            Column(
                              children: [
                                Text(
                                  'total_price'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.black,
                                          fontSize: 10.fontMultiplier,
                                          fontWeight: FontWeight.w400),
                                ),

                                Row(
                                  children:[
                                    Text(
                                '€ ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                          fontSize: 18.fontMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      Helpers.formatPrice(
                                          order.cart?.cartGrandTotal),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                          fontSize: 18.fontMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ]
                                ),

                                /*RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '€ ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.fontMultiplier),
                                      children: [
                                        TextSpan(
                                            text: Helpers.formatPrice(
                                                order.cart?.cartGrandTotal),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 18.fontMultiplier,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black))
                                      ]),
                                ),*/

                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 8, vertical: 4),
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 8, vertical: 4),
                                //   decoration: BoxDecoration(
                                //       color: AppColors.orderStatusColor[order.status]
                                //           ?.withOpacity(0.2),
                                //       borderRadius: BorderRadius.circular(24)),
                                //   child: Text(
                                //     Get.find<OrdersController>().getOrderStatusTitle(
                                //         order.status) ?? '',
                                //
                                //     style: Theme
                                //         .of(context)
                                //         .textTheme
                                //         .headlineSmall
                                //         ?.copyWith(
                                //         fontSize: 10.fontMultiplier,
                                //         color: AppColors.orderStatusColor[order.status]),
                                //   ),
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      (order.invoiceId != null &&
                              _orderController
                                      .getButtonAttr(
                                          order)[ButtonAttrType.title]
                                      .toString() ==
                                  'cancel'.tr)
                          ? const SizedBox.shrink()
                          : CommonButton(
                              elevation: 0,
                              height: 35,
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              text: _orderController
                                  .getButtonAttr(order)[ButtonAttrType.title],
                              textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  color: _orderController.getButtonAttr(
                                      order)[ButtonAttrType.titleColor]),
                              backgroundColor: _orderController.getButtonAttr(
                                  order)[ButtonAttrType.backgroundColor],
                              clickAction: _orderController
                                  .getButtonAttr(order)[ButtonAttrType.clickEvent]),
                      order.status == OrderStatus.cancelled
                          ? const SizedBox.shrink()
                          : order.invoiceId == null
                              ? CommonButton(
                                  elevation: 0,
                                  height: 35,
                                  isLoading: isLoadingGetPaymentLink,
                                  margin: const EdgeInsets.only(top: 8),
                                  text: 'Pay',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontSize: 14.fontMultiplier,
                                          color: Colors.white),
                                  backgroundColor: AppColors.kPrimaryDarkColor,
                                  clickAction: () async {
                                    try {
                                      isLoadingGetPaymentLink.value = true;
                                      debugPrint(
                                          "Amount: ${order.cart?.cartGrandTotal}");

                                      TipBottomSheet.show(
                                          amount:
                                              order.cart?.cartGrandTotal ?? 0,
                                          onTapPay: (num tip) {
                                            _orderController.getPaymentLink(
                                                orderId: order.id, tip: tip);
                                          });
                                    } finally {
                                      isLoadingGetPaymentLink.value = false;
                                    }
                                  })
                              : CommonButton(
                                  elevation: 0,
                                  height: 35,
                                  isLoading: isLoadingDownloadInvoice,
                                  margin: const EdgeInsets.only(top: 8),
                                  text: 'invoice'.tr,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontSize: 14.fontMultiplier,
                                          color: Colors.white),
                                  backgroundColor: AppColors.kPrimaryDarkColor,
                                  clickAction: () async {
                                    try {
                                      isLoadingDownloadInvoice.value = true;
                                      await _orderController
                                          .getInvoiceLink(order.id);
                                    } finally {
                                      isLoadingDownloadInvoice.value = false;
                                    }
                                  }),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
