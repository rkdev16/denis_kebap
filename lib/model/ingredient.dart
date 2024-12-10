class Ingredient {
  final String id;
  final String name;
  final dynamic price;
  bool isChecked ;

  Ingredient({
    required this.id,
    required this.name,
    this.price,
    this.isChecked = true
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: json["_id"],
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "price": price,
  };
}