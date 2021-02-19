import 'package:flutter/material.dart';
import 'package:stock_managements/cash/Cache.dart';
import 'package:stock_managements/cash/MemCache.dart';
import 'package:stock_managements/management_dao.dart';
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


            FutureBuilder(
             future: (new ManagementDao()).getSavePlanetData(1, 1),
              // ignore: missing_return
              builder: (BuildContext coontext,AsyncSnapshot snapshot){
              var data = snapshot.data;
              switch (snapshot.connectionState) {
              case ConnectionState.none:
              return new Text('Input a URL to start');
              case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
              case ConnectionState.active:
              return new Text('');
              case ConnectionState.done:
              if (snapshot.hasError) {
              return new Text(
              'no connection to the internet',
              style: TextStyle(color: Colors.red),
              );
              } else {
                List<Widget> plantList = new List<Widget>();
                for(var plant in data){
                  plantList.add(
                      FeaturePlantCard(
                      image: plant.image,
                      press: () {
                        showAlertDialog(context,plant.name);
                      },
                    ),
                  );
                }

            return new Row(children: plantList);
    }
    }
             }
            ),//*//

          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context,String name) {

    // set up the button
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {


        Navigator.of(context).pop();
      },

    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Info"),
      content: Text("This plant is commanly known as : " + name),
      actions: [

        cancelButton,

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
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
            image:  NetworkImage(image),
          ),
        ),
      ),
    );
  }



}
