import 'dart:async';

import 'package:flutter/material.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  @override
  _OrderSuccessfulScreenState createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {

  double itemSize = 0;
  double opacity = 1;

  Duration animationDuration = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {

    Timer(Duration(milliseconds: 1), () {
      setState(() {
        itemSize = 150;
        opacity = 1;
      });
    });



    return Scaffold(
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text(''),
          actions : <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundColor: Colors.white,
//              child: Image.network("")),
                child: Image.asset("images/profile_default.png" , fit: BoxFit.fill,),
              ),)
          ]
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
              duration: animationDuration,
              opacity: opacity,
                child: AnimatedContainer(
                  duration: animationDuration,
                  width: itemSize,
                  height: itemSize,
                  child: Icon(Icons.done , color: Colors.white, size: 100,),
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text('Order Placed' , style: TextStyle(fontSize: 20),)
            ],
          ),
        ),
      ),
    );
  }
}
