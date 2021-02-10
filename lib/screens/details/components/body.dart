import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stock_managements/constants.dart';
import 'package:stock_managements/management_dao.dart';

import 'image_and_icons.dart';
import 'title_and_price.dart';

class Body extends StatelessWidget {
  final int recordId;//if you have multiple values add here
  Body(this.recordId, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child:
        FutureBuilder(
          future: (new ManagementDao()).getProduct(recordId),
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

      return  Column(
        children: <Widget>[
          ImageAndIcons(size: size*0.9,recordId : recordId,image: data.image,),
          TitleAndPrice(title: data.name, country: "Morocco", price: data.price),
          SizedBox(height: kDefaultPadding),
          Row(
            children: <Widget>[
              SizedBox(
                width: size.width / 2,
                height: 84,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                  ),
                  color: Colors.lightBlue,
                  onPressed: () {

                    showAlertDialog(context,data.id);

                  },
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {},
                  child: Text("Description"),
                ),
              ),
            ],
          ),
        ],
      );

    }
    }
    }
    )
    )
    );
  }
  showAlertDialog(BuildContext context,int id) {

    // set up the buttons
    Widget confirmButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () {
        (new ManagementDao()).updatePQty(id);
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Your Purchase is validated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {

        Fluttertoast.showToast(
            msg: "Your Purchase is validated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );
        Navigator.of(context).pop();
      },

    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confimation"),
      content: Text("Do you really want to purchase this product?"),
      actions: [
        confirmButton,
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
