import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/ingredient.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/utils/validations.dart';
import 'package:denis_kebap/view/bottom_sheets/select_ingredients_bottom_sheet.dart';
import 'package:denis_kebap/view/pages/cart/components/tip_tab.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_input_field.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:denis_kebap/view/widgets/common/empty_cart_widget.dart';
import 'package:denis_kebap/view/widgets/common/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../consts/app_icons.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../bottom_sheets/select_time_bottom_sheet.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _cartController.selectedTimeSlot.value = null;
    _cartController.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(
        systemUiOverlayStyle:
        SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        title: 'shopping_cart'.tr,
        titleTextColor: Colors.white,
        backgroundColor: Colors.black,
        leading: SvgPicture.asset(
          AppIcons.icBack,
          height: 20,
        ),
      ),
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _cartController.cartItems.isEmpty &&
                  _cartController.isLoading.value
              ? const Center(child: CommonProgressBar())
              : _cartController.cartItems.isEmpty
                  ? const EmptyCartWidget()
                  : Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.only(bottom: 24),
                                shrinkWrap: true,
                                children: [
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      itemBuilder: (context, index) {
                                        var cartItem =
                                            _cartController.cartItems[index];

                                        cartItem.selectedAddOns
                                            ?.forEach((element) {
                                          element.isChecked = true;
                                        });

                                        return ProductListTile(
                                          listingType: ListingType.cartListing,
                                          product: Product(
                                              id: cartItem.id ?? '',
                                              name:
                                                  cartItem.product?.name ?? '',
                                              price: Helpers.calculateProductPrice(
                                                  productPrice:
                                                      cartItem.product?.price ??
                                                          0.0,
                                                  addOns:
                                                      cartItem.selectedAddOns ??
                                                          [],
                                                  ingredients: cartItem
                                                          .removedIngredients ??
                                                      [],
                                                  quantity: cartItem.qty ?? 0),
                                              qty: cartItem.qty ?? 0,
                                              ingredients: cartItem
                                                      .product?.ingredients ??
                                                  [],
                                              ingredientNames: cartItem.product
                                                      ?.ingredientNames ??
                                                  '',
                                              addOns:
                                                  cartItem.product?.addOns ??
                                                      []),
                                          removedIngredientNames:
                                              cartItem.removedIngredientNames,
                                          selectedAddOnNames:
                                              cartItem.selectedAddOnNames,
                                          allowLocalIncrement: true,
                                          isAllowedEdit: true,
                                          onQuantityChange: (int quantity,
                                              QtyChangeType
                                                  qtyChangeType) async {
                                            await _cartController.changeQtyCart(
                                                cartItemId: cartItem.id,
                                                qtyChangeType: qtyChangeType);
                                            _cartController.getCart();
                                          },
                                          onAddTap: (Product product) {
                                            // setState(() {
                                            //   widget.product?.cartItems?[index].qty = 1;
                                            // });
                                          },
                                          onEditTap: (Product product) {
                                            var removedIngredients =
                                                cartItem.removedIngredients ??
                                                    [];
                                            var selectedAddOns =
                                                cartItem.selectedAddOns ?? [];

                                            List<Ingredient> ingredients =
                                                <Ingredient>[];

                                            ingredients.addAll(
                                                cartItem.product?.ingredients ??
                                                    []);

                                            var addOns = <AddOn>[];
                                            addOns.addAll(
                                                cartItem.product?.addOns ?? []);

                                            for (var ingredient
                                                in ingredients) {
                                              for (var removedIngredients
                                                  in removedIngredients) {
                                                if (ingredient.id ==
                                                    removedIngredients.id) {
                                                  ingredient.isChecked = false;
                                                  break;
                                                }
                                              }
                                            }
                                            for (var addOn in addOns) {
                                              for (var selectedAddOn
                                                  in selectedAddOns) {
                                                if (addOn.id ==
                                                    selectedAddOn.id) {
                                                  addOn.isChecked = true;
                                                  break;
                                                }
                                              }
                                            }
                                            SelectIngredientsBottomSheet.show(
                                                product: Product(
                                                    id: cartItem.product?.id ??
                                                        "",
                                                    name: cartItem
                                                            .product?.name ??
                                                        "",
                                                    price: cartItem
                                                            .product?.price ??
                                                        0.0,
                                                    qty: cartItem.qty ?? 0,
                                                    ingredients: ingredients,
                                                    ingredientNames: cartItem
                                                            .product
                                                            ?.ingredientNames ??
                                                        '',
                                                    addOns: addOns),
                                                cartId: cartItem.id,
                                                isEditing: true,
                                                quantity: cartItem.qty ?? 1,
                                                refreshProducts: () {
                                                  Navigator.of(context).pop();
                                                  _cartController.getCart();
                                                  //  Get.back();
                                                });
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 8,
                                        );
                                      },
                                      itemCount:
                                          _cartController.cartItems.length),
                                //  _tipSection(context),
                                  _billDetailSection(context),
                                  _timeSlotSection(context)
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: '€ ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontSize: 22.fontMultiplier,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                          children: [
                                        TextSpan(
                                            text: Helpers.formatPrice(
                                                _cartController.cart.value
                                                    ?.cartGrandTotal),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 22.fontMultiplier,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600))
                                      ])),
                                  Expanded(
                                    child: Obx(
                                      () => _cartController
                                              .showProgressAnimation.value
                                          ? FAProgressBar(
                                              size: 40,
                                              progressColor: Colors.amberAccent,
                                              currentValue: _cartController
                                                  .progressCurrentValue.value,
                                              maxValue: 100,
                                              changeColorValue: 70,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.5),
                                              displayText: "%",
                                              changeProgressColor: Colors.green,
                                            )
                                          : CommonButton(
                                              height: 40,
                                              margin: const EdgeInsets.only(
                                                  left: 8),
                                              textColor: Colors.white,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      fontSize:
                                                          14.fontMultiplier,
                                                      color: Colors.white),
                                              // text: 'continue'.tr,
                                              isLoading: _cartController
                                                  .isLoadingPlaceOrder,
                                              text: _cartController
                                                          .selectedTimeSlot
                                                          .value !=
                                                      null
                                                  ? PreferenceManager
                                                              .appLanguage ==
                                                          AppLanguage.english
                                                      ? '${'pick_up_in'.tr} ${PreferenceManager.restaurantLocation?.name ?? ""}'
                                                      : '${'In'.tr} ${PreferenceManager.restaurantLocation?.name ?? ""} abholen'
                                                  : 'select_pickup_time'.tr,
                                              backgroundColor: Colors.black,
                                              clickAction: () {
                                                if (_cartController
                                                        .selectedTimeSlot
                                                        .value ==
                                                    null) {
                                                  // Get.toNamed(AppRoutes.routeOrderConfirmationScreen);
                                                  SelectTimeBottomSheet.show();
                                                  // if (_cartController.selectedTipType.value == TipType.userDefined &&
                                                  //     _cartController.formKey.currentState!.validate()) {
                                                  //   _cartController.showPreOrderConfirmationAlert();
                                                  // } else {
                                                  //   _cartController
                                                  //       .showPreOrderConfirmationAlert();
                                                  // }
                                                } else {
                                                  _cartController.showPreOrderConfirmationAlert();
                                                }
                                              }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Obx(() => _cartController.isLoading.value
                            ? const CommonProgressBar()
                            : const SizedBox())
                      ],
                    ),
        ),
      ),
    );
  }

  _billDetailSection(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "bills_details".tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 16.fontMultiplier, color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'net_price'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 14.fontMultiplier,
                                color: Colors.black,
                              ),
                    ),
                    RichText(
                        text: TextSpan(
                            text: '€ ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: 16.fontMultiplier,
                                  color: Colors.black,
                                ),
                            children: [
                          TextSpan(
                              text: Helpers.formatPrice(
                                  _cartController.cart.value?.cartTotal),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontSize: 16.fontMultiplier,
                                      color: Colors.black))
                        ])),
                  ],
                ),
                const Divider(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'vat'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 14.fontMultiplier,
                                color: Colors.black,
                              ),
                    ),
                    RichText(
                        text: TextSpan(
                            text: '€ ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: 16.fontMultiplier,
                                  color: Colors.black,
                                ),
                            children: [
                          TextSpan(
                              text: Helpers.formatPrice(
                                  _cartController.cart.value?.cartTax),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontSize: 16.fontMultiplier,
                                      color: Colors.black))
                        ])),
                  ],
                ),
                const Divider(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total_pay'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 14.fontMultiplier,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                    ),
                    RichText(
                        text: TextSpan(
                            text: '€ ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: 16.fontMultiplier,
                                  color: Colors.black,
                                ),
                            children: [
                          TextSpan(
                              text: Helpers.formatPrice(
                                  _cartController.cart.value?.cartGrandTotal),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontSize: 16.fontMultiplier,
                                      color: Colors.black))
                        ])),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  _timeSlotSection(context) => Obx(
        () => Visibility(
          visible: _cartController.selectedTimeSlot.value != null,
          child: InkWell(
            onTap: () {
              SelectTimeBottomSheet.show();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AppIcons.icWatch),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'my_pickup_time'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 14.fontMultiplier,
                                color: Colors.black,
                              ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          _cartController.selectedTimeSlot.value?.time ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.navigate_next)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

  // _tipSection(context) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //           child: Text(
  //             "tip".tr,
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .headlineMedium
  //                 ?.copyWith(fontSize: 16.fontMultiplier, color: Colors.white),
  //           ),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  //           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //           decoration: BoxDecoration(
  //               color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Obx(
  //                     () => TipTab(
  //                       isSelected: _cartController.selectedTipType.value ==
  //                           TipType.noTip,
  //                       title: 'no_tip'.tr,
  //                       onTap: () {
  //                         _cartController.selectedTipType.value = TipType.noTip;
  //                       },
  //                     ),
  //                   ),
  //                   Obx(
  //                     () => TipTab(
  //                       isDisabled:
  //                           _cartController.autoCalculatedTip.value <= 0,
  //                       isSelected: _cartController.selectedTipType.value ==
  //                           TipType.autoCalculated,
  //                       title:
  //                           '${AppConsts.currencySign} ${Helpers.formatPrice(_cartController.autoCalculatedTip.value)}'
  //                               .tr,
  //                       onTap: () {
  //                         _cartController.selectedTipType.value =
  //                             TipType.autoCalculated;
  //                       },
  //                     ),
  //                   ),
  //                   Obx(
  //                     () => TipTab(
  //                       isSelected: _cartController.selectedTipType.value ==
  //                           TipType.userDefined,
  //                       title: 'other'.tr,
  //                       onTap: () {
  //                         _cartController.selectedTipType.value =
  //                             TipType.userDefined;
  //                       },
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               if (_cartController.selectedTipType.value ==
  //                   TipType.userDefined)
  //                 _tipInput()
  //             ],
  //           ),
  //         ),
  //       ],
  //     );

  // _tipInput() => Form(
  //       key: _cartController.formKey,
  //       child: CommonInputField(
  //         // prefixIcon: Container(
  //         //     height: 24,
  //         //     padding: const EdgeInsets.only(top: 14,bottom: 14),
  //         //     child: SvgPicture.asset(
  //         //       AppIcons.icEuro,
  //         //       colorFilter: const ColorFilter.mode(
  //         //           AppColors.colorDC, BlendMode.srcIn),
  //         //     )),
  //
  //         prefixText: '${AppConsts.currencySign} ',
  //         prefixStyle: Theme.of(context)
  //             .textTheme
  //             .headlineMedium
  //             ?.copyWith(fontSize: 16.fontMultiplier, color: AppColors.colorDC),
  //         fillColor: Colors.transparent,
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  //         textColor: AppColors.colorTextPrimary,
  //         cursorColor: Colors.black,
  //         inputType: TextInputType.number,
  //         hintTextColor: AppColors.colorDC,
  //         onChanged: (value) {
  //           Helpers.formatAmountInDecimal(
  //               value, _cartController.tipTextController);
  //         },
  //         inputFormatter: AppConsts.amountInputFormatter,
  //         validator: Validations.checkEmptyFiledValidations,
  //         controller: _cartController.tipTextController,
  //         margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
  //         hint: "enter_tip_amount".tr,
  //         inputBorder: const UnderlineInputBorder(
  //             borderSide: BorderSide(color: AppColors.colorDC)),
  //
  //         errorInputBorder: const UnderlineInputBorder(
  //             borderSide: BorderSide(color: AppColors.colorDC)),
  //       ),
  //     );
}
