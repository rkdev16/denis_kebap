class AddOn {
  final String id;
  final String name;
  final double price;
  bool isChecked;

  AddOn({
    required this.id,
    required this.name,
    required this.price,
    this.isChecked = false
  });

  factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
    id: json["_id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "price": price,
  };
}