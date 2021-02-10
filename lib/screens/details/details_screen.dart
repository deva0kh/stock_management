import 'package:flutter/material.dart';
import 'package:stock_managements/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {

  final int recordId;//if you have multiple values add here
  DetailsScreen(this.recordId, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    print(recordId);
    return Scaffold(
      body: Body(recordId),
    );
  }
}
