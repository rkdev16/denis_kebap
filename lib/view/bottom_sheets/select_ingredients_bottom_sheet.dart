import 'package:denis_kebap/config/size_config.dart';
import 'package:denis_kebap/controller/cart/cart_controller.dart';
import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/ingredient.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/view/widgets/common/common_bg_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_message_widget.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectIngredientsBottomSheet {
  static show(
      {required Product product,
      required refreshProducts,
      bool? isEditing = false,
      int quantity = 1,
      String? cartId}) {
    Get.bottomSheet(
        IngredientsBottomSheetContent(
          product: product,
          refreshProducts: refreshProducts,
          isEditing: isEditing,
          quantity: quantity,
          cartId: cartId,
        ),
        ignoreSafeArea: false,
        isScrollControlled: true //to make sheet full height

        );
  }
}

class IngredientsBottomSheetContent extends StatefulWidget {
  IngredientsBottomSheetContent(
      {super.key,
      this.quantity = 1,
      required this.product,
      required this.refreshProducts,
      this.isEditing,
      this.cartId});

  bool? isEditing;
  final Product product;
  final VoidCallback refreshProducts;
  int quantity = 1;
  num price = 0;
  String? cartId;

  @override
  State<IngredientsBottomSheetContent> createState() =>
      _IngredientsBottomSheetContentState();
}

class _IngredientsBottomSheetContentState
    extends State<IngredientsBottomSheetContent> {
  updatePrice() {
    setState(() {
      // widget.price = widget.quantity * widget.product.price + widget.quantity * totalAddonsPrice() ;

      widget.price = Helpers.calculateProductPrice(
          productPrice: widget.product.price,
          addOns: widget.product.addOns,
          ingredients: widget.product.ingredients,
          quantity: widget.quantity);
    });
  }

  addToCart(
      {required Product product,
      required int qty,
      required bool? isEditing,
      required String? cartId}) async {
    List<Ingredient> removedIngredients = product.ingredients
        .where((element) => element.isChecked == false)
        .toList();
    List<AddOn> selectedAddons =
        product.addOns.where((element) => element.isChecked == true).toList();

    bool isProductAdded;
    if (isEditing ?? false) {
      isProductAdded = await Get.find<CartController>().editCartItem(
          cartItemId: cartId ?? '',
          removedIngredients: List.generate(removedIngredients.length,
              (index) => removedIngredients[index].id),
          selectedAddons: List.generate(
              selectedAddons.length, (index) => selectedAddons[index].id),
          quantity: qty);
    } else {
      isProductAdded = await Get.find<CartController>().addItemToCart(
          productId: product.id,
          removedIngredients: List.generate(removedIngredients.length,
              (index) => removedIngredients[index].id),
          selectedAddons: List.generate(
              selectedAddons.length, (index) => selectedAddons[index].id),
          quantity: qty);
    }

    debugPrint("isProductAdded  =$isProductAdded");

    if (isProductAdded) {
      widget.refreshProducts();
    }
  }

  @override
  void initState() {
    super.initState();
    updatePrice();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgBottomSheet(
        child: SizedBox(
          height: SizeConfig.screenHeight - 200,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'ingredients'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                          fontSize: 18.fontMultiplier,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      icon: const Icon(
                        Icons.cancel,
                        size: 32,
                        color: Colors.white,
                      ))
                ],
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.only(top: 8, bottom:16),
                  shrinkWrap: true,

                  children: [

                    widget.product.ingredients.isEmpty
                        ? const CommonMessageWidget(
                            message: 'message_no_ingredients_available')
                        : ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              widget.product.ingredients.length,
                              (index) => OptionListTile(
                                priceSign: '-',
                                title: widget.product.ingredients[index].name,
                                price: widget.product.ingredients[index].price,
                                isChecked:
                                    widget.product.ingredients[index].isChecked,
                                onChanged: (bool? checked) {
                                  widget.product.ingredients[index].isChecked =
                                      checked ?? false;
                                  updatePrice();
                                },
                              ),
                            )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                      child: Text(
                        'add_ons'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 18.fontMultiplier,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    widget.product.addOns.isEmpty
                        ? const CommonMessageWidget(
                            message: 'message_no_addons_available')
                        : ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                                widget.product.addOns.length,
                                (index) => OptionListTile(
                                      title: widget.product.addOns[index].name,
                                      price: widget.product.addOns[index].price,
                                      isChecked:
                                          widget.product.addOns[index].isChecked,
                                      onChanged: (bool? checked) {
                                        widget.product.addOns[index].isChecked =
                                            checked ?? false;
                                        updatePrice();
                                      },
                                    )))
                  ],
                ),
              ),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Get.find<CartController>().isLoadingAddToCart.value
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: const  SafeArea(
                            top: false,
                              child:  CommonProgressBar(
                                size: 40,
                                strokeWidth: 3,

                              )),
                        )
                      : Container(
                          width: double.infinity,
                          color: Colors.white,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),

                          child: SafeArea(
                            top: false,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: SizeConfig.widthMultiplier * 35,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.fromBorderSide(BorderSide(
                                          color: Colors.black.withOpacity(0.2))),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            if (widget.quantity > 1) {
                                              setState(() {
                                                widget.quantity =
                                                    widget.quantity - 1;
                                                updatePrice();
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline_rounded,
                                            color: Colors.white,
                                            size: 28,
                                          )),
                                      Container(
                                        width: 35,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            widget.quantity.toString(),
                                            // textScaleFactor: ScaleSize.textScaleFactor(context),
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 16.fontMultiplier,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty.all(
                                                  EdgeInsets.zero)),
                                          onPressed: () {
                                            setState(() {
                                              widget.quantity = widget.quantity + 1;
                                              updatePrice();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.add_circle_outline_rounded,
                                            color: Colors.white,
                                            size: 28,
                                          )),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // widget.onAddProduct(widget.product,widget.quantity);
                                    addToCart(
                                        product: widget.product,
                                        qty: widget.quantity,
                                        isEditing: widget.isEditing,
                                        cartId: widget.cartId);
                                  },
                                  child: Container(
                                    width: SizeConfig.widthMultiplier * 52,
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 16),
                                    padding:
                                        const EdgeInsets.only(left: 16, right: 8),
                                    constraints: const BoxConstraints(minHeight: 0),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'add_item'.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 12.fontMultiplier,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('€',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                            fontSize:
                                                                14.fontMultiplier)),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 4.0, right: 8),
                                                  child: Text(
                                                      Helpers.formatPrice(
                                                          widget.price),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors.white,
                                                              fontSize: 12
                                                                  .fontMultiplier)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}

class OptionListTile extends StatefulWidget {
  OptionListTile(
      {super.key,
      required this.title,
      required this.isChecked,
      required this.onChanged,
      required this.price,
      this.priceSign});

  final String title;
  final dynamic price;
  final String? priceSign;
  bool isChecked;
  Function(bool? checked) onChanged;

  @override
  State<OptionListTile> createState() => _OptionListTileState();
}

class _OptionListTileState extends State<OptionListTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  value: widget.isChecked,
                  onChanged: (bool? value) {
                    widget.onChanged(value);
                    widget.isChecked = !widget.isChecked;
                    setState(() {});
                  }),
            ),
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 14.fontMultiplier, color: Colors.white),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                  widget.priceSign != null ? '${widget.priceSign} €' : '€',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,

                      fontSize: 14)),
            ),
            Text(
              Helpers.formatPrice(widget.price),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 14.fontMultiplier, color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
