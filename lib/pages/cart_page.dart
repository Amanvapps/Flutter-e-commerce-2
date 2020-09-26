import 'dart:convert';

import 'package:ecommerceapp/models/cart_model.dart';
import 'package:ecommerceapp/models/user_model.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/services/cart_service.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<CartModel> cartList = [];
  bool isLoading = true;


  List<int> quantityItemList = [];

  @override
  void initState() => {
    (() async {

      var userId = await AuthService.getUserId();
      print("userId--${userId.toString()}");
      if(!EmptyValidation.isEmpty(userId))
      {
        cartList = await CartService.getCartList(userId);

        if(cartList != null)
          {
            for(CartModel item in cartList)
            {
              quantityItemList.add(int.parse(item.quantity));
            }
          }

        isLoading = false;
        setState(() {
        });

      }
      else
        {
          AuthService.logout(context);
        }

    })()

  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
      ),
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('Shopping Cart' , style: TextStyle(color: Colors.black),),
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
      body: (!isLoading) ? (cartList!=null) ? ListView.builder(
          itemCount: cartList.length,
          itemBuilder: (BuildContext context , int index)
      {
        return itemCard(cartList[index] , index);
      }
      ) : Center(
        child: Text('No items added to cart' , style: TextStyle(fontSize: 20),),
      ) : Loader.getLoader(),
    );
  }

  Widget itemCard(CartModel cartItem , int index)
  {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          offset: Offset(0.2 , 0.3)
        )]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10 , right: 10 , top: 30),
              height: 100,
              width: 120,
              child: Image.network((!EmptyValidation.isEmpty(cartItem.image)) ? cartItem.image : "")),
          itemDetails(cartItem , index)
        ],
      ),
    );
  }

  itemDetails(CartModel cartItem , index)
  {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () async {
                      var result = await deleteDialog();

                      print(result);
                      if(result ==  "true")
                        {
                          cartList.removeAt(index);
                          quantityItemList.removeAt(index);
                          setState(() {
                          });
                        }
                    },
                    child: Icon(Icons.delete))),
            SizedBox(height: 1,),
            Text("\u{20B9} ${cartItem.prod_price}" , style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text(cartItem.prod_name),
            SizedBox(height: 20,),
            quantityButtons(cartItem , index)
          ],
        ),
      ),
    );
  }

  quantityButtons(cartItem , index)
  {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){
              if(quantityItemList[index] > 0)
                {
                  quantityItemList[index]--;
                  setState(() {
                  });
                }
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Icon(Icons.remove , color: Colors.white,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(quantityItemList[index].toString() , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
          ),
          GestureDetector(
            onTap: (){
              if(quantityItemList[index] < 5)
              {
                quantityItemList[index]++;
                setState(() {
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6)
              ),
              child: Icon(Icons.add ,  color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }

  deleteDialog() async
  {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Wanna Delete?'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context, "false"), // passing false
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, "true"), // passing true
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

}
