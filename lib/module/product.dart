import 'dart:ffi';
import 'dart:convert';

class Product {
  int id;
  String name;
  double price;
  int quantity;
  String image;


  Product({
    this.id,
    this.name ,
    this.price,
    this.quantity,
    this.image
  });



  factory Product.fromMap(Map<String, dynamic> json) => new Product(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    quantity: json["quantity"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "price": price,
    "quantity": quantity,
    "image":image
  };
}

Product productFromJson(String str) {
  final jsonData = json.decode(str);
  return Product.fromMap(jsonData);
}

String productToJson(Product data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}