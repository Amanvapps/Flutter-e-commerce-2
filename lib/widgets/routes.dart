import 'package:ecommerceapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class Routes {

  static List<dynamic> getUserRoutes(var context, var pageName, var mainCtx) {
    var settingsTab = ListTile(
      title: Text("Profile"),
      leading: Icon(Icons.person),
      onTap: () {
        if (pageName != ("settings")) {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(mainCtx)),
          );
        }
      },
    );


    return [
      settingsTab
    ];
  }
}

