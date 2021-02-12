import 'package:flutter/material.dart';
import 'package:stock_managements/cash/Cache.dart';
import 'package:stock_managements/cash/MemCache.dart';
import 'package:stock_managements/module/plant.dart';
import 'package:stock_managements/repository/CashingRepository.dart';

import '../../../constants.dart';

class FeaturedPlants extends StatelessWidget {
  static final Cache _cache = MemCache<Plant>();

  static final _repo = CachingRepository(pageSize: 10, cache: _cache);
  const FeaturedPlants({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    _repo.getPlant(0).asStream();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          children: <Widget>[
            _buildProductRow(_repo.getPlant(0)),
            FeaturePlantCard(
              image: "assets/images/bottom_img_1.png",
              press: () {},
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildProductRow(Future<Plant> plantFuture) {
    return new FutureBuilder<Plant>(
      future: plantFuture,
      builder: (BuildContext context, AsyncSnapshot<Plant> snapshot) {
        if (snapshot.hasData) {
          print(snapshot);
          return new FeaturePlantCard(
            image: snapshot.data.image,
          );
        } else {
          return new LinearProgressIndicator();
        }
      },
    );
  }
}

class FeaturePlantCard extends StatelessWidget {
  const FeaturePlantCard({
    Key key,
    this.image,
    this.press,
  }) : super(key: key);
  final String image;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width * 0.8,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }



}
