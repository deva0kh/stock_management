import 'dart:ffi';
import 'dart:convert';

class Plant {
  int id;
  String name;
  String image;


  Plant({
    this.id,
    this.name ,
    this.image
  });



  factory Plant.fromMap(Map<String, dynamic> json) => new Plant(
    id: json["id"],
    name: json["common_name"],
    image: json["image_url"],
  );

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        id: json["id"],
        name: json["common_name"],
        image: json["image_url"]);
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "common_name": name,
    "image_url":image
  };




}

Plant plantFromJson(String str) {
  final jsonData = json.decode(str);
  return Plant.fromMap(jsonData);
}

String plantToJson(Plant data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}