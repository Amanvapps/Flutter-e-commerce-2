import 'dart:convert';

import 'package:ecommerceapp/screens/login_screen.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../models/user_model.dart';

class AuthService
{
  static String getRole()
  {
    return "";
  }


  static Future<bool> login(String phone, String password) async {

    var response = await RequestHandler.POSTQUERY(ApiConstants.LOGIN, {
      'mobb': phone,
      'pass': password,
    });

    if(response["status"]=="1" && response["data"]!=null)
      {
        User user = User(response["data"][0]);
        await saveToken(user.toString());
        await setUserId(user);
        Fluttertoast.showToast(msg: "Login successfull !" , textColor: Colors.white , backgroundColor: Colors.black);
        return true;
      }
    Fluttertoast.showToast(msg: "Invalid Credentials !" , textColor: Colors.white , backgroundColor: Colors.black);
    return false;

  }

  static Future saveToken(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }

  static Future<bool> isAuthenticated(BuildContext context) async {
    String user = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user');
    print("token---- $user");

    if (user == "" || user == null) {
      return false;
    }
    return true;
  }

  static Future setUserId(User user) async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString('userId', user.user_id);
  }

  static Future getUserId() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');
    return userId;
  }


  static Future register(String username , String name , String city , String phone, String password , String state , String address , String pincode , String landmark) async {


    var response = await RequestHandler.POSTQUERY(ApiConstants.REGISTER, {
      'name': name,
      'mobb': phone,
      'email' : username,
      'pass' : password,
      'city' : city,
      'state' : state,
      'address' : address ,
      'pincode' : pincode,
      'landmark' : landmark
    });

    return response["data"];

  }

  static logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
    Fluttertoast.showToast(msg: "Logout Sucessfully");
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

  }


}