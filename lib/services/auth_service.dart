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

  static Future<bool> login(String phone, String password) async {

    var response = await RequestHandler.POSTQUERY(ApiConstants.LOGIN, {
      'mobb': phone,
      'pass': password,
    });

    if(response["status"]=="1" && response["data"]!=null)
      {
        User user = User(response["data"][0]);
        await saveToken(user);
//        await setUserId(user);
        Fluttertoast.showToast(msg: "Login successfull !" , textColor: Colors.white , backgroundColor: Colors.black);
        return true;
      }
    Fluttertoast.showToast(msg: "Invalid Credentials !" , textColor: Colors.white , backgroundColor: Colors.black);
    return false;

  }

  static Future saveToken(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.user_id);
    await prefs.setString('userProfile', user.profile_image);
    await prefs.setInt('userProfile', user.wishlist_items);
    await prefs.setInt('userCart', user.cart_items);
    await prefs.setString('userRegDate', user.reg_date);
    await prefs.setString('userCity', user.city);
    await prefs.setString('userAddress', user.address);
    await prefs.setString('userEmailId', user.email_id);
    await prefs.setString('userMobile', user.mobile);
    await prefs.setString('userName', user.user_name);
    await prefs.setString('userLandmark', user.landmark);
    await prefs.setString('userPincode', user.pincode);
    await prefs.setString('userState', user.state);
  }

  static Future<bool> isAuthenticated(BuildContext context) async {
    String user = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('userId');

    if (user == "" || user == null) {
      return false;
    }
    return true;
  }

//  static Future setUserId(User user) async
//   {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userId', user.user_id);
//  }
//
//  static Future getUserId() async
//  {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String userId = prefs.getString('userId');
//    return userId;
//  }


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
    prefs.remove("userId");
    Fluttertoast.showToast(msg: "Logout Sucessfully");
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

  }


}