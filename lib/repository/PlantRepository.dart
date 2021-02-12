import 'package:stock_managements/module/plant.dart';

abstract class PlantRepository {
  Future<Plant> getPlant(int index);
}