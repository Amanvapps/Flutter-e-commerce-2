import 'dart:io';

import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaymentWebview extends StatefulWidget {

  bool isCouponApplied;
  var couponCode , productPrice , name , phone , email , shipCharge , address;

  PaymentWebview(this.isCouponApplied , this.couponCode , this.productPrice , this.name
      , this.phone , this.email , this.shipCharge , this.address);


  @override
  _PaymentWebviewState createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {

  bool isLoading = true;
  String paymentUrl;



  @override
  void initState() => {
    (() async {

      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

      await getPaymentURL();

      isLoading = false;
      setState(() {
      });




    })()

  };


  getPaymentURL() async
  {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString('userId');
    String webhook = prefs.getString('webhook');
    String pageDirected = prefs.getString('pageDirected');
    String apiKey = prefs.getString('apiKey');
    String apiToken = prefs.getString('apiToken');

    int applied;

    if(widget.isCouponApplied == true)
      {
        applied = 1;
      }
    else
      applied = 0;

    if(!EmptyValidation.isEmpty(userId))
      {
        var params = {
          "token" : "9306488494",
          "api_token" : apiToken,
          "redirect" : pageDirected,
          "webhook" : webhook,
          "coupon_applied" : applied,

          if(widget.isCouponApplied)
          "coupon_code" : widget.couponCode,

          "product_name" : "aman.e.ecommerceapp",
          "product_price" : widget.productPrice,
          "name" : widget.name,
          "phone" : widget.phone,
          "email" : widget.email,
          "user_id" : userId,
          "total_ship_charge" : widget.shipCharge,
          "api_key" : apiKey
        };

        paymentUrl = ApiConstants.URL + ApiConstants.PAYMENT + "?" + RequestHandler.encodeQuery(params);

        isLoading = false;
        setState(() {
        });

      }
    else
      {
        AuthService.logout(context);
      }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('  Checkout' , style: TextStyle(color: Colors.black),),
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
      body: SafeArea(
        child: (isLoading) ? Loader.getLoader() : WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: paymentUrl,
        ),
      ),
    );
  }

}
