import 'dart:convert';
import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/controller/account/account_controller.dart';
import 'package:denis_kebap/controller/order/orders_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/bottom_sheets/language_options_bottom_sheet.dart';
import 'package:denis_kebap/view/bottom_sheets/take_image_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_image_widget.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:denis_kebap/view/widgets/common/empty_order_history_widget.dart';
import 'package:denis_kebap/view/widgets/common/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../consts/app_icons.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/helpers.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _accountController = Get.find<AccountController>();
  final _ordersController = Get.find<OrdersController>();

  getTimeDifference() {
    DateTime d1 = DateTime.now();
    DateTime d2 = DateTime.now().add(const Duration(minutes: 15));

    var diff = d2.difference(d1).inMinutes;
    debugPrint("Diff = $diff");
  }

  @override
  void initState() {
    super.initState();
    if (PreferenceManager.userToken != '') {
      getTimeDifference();
      _accountController.getUserProfile();
      _ordersController
          .getOrders()
          .then((value) => _ordersController.initTimer(() {
                setState(() {});
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          systemUiOverlayStyle: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.black,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light),
          title: 'my_account'.tr,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16),
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return PreferenceManager.userToken != ''
                  ?  [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            color: Colors.white,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'change_language'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 14.fontMultiplier,
                                      color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.icLogout,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'logout'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 14.fontMultiplier,
                                      color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ),
                  ] : [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            color: Colors.white,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'change_language'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ];
                  // _accountController.menuItems;
                },
                onSelected: PreferenceManager.userToken != ''
                    ? (dynamic value) {
                  if (value == 1) {
                    LanguageOptionsBottomSheet.show(context: context);
                  } else if (value == 2) {
                    _accountController.showLogoutAlert();
                  }
                } : (dynamic value) {
                  if (value == 1) {
                    LanguageOptionsBottomSheet.show(context: context);
                  }
                },
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
              ),
            )
          ],
          titleTextColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        color: Colors.black,
                        child: Stack(
                          children: [
                            Obx(
                              () => CommonImageWidget(
                                url: Helpers.getCompleteUrl(
                                    _accountController.userImage.value),
                                errorPlaceholder: AppImages.imgUserPlaceholder,
                                borderRadius: 100,
                              ),
                            ),
                            Obx(
                              () => _accountController.isUpdatingImage.value
                                  ? const CommonProgressBar(
                                      strokeWidth: 3,
                                      size: 100,
                                    )
                                  : const SizedBox(),
                            ),
                            PreferenceManager.userToken != ''
                                ? Positioned(
                                    bottom: 1,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        TakeImageBottomSheet.show(
                                            context: context,
                                            imageSource:
                                                _accountController.picImage);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        padding: const EdgeInsets.all(7.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1.5),
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                        child:
                                            SvgPicture.asset(AppIcons.icEdit),
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      PreferenceManager.userToken != ''
                                          ? '${Helpers.getGreetingMessage().tr}!'
                                          : '${Helpers.getGreetingMessage().tr} ${'user'.tr}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontSize: 20.fontMultiplier,
                                              color: Colors.white),
                                    ),
                                    PreferenceManager.userToken != ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 2),
                                            child: Obx(
                                              () => Text(
                                                _accountController
                                                        .userName.value ??
                                                    'user'.tr,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    PreferenceManager.userToken != ''
                                        ? Obx(
                                            () => Visibility(
                                              visible: _accountController
                                                      .email.value !=
                                                  null,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    AppIcons.icMail,
                                                    width: 22,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4.0),
                                                      child: Text(
                                                        _accountController
                                                                .email.value ??
                                                            'email@gmail.com',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall
                                                            ?.copyWith(
                                                                fontSize: 12
                                                                    .fontMultiplier,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    PreferenceManager.userToken != ''
                                        ? SizedBox() : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: Get.width,
                                        height: 45,
                                        child: CommonButton(
                                            text: 'login_register'.tr,
                                            borderColor: Colors.white,
                                            textColor: Colors.white,
                                            margin: EdgeInsets.only(top: 8),
                                            backgroundColor: Colors.transparent,
                                            clickAction: () {
                                              Get.offAllNamed(
                                                  AppRoutes.routeLoginScreen);
                                            }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              PreferenceManager.userToken != ''
                                  ? IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Get.toNamed(
                                            AppRoutes.routeEditAccountScreen);
                                      },
                                      icon: SvgPicture.asset(
                                        AppIcons.icEdit,
                                        width: 22,
                                      ))
                                  : SizedBox()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "order_history".tr,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14.fontMultiplier,
                                ),
                      ),
                      InkWell(
                        onTap: PreferenceManager.userToken != ''
                            ? () {
                                _ordersController.selectDate(context);
                              }
                            : () {},
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                              size: 16,
                            ),
                            Obx(() => Text(
                                  DateFormat('dd MMM,yyyy').format(
                                      _ordersController.orderDate.value),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontSize: 14.fontMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Obx(
                  () => _ordersController.isLoading.value
                      ? const CommonProgressBar()
                      : _ordersController.orders.isEmpty
                          ? const EmptyOrderHistoryWidget()
                          : ListView.separated(
                              itemBuilder: (context, index) {
                                var order = _ordersController.orders[index];
                                return OrderListTile(
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoutes
                                              .routeOrderDetailScreenScreen,
                                          arguments: {
                                            'order': json.encode(order.toJson())
                                          });
                                    },
                                    order: order,
                                    orderType: (order.orderDateTime
                                                ?.isBefore(DateTime.now()) ??
                                            false)
                                        ? OrderType.past
                                        : OrderType.current);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 8,
                                );
                              },
                              itemCount: _ordersController.orders.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                )),
              ]),
        ));
  }

  @override
  void dispose() {
    _ordersController.cancelTimer();
    super.dispose();
  }
}
