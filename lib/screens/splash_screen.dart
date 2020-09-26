import 'dart:async';

import 'package:ecommerceapp/screens/login_screen.dart';
import 'package:ecommerceapp/screens/main_screen.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer timer;

  @override
  void initState() {
    super.initState();

    timer = new Timer(new Duration(seconds: 3), () async {
     await getRole(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }

  Future<String> getRole(BuildContext context) async
  {
    bool role = await AuthService.isAuthenticated(context);

    if(role==false)
    {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen()));
    }
    else
    {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => MainScreen()));
    }

  }

}
