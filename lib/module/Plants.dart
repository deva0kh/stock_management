import 'package:stock_managements/module/plant.dart';

class Plants {
  final List<Plant> plants;
  final int totalPlants;
  final int pageNumber;
  final int pageSize;


  Plants({this.plants, this.totalPlants, this.pageNumber,this.pageSize});

  Plants.fromMap(Map<String, dynamic> map)
      : plants = new List<Plant>.from(map['plants'].map((plant) => new Plant.fromMap(plant))),
        totalPlants = map['totalPlants'],
        pageNumber = map['pageNumber'],
        pageSize =map['pageSize'];

}