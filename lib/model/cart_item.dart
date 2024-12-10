
import 'package:denis_kebap/model/add_on.dart';
import 'package:denis_kebap/model/ingredient.dart';

class CartItem {
  final String? id;
  final List<Ingredient>? removedIngredients;
  final List<AddOn>? selectedAddOns;
   int? qty;

  CartItem({
    this.id,
    this.removedIngredients,
    this.selectedAddOns,
    this.qty,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["_id"],
    removedIngredients: json["removedIngredients"] == null ? [] : List<Ingredient>.from(json["removedIngredients"]!.map((x) => AddOn.fromJson(x))),
    selectedAddOns: json["selectedAddOns"] == null ? [] : List<AddOn>.from(json["selectedAddOns"]!.map((x) => AddOn.fromJson(x))),
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "removedIngredients": removedIngredients == null ? [] : List<dynamic>.from(removedIngredients!.map((x) => x.toJson())),
    "selectedAddOns": selectedAddOns == null ? [] : List<dynamic>.from(selectedAddOns!.map((x) => x.toJson())),
    "qty": qty,
  };


  Map<String, dynamic> toRequestJson() => {
    "_id": id,
    "qty": qty,
  };














}
