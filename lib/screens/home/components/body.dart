import 'package:flutter/material.dart';
import 'package:stock_managements/constants.dart';

import 'featurred_plants.dart';
import 'header_with_seachbox.dart';
import 'recomend_products.dart';
import 'title_with_more_bbtn.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It will provie us total height  and width of our screen
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small device
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWithSearchBox(size: size),
          TitleWithMoreBtn(title: "Products", press: () {}),
          RecomendsProducts(),
          TitleWithMoreBtn(title: "Save The Planet", press: () {}),
          FeaturedPlants(),
          SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
