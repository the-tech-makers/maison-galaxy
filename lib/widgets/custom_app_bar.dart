// import 'package:flutter/material.dart';
// import 'package:minestipperstracking/screens/auth_screen.dart';

import 'package:flutter/material.dart';
import 'package:maison_galaxy/screens/auth_screen.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(
    this.title, {
    required Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        // style: TextStyle(color: Colors.black),
      ),
      // backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            // if (Platform.isAndroid) {
            //   SystemNavigator.pop();
            // } else if (Platform.isIOS) {
            //   exit(0);
            // }
          },
        )
      ],
    );
  }
}
