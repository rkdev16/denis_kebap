import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/cart_item.dart';
import 'package:denis_kebap/model/ingredient.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final List<Ingredient> ingredients;
  final List<AddOn> addOns;
  final String? ingredientNames;
  final num? tax;
  int qty;
  int variants;
  final List<CartItem>? cartItems;
  final bool? isCustomizable;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.ingredients,
      required this.addOns,
      this.ingredientNames,
      this.tax,
      this.qty = 0,
      this.variants = 1,
      this.cartItems,
      this.isCustomizable});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        ingredients: List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x))),
        addOns: List<AddOn>.from(json["addOns"].map((x) => AddOn.fromJson(x))),
        ingredientNames: createIngredientsNamesString(List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x)))),
        isCustomizable:
            List<AddOn>.from(json["addOns"].map((x) => AddOn.fromJson(x)))
                    .isNotEmpty &&
                List<Ingredient>.from(
                        json["ingredients"].map((x) => Ingredient.fromJson(x)))
                    .isNotEmpty,
        tax: json["tax"] ?? 0,
        qty: json["qty"] ?? 0,
        variants: json["varients"] ?? 1,
        cartItems: json["cartItems"] == null
            ? []
            : List<CartItem>.from(
                json["cartItems"]!.map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
        "addOns": List<dynamic>.from(addOns.map((x) => x.toJson())),
        "tax": tax,
        "qty": qty,
        "varients": variants,
        "cartItems": cartItems == null
            ? []
            : List<CartItem>.from(cartItems!.map((x) => x.toJson())),
      };



  static String? createIngredientsNamesString(List<Ingredient> ingredients) {
    String? result;

    if (ingredients.isNotEmpty) {
      StringBuffer names = StringBuffer();

      for (var element in ingredients) {
        names.write(element.name);
        names.write(', ');
      }
      result = names.toString().substring(0, names.length - 2);
    }
    return result;
  }
}
