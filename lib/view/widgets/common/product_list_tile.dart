import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/model/product.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/view/widgets/common/quantity_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key,
    required this.product,
    this.isAllowedEdit,
    this.onQuantityChange,
    this.onAddTap,
    this.allowLocalIncrement,
    this.onEditTap,
    this.removedIngredientNames,
    this.selectedAddOnNames,
    required this.listingType});

  final Product product;
  final bool? isAllowedEdit;
  final Function(int quantity, QtyChangeType qtyChangeType)? onQuantityChange;
  final Function(Product product)? onAddTap;
  final Function(Product product)? onEditTap;
  final bool? allowLocalIncrement;
  final String? removedIngredientNames;
  final String? selectedAddOnNames;
  final ListingType listingType;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          // categories!.name.toString(),
                          product.name,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.fontMultiplier,
                              color: Colors.black),
                        ),
                      ),
                      Visibility(
                        visible: listingType == ListingType.mainListing &&
                            (product.ingredientNames ?? '').isNotEmpty,
                        child: Text(
                          //'Chicken, lettuce, tomato,onion, sauce',
                          product.ingredientNames ?? '',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontSize: 14.fontMultiplier,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: listingType !=ListingType.mainListing && removedIngredientNames !=null,
                        child: Text(
                          //'Chicken, lettuce, tomato,onion, sauce',
                         '-${removedIngredientNames ?? ''}',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontSize: 14.fontMultiplier,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),

                      Visibility(
                        visible: listingType !=ListingType.mainListing && selectedAddOnNames !=null,
                        child: Text(
                          //'Chicken, lettuce, tomato,onion, sauce',
                          '+${selectedAddOnNames ?? ''}',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontSize: 14.fontMultiplier,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: '€ ',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                              children: [
                                TextSpan(
                                    text: Helpers.formatPrice(product.price),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 18))
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
           if(listingType !=ListingType.orderDetailListing)   Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isAllowedEdit ?? false)
                    InkWell(
                      onTap: () {
                        if (onEditTap != null) {
                          onEditTap!(product);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 24.0,
                        ),
                        child: SvgPicture.asset(
                          AppIcons.icEdit,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn),
                          height: 18,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 80,
                    child: QuantityBtnWidget(
                      quantity: product.qty,
                      allowLocalIncrement: allowLocalIncrement,
                      onQuantityChange: onQuantityChange,
                      onAddTap: () {
                        if (onAddTap != null) {
                          onAddTap!(product);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
