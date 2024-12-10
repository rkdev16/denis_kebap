import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/controller/cart/cart_controller.dart';
import 'package:denis_kebap/controller/home/home_controller.dart';
import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/categories_res_model.dart';
import 'package:denis_kebap/model/ingredient.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/bottom_sheets/select_ingredients_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:denis_kebap/view/widgets/common/common_image_widget.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:denis_kebap/view/widgets/common/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({super.key, required this.category});

  final Category category;

  final _homeController = Get.find<HomeController>();
  final _products = <Product>[].obs;
  RxBool isLoading = true.obs;

  getProducts() async {
    try {
      if (_products.isEmpty) isLoading.value = true;
      var products = await _homeController.getProducts(category.id);
      _products.assignAll(products);
    } finally {
      isLoading.value = false;
    }
  }

  addToCart(Product product, int qty) async {
    List<Ingredient> removedIngredients = product.ingredients
        .where((element) => element.isChecked == false)
        .toList();
    List<AddOn> selectedAddons =
        product.addOns.where((element) => element.isChecked == true).toList();

    var result = await Get.find<CartController>().addItemToCart(
        productId: product.id,
        removedIngredients: List.generate(
            removedIngredients.length, (index) => removedIngredients[index].id),
        selectedAddons: List.generate(
            selectedAddons.length, (index) => selectedAddons[index].id),
        quantity: qty);

    if (result) {
      getProducts();
    }
  }

  handleAddClick(
      {required BuildContext context,
      required Product product,
      required HomePageWidget widget}) async {
    if (product.isCustomizable ?? false) {
      SelectIngredientsBottomSheet.show(
          product: Product.fromJson(product.toJson()),
          refreshProducts: () {
            Navigator.of(context).pop();
            widget.getProducts();
          });
    } else {
      try {
        isLoading.value = true;
        await Get.find<CartController>().addItemToCart(
            productId: product.id,
            removedIngredients: [],
            selectedAddons: [],
            quantity: 1);
        widget.getProducts();
      } finally {
        isLoading.value = false;
      }
    }
  }

  handleQuantityChange(
      {required BuildContext context,
      required QtyChangeType qtyChangeType,
      required Product product,
      required HomePageWidget widget}) async {
    //todo :- if user reducing quantity and only single product variant is there.
    if (qtyChangeType == QtyChangeType.decrease && product.variants <= 1) {
      Get.find<CartController>().decQtyProductList(product.id);
    }
    //todo :- if user increasing quantity and product is not customisable(e.g. drinks items).
    else if (qtyChangeType == QtyChangeType.increase &&
        !(product.isCustomizable ?? false)) {
      try {
        isLoading.value = true;
        await Get.find<CartController>().addItemToCart(
            productId: product.id,
            removedIngredients: [],
            selectedAddons: [],
            quantity: 1);
        widget.getProducts();
      } finally {
        isLoading.value = false;
      }
    }
    //todo :- if user increasing/decreasing quantity.
    else {
      SelectIngredientsBottomSheet.show(
          product: Product.fromJson(product.toJson()),
          refreshProducts: () {
            Navigator.of(context).pop();
            widget.getProducts();
          });

      //todo -> Removed customisations as per client requirement for now will update/structured this later.
      // CustomisationsBottomSheet.show(
      //     product: Product.fromJson(product.toJson()),
      //     refreshProducts: () {
      //       Navigator.of(context).pop();
      //       widget.getProducts();
      //     },
      //     onAddNewTap: () {
      //       SelectIngredientsBottomSheet.show(
      //           product: Product.fromJson(product.toJson()),
      //           refreshProducts: () {
      //             Navigator.of(context).pop();
      //             widget.getProducts();
      //           });
      //     });
    }
  }

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  void initState() {
    super.initState();
    widget.getProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: CommonImageWidget(
                    url: Helpers.getCompleteUrl(widget.category.image),
                    height: 150,
                    width: double.infinity,
                    borderRadius: 8,
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ProductListTile(
                      listingType: ListingType.mainListing,
                      product: widget._products[index],
                      onAddTap: PreferenceManager.userToken != ''
                          ? (Product product) async {
                              widget.handleAddClick(
                                  context: context,
                                  product: product,
                                  widget: widget);
                            }
                          : (Product product) async {
                        _loginDialog();
                      },
                      allowLocalIncrement:
                          !(widget._products[index].isCustomizable ?? true),
                      onQuantityChange:
                          (int quantity, QtyChangeType qtyChangeType) async {
                        widget.handleQuantityChange(
                            context: context,
                            qtyChangeType: qtyChangeType,
                            product: widget._products[index],
                            widget: widget);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: widget._products.length,
                  //  itemCount:_homeController.categories.length
                )
              ],
            ),
            Obx(
              () => Visibility(
                  visible: widget.isLoading.value,
                  child: const CommonProgressBar()),
            )
          ],
        ),
      ),
    );
  }

   _loginDialog() => Get.dialog(Column(
     mainAxisSize: MainAxisSize.min,
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       Container(
         margin: EdgeInsets.symmetric(horizontal: 20,),
         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
         decoration: BoxDecoration(
             color: Colors.white,
           borderRadius: BorderRadius.circular(10)
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(
               'login_first_cart'.tr,
               textAlign: TextAlign.center,
               style: Theme.of(context)
                   .textTheme
                   .headlineSmall
                   ?.copyWith(
                   fontSize: 18.fontMultiplier,
                   fontWeight: FontWeight.w600,
                   color: Colors.black),
             ).paddingOnly(bottom: 15, left: 20, right: 20),
             Row(
               children: [
                 Expanded(child: CommonButton(
                   text: 'cancel'.tr,
                   borderColor: AppColors.kPrimaryColor,
                   textColor: AppColors.kPrimaryColor,
                   backgroundColor: Colors.white,
                   clickAction: (){
                     Get.back();
                   },
                 )),
                 Expanded(child: CommonButton(
                   text: 'login_register'.tr,
                   clickAction: (){
                     Get.offAllNamed(AppRoutes.routeLoginScreen);
                   },
                 )),
               ],
             )
           ],
         ),
       )
     ],
   ));
}
