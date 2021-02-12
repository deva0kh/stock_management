import 'dart:async';
import 'dart:collection';

import 'package:stock_managements/cash/Cache.dart';
import 'package:stock_managements/management_dao.dart';
import 'package:stock_managements/module/Plants.dart';
import 'package:stock_managements/module/plant.dart';
import 'package:stock_managements/repository/PlantRepository.dart';

class CachingRepository extends PlantRepository {
  final int pageSize;
  final Cache<Plant> cache;
  final ManagementDao api = ManagementDao();

  final pagesInProgress = Set<int>();
  final pagesCompleted = Set<int>();
  final completers = HashMap<int, Set<Completer>>();

  int totalPlants;

  CachingRepository({this.pageSize, this.cache});

  @override
  Future<Plant> getPlant(int index) {
    final pageIndex = pageIndexFromPlantIndex(index);

    if (pagesCompleted.contains(pageIndex)) {
      return cache.get(index);
    } else {
      if (!pagesInProgress.contains(pageIndex)) {
        pagesInProgress.add(pageIndex);
        var future = api.getSavePlanetData(pageIndex, pageSize);
        future.asStream().listen(onData);
      }
      return buildFuture(index);
    }
  }

  Future<Plant> buildFuture(int index) {
    var completer = Completer<Plant>();

    if (completers[index] == null) {
      completers[index] = Set<Completer>();
    }
    completers[index].add(completer);

    return completer.future;
  }

  void onData(Plants plants) {
    if (plants != null) {
      totalPlants = plants.totalPlants;
      pagesInProgress.remove(plants.pageNumber);
      pagesCompleted.add(plants.pageNumber);

      for (int i = 0; i < pageSize; i++) {
        int index = plants.pageSize * plants.pageNumber + i;
        Plant plant = plants.plants[i];

        cache.put(index, plant);
        Set<Completer> comps = completers[index];

        if (comps != null) {
          for (var completer in comps) {
            completer.complete(plant);
          }
          comps.clear();
        }
      }
    } else {
      print("CachingRepository.onData(null)!!!");
    }
  }

  int pageIndexFromPlantIndex(int plantIndex) {
    return plantIndex ~/ pageSize;
  }
}