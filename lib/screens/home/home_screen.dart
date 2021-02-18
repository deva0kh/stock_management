import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stock_managements/components/my_bottom_nav_bar.dart';
import 'package:stock_managements/management_dao.dart';
import 'package:stock_managements/screens/home/components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
    );
  }
}
