import 'dart:math';

import 'package:ecommerceapp/models/payment_model.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/services/payment_service.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:ecommerceapp/widgets/navigation_drawer_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionHistoryPage extends StatefulWidget {


  var mainCtx;
  var username;

  TransactionHistoryPage(this.mainCtx , this.username);

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {


 List<PaymentModel> historyList = [];
  bool isLoading = true;

  @override
  void initState() => {
    (() async {
      await getHistory();
    })()

  };

  getHistory() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');

    if(!EmptyValidation.isEmpty(userId))
    {
     historyList = await PaymentService.paymentHistory(userId);

      isLoading = false;
      setState(() {
      });
    }
    else
      {
        Fluttertoast.showToast(msg: "Session expired!" , textColor: Colors.white , backgroundColor: Colors.black);
        AuthService.logout(context);
      }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerElements.getDrawer("history", context, widget.mainCtx , widget.username),
      ),
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('  Payment History' , style: TextStyle(color: Colors.black),),
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
            child: (!isLoading) ? Container(
              margin: EdgeInsets.only(left: 5 , right: 5),
              child: (historyList!=null) ?  ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (BuildContext ctx , int index)
                  {
                    return HistoryListCard(historyList[index]);
                  }
              ) : Center(child: Text('No Items!' ,  style: TextStyle(fontSize: 20),)),
            )  : Center(
              child: Container(
                height: 600,
                child: Loader.getListLoader(context),
              ),
            )
        )
    );
  }

  Widget HistoryListCard( PaymentModel historyList)
  {
    var date = DateFormat('dd,MMM yyyy').format(DateTime.parse(historyList.date));


    return Container(
      padding: EdgeInsets.only(top: 26 , bottom: 26 , left: 6),
      margin: const EdgeInsets.only(left: 15 , right: 15 , top: 20 , bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Expanded(
           child: Container(
             alignment: Alignment.center,
             height: 70,
             width: 70,
             decoration: BoxDecoration(
               color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
               shape: BoxShape.circle
             ),
             child: Text("${(historyList.prod_name != null) ? historyList.prod_name.toString().substring(0 , 1) : "A"}" , style: TextStyle(fontSize: 30 , fontWeight: FontWeight.normal , color: Colors.white),),
           ),
         ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('${(historyList.prod_name != null) ? historyList.prod_name.toString() : ""}' , overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 20),)),
              SizedBox(height: 10,),
              Row(
                children: [
                  Container(
                    child: Text('Order Id : '),
                  ),
                  Container(
                    child: Text('${historyList.order_id}'),
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              children: [
                Text('\u{20B9} ${historyList.prod_price}' ,  style: TextStyle(fontSize: 20 , color: Colors.red),),
                SizedBox(height: 10,),
                Text('${date}')
              ],
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [BoxShadow(
          spreadRadius: 0.7,
          color: Colors.black54,
          blurRadius: 0,
          offset: Offset(0,0.5)
        )]
      ),
    );
  }
}
