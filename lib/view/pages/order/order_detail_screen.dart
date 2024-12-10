

import 'dart:convert';

import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/cart_res_model.dart';
import 'package:denis_kebap/model/order/orders_res_model.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_error_widget.dart';
import 'package:denis_kebap/view/widgets/common/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends StatefulWidget {
   OrderDetailScreen({super.key});

   Cart? order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {

  @override
  void initState() {
    super.initState();
    Map<String,dynamic>?  data = Get.arguments;
    if(data !=null){
      setState(() {
        widget.order = Order.fromJson(json.decode(data['order'])).cart;
        debugPrint("Order = ${data['order']}");
        debugPrint("Order = ${widget.order?.toJson()}");
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(
        systemUiOverlayStyle:
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black),
        title: 'order_detail'.tr,
        titleTextColor: Colors.white,
        backgroundColor: Colors.black,
        onBackTap: (){
          Get.back();
        },
        leading: SvgPicture.asset(
          AppIcons.icBack,
          height: 20,
        ),
      ),
      body: widget.order ==null ? const  CommonErrorWidget()
                    : Column(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                                  itemBuilder: (context, index) {

                                    var cartItem = widget.order?.cartItems![index];

                                    return ProductListTile(
                                      listingType: ListingType.orderDetailListing,
                                      product: Product(
                                          id:cartItem?.id ?? '',
                                          name: cartItem?.product?.name ?? '',

                                          price: Helpers.calculateProductPrice(
                                              productPrice: cartItem?.product?.price ?? 0.0,
                                              addOns: cartItem?.selectedAddOns??[],
                                              ingredients: cartItem?.removedIngredients??[],

                                              quantity: cartItem?.qty??0),



                                          qty: cartItem?.qty ??
                                              0,
                                          ingredients:cartItem?.product
                                              ?.ingredients ??
                                              [],
                                          ingredientNames: cartItem?.product
                                              ?.ingredientNames ??
                                              '',
                                          addOns: cartItem?.product?.addOns ?? []),
                                      removedIngredientNames: cartItem?.removedIngredientNames,
                                      selectedAddOnNames: cartItem?.selectedAddOnNames,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 8,
                                    );
                                  },
                                  itemCount: widget.order?.cartItems?.length??0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  "bills_details".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                      fontSize: 16.fontMultiplier,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 24),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'net_price'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
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
                                                  fontSize:
                                                  16.fontMultiplier,

                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: Helpers.formatPrice(
                                                          widget.order?.cartTotal),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                          fontSize:
                                                          16.fontMultiplier,
                                                          color: Colors.black))
                                                ])),
                                      ],
                                    ),
                                    const Divider(
                                      height: 24,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'vat'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
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
                                                  fontSize:
                                                  16.fontMultiplier,

                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: Helpers.formatPrice(
                                                          widget.order?.cartTax),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                          fontSize:
                                                          16.fontMultiplier,
                                                          color: Colors.black))
                                                ])),
                                      ],
                                    ),
                                    const Divider(
                                      height: 24,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'total_pay'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
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
                                                  fontSize:
                                                  16.fontMultiplier,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: Helpers.formatPrice(
                                                          widget.order?.cartGrandTotal),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                          fontSize:
                                                          16.fontMultiplier,
                                                          color: Colors.black))
                                                ])),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),

    );
  }


}
