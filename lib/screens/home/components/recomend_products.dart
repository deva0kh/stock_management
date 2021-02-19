import 'package:flutter/material.dart';
import 'package:stock_managements/management_dao.dart';
import 'package:stock_managements/screens/details/details_screen.dart';

import '../../../constants.dart';

class RecomendsProducts extends StatelessWidget {
  const RecomendsProducts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          FutureBuilder(
      future: (new ManagementDao()).getAll(),
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
        print(data[0].id);
          List<Widget> list = new List<Widget>();
          for(var record in data){
            list.add(
              RecomendPlantCard(
                image:record.image,
                title: record.name,
                country: 'Morocco',
                price: record.price,
                press: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(record.id),
                    ),
                  );
                },
              )
            );
          }
             return new Row(children: list);
      }}}
          ),

        ],
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
    Key key,
    this.image,
    this.title,
    this.country,
    this.price,
    this.press,
  }) : super(key: key);

  final String image, title, country;
  final double price;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      width: 200,
      child: Column(
        children: <Widget>[
          Image.network(image,height: 150),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: "$country".toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\DH $price',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: kPrimaryColor),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
