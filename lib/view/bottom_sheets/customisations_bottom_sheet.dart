import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/controller/cart/cart_controller.dart';
import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/cart_item.dart';
import 'package:denis_kebap/model/ingredient.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/network/get_requests.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/view/bottom_sheets/select_ingredients_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_bg_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:denis_kebap/view/widgets/common/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomisationsBottomSheet {
  static show(
      {required Product product,
      required refreshProducts,
      required VoidCallback onAddNewTap}) {
    Get.bottomSheet(
        CustomisationsBottomSheetContent(
            product: product,
            onAddNewTap: onAddNewTap,
            refreshProducts: refreshProducts),
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true //to make sheet full height

        );
  }
}

class CustomisationsBottomSheetContent extends StatefulWidget {
  CustomisationsBottomSheetContent({
    super.key,
    this.quantity = 1,
    this.product,
    required this.refreshProducts,
    required this.onAddNewTap,
  });

  Product? product;
  final VoidCallback refreshProducts;
  final VoidCallback onAddNewTap;
  int quantity = 1;
  num price = 0;

  @override
  State<CustomisationsBottomSheetContent> createState() =>
      _CustomisationsBottomSheetContentState();
}

class _CustomisationsBottomSheetContentState
    extends State<CustomisationsBottomSheetContent> {
  final _cartController = Get.find<CartController>();

  bool isLoading = true;
  bool isLoadingBulkUpdate = false;

  fetchProductVariants() async {
    try {
      setState(() {
        isLoading = true;
      });

      var result =
          await GetRequests.fetchSingleProductVariant(widget.product?.id ?? '');
      if (result != null) {
        if (result.success) {
          setState(() {
            widget.product = result.product;
          });
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  updateBulkCartProducts() async {
    try {
      setState(() {
        isLoadingBulkUpdate = true;
      });
      Map<String, dynamic> requestBody = {
        'cartItems': createBulkUpdateReqBody(widget.product?.cartItems ?? [])
      };

      var result = await _cartController.cartBulkUpdate(requestBody);
      if (result) {
        widget.refreshProducts();
      }
    } finally {
      setState(() {
        isLoadingBulkUpdate = false;
      });
    }
  }

  List<Map<String, dynamic>> createBulkUpdateReqBody(List<CartItem> cartItem) {
    var result = <Map<String, dynamic>>[];
    for (var element in cartItem) {
      result.add(element.toRequestJson());
    }

    debugPrint("BulkEditData = $result");
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchProductVariants();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgBottomSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 0),
                  child: Text(
                    'your_customisation'.tr,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.fontMultiplier,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      widget.refreshProducts();
                    },
                    padding: const EdgeInsets.all(24),
                    icon: const Icon(
                      Icons.cancel,
                      size: 32,
                      color: Colors.white,
                    ))
              ],
            ),
            isLoading
                ? const Expanded(child: Center(child: CommonProgressBar()))
                : Expanded(
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          widget.product?.cartItems?[index].selectedAddOns
                              ?.forEach((element) {
                            element.isChecked = true;
                          });
                          return ProductListTile(
                            listingType: ListingType.cartListing,
                            product: Product(
                                id: widget.product?.cartItems?[index].id??'',
                                name: widget.product?.name ?? "",
                                price: Helpers.calculateProductPrice(
                                    productPrice: widget.product?.price ?? 0,
                                    addOns: widget.product?.cartItems?[index]
                                            .selectedAddOns ??
                                        [],
                                    ingredients: widget
                                            .product
                                            ?.cartItems?[index]
                                            .removedIngredients ??
                                        [],
                                    quantity:
                                        widget.product?.cartItems?[index].qty ??
                                            0),
                                qty: widget.product?.cartItems?[index].qty ?? 0,
                                ingredients: widget.product?.ingredients ?? [],
                                ingredientNames:
                                    widget.product?.ingredientNames ?? '',
                                addOns: widget.product?.addOns ?? []),
                            allowLocalIncrement: true,
                            isAllowedEdit: true,
                            onQuantityChange:
                                (int quantity, QtyChangeType qtyChangeType) {
                              widget.product?.cartItems?[index].qty = quantity;
                            },
                            onAddTap: (Product product) {
                              setState(() {
                                widget.product?.cartItems?[index].qty = 1;
                              });
                            },
                            onEditTap: (Product product) {
                              Navigator.of(context).pop();
                              var removedIngredients = widget.product
                                      ?.cartItems?[index].removedIngredients ??
                                  [];
                              var selectedAddOns = widget.product
                                      ?.cartItems?[index].selectedAddOns ??
                                  [];

                              List<Ingredient> ingredients = <Ingredient>[];
                              ingredients
                                  .addAll(widget.product?.ingredients ?? []);

                              var addOns = <AddOn>[];
                              addOns.addAll(widget.product?.addOns ?? []);

                              for (var ingredient in ingredients) {
                                for (var removedIngredients
                                    in removedIngredients) {
                                  if (ingredient.id == removedIngredients.id) {
                                    ingredient.isChecked = false;
                                    break;
                                  }
                                }
                              }
                              for (var addOn in addOns) {
                                for (var selectedAddOn in selectedAddOns) {
                                  if (addOn.id == selectedAddOn.id) {
                                    addOn.isChecked = true;
                                    break;
                                  }
                                }
                              }

                              SelectIngredientsBottomSheet.show(
                                  product: Product(
                                      id: widget
                                              .product?.cartItems?[index].id ??
                                          "",
                                      name: widget.product?.name ?? "",
                                      price: widget.product?.price ?? 0.0,
                                      qty: widget
                                              .product?.cartItems?[index].qty ??
                                          0,
                                      ingredients: ingredients,
                                      ingredientNames:
                                          widget.product?.ingredientNames ?? '',
                                      addOns: addOns),
                                  isEditing: true,
                                  quantity:
                                      widget.product?.cartItems?[index].qty ??
                                          1,
                                  refreshProducts: () {
                                    widget.refreshProducts();
                                    Navigator.of(context).pop();
                                  });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                        itemCount: widget.product?.cartItems?.length ?? 0),
                  ),
            Divider(
              color: Colors.white.withOpacity(0.3),
              indent: 16,
              endIndent: 16,
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onAddNewTap();
                  },
                  child: Text(
                    'add_new_customisation'.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 14.fontMultiplier,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            isLoadingBulkUpdate
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CommonProgressBar(),
                  )
                : CommonButton(
                    text: 'continue'.tr,
                    clickAction: () {
                      updateBulkCartProducts();
                    },
                    backgroundColor: Colors.white,
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    textColor: Colors.black,
                  )
          ],
        ));
  }
}
