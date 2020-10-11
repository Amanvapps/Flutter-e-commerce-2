import 'dart:convert';

import 'package:ecommerceapp/models/cart_model.dart';
import 'package:ecommerceapp/screens/updated_cart_screen.dart';
import 'package:ecommerceapp/services/payment_service.dart';
import 'package:ecommerceapp/widgets/navigation_drawer_elements.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/services/cart_service.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {

  var mainCtx;
  var username;

  CartPage(this.mainCtx , this.username);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<CartModel> cartList = [];
  bool isLoading = true;
  bool isDeletingCart = false;
  double deliveryCharge = 0.0 , cartTotal = 0.0 , totalAmount=0.0 ;




  List<int> quantityItemList = [];

  @override
  void initState() => {
    (() async {

     await getCart();

        isLoading = false;
        setState(() {
        });


    })()

  };


getCart() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId');
  if(!EmptyValidation.isEmpty(userId))
  {


    deliveryCharge=0.0;
    cartTotal = 0.0;
    totalAmount = 0.0;

    if(quantityItemList.length>0)
      quantityItemList.clear();

    if(cartList.length>0)
      cartList.clear();


    cartList = await CartService.getCartList(userId);

    if(cartList != null)
    {

      for(CartModel item in cartList)
      {
        quantityItemList.add(int.parse(item.quantity));
      }

      cartList.forEach((element) {
        cartTotal = cartTotal + (int.parse(element.quantity) * int.parse(element.prod_price));
      });


      totalAmount = cartTotal + deliveryCharge;



    }

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
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: DrawerElements.getDrawer("cart_page", context, widget.mainCtx , widget.username),
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
      body: (!isLoading) ? (cartList!=null) ? Stack(
        children: [
          ListView(
            children: [
              ListView.builder(
                  itemCount: cartList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context , int index)
              {
                return itemCard(cartList[index] , index);
              }
              ),
            _selectPaymentType()
            ],
          ),
          (!isDeletingCart) ? Container(): Center(
            child: SpinKitCircle(
              size: 125,
              color: Colors.red,
            ),
          ),
        ],
      ) : Center(
        child: Text('Empty Cart :(' , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
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

                      isDeletingCart = true;
                      setState(() {
                      });


                      if(result ==  "true") {

                        var res = await deleteCart(cartItem);

                        if (res == true) {
                          isLoading = true;
                          setState(() {});

                          await getCart();
                          Fluttertoast.showToast(msg: "Deleted");
                        }
                        else {
                          Fluttertoast.showToast(msg: "Delete Failed!");
                        }


                      }

                      isDeletingCart = false;
                      setState(() {});


                    },
                    child: Icon(Icons.delete))),
            SizedBox(height: 1,),
            Text("\u{20B9} ${cartItem.prod_price}" , style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text((!EmptyValidation.isEmpty(cartItem.prod_name)) ? cartItem.prod_name : ""),
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
            onTap: () async {
              if(quantityItemList[index] > 1)
                {
                  quantityItemList[index]--;

                  cartTotal = 0.0;
                  for(int i=0 ; i<cartList.length ; i++){
                    cartTotal = cartTotal + (quantityItemList[i] * double.parse(cartList[i].prod_price));
                  };

                  totalAmount = cartTotal + deliveryCharge;


                  setState(() {
                  });
                }
              else if(quantityItemList[index] == 1)
                {


                  // if 0 then delete from cart

                  var result = await deleteDialog();

                  isDeletingCart = true;
                  setState(() {
                  });


                  if(result ==  "true") {

                    var res = await deleteCart(cartItem);

                    if (res == true) {
                      isLoading = true;
                      setState(() {});

                      await getCart();
                      Fluttertoast.showToast(msg: "Deleted");
                    }
                    else {
                      Fluttertoast.showToast(msg: "Delete Failed!");
                    }


                  }
                  else
                    {
                      quantityItemList[index] = 1;

                      cartTotal = 0.0;
                      for(int i=0 ; i<cartList.length ; i++){
                        cartTotal = cartTotal + (quantityItemList[i] * double.parse(cartList[i].prod_price));
                      };

                      totalAmount = cartTotal + deliveryCharge;


                      setState(() {
                      });
                    }

                  isDeletingCart = false;
                  setState(() {});

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

                cartTotal = 0.0;
                for(int i=0 ; i<cartList.length ; i++){
                  cartTotal = cartTotal + (quantityItemList[i] * double.parse(cartList[i].prod_price));
                };

                totalAmount = cartTotal + deliveryCharge;

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



  Future<bool> deleteCart(CartModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');

    bool res = await CartService.deleteCart(userId, cartItem.prod_id);
    return res;
  }

  _selectPaymentType()
  {
    return  Container(
      margin: EdgeInsets.only(left : 10.0 , right: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              var res = await showDeleteCashItemsAlert();

              if(res == "true")
              {
                isDeletingCart = true;
                setState(() {
                });

              updateCart();

              }

            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(left : 20.0 , right: 20 , top: 50),
              height: 50.0,
              decoration: BoxDecoration(
                  border: Border.all(color : Colors.blue),
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: Text('Cash On Delivery',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {



              isDeletingCart = true;
              setState(() {
              });

              //save all objects to cart(update cart api....)
              payOnline();




            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(left : 20.0 , right: 20 , top: 20),
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: Text('Pay Online',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),),
              ),
            ),
          ),

        ],
      ),
    );
  }

  showDeleteCashItemsAlert() async
  {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Some items don\'t support cash on delivery, do you want to remove those items from cart?' , style: TextStyle(color: Colors.black),),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context, "false"), // passing false
                  child: Text('Cancel'),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(context, "true"), // passing true
                  child: Text('Proceed'),
                ),
              ],
            );
          });
  }

   updateCart() async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String userId = prefs.getString('userId');
     if(!EmptyValidation.isEmpty(userId))
     {
       Fluttertoast.showToast(msg: "Loading for payment..." , textColor: Colors.white , backgroundColor: Colors.black);

       List updatedCartList = [];

       for(int i=0 ; i<cartList.length ; i++) {



         var product = {
           "user_id" : userId.toString(),
           "prod_sr" : cartList[i].prod_id.toString(),
           "qty" : quantityItemList[i].toString(),
           "sale_price" : cartList[i].prod_price.toString(),
         };



         updatedCartList.add(product);
       }


       bool res = await CartService.updateCart(userId, json.encode(updatedCartList));

       if(res == true)
         {
          deleteCash(userId );
         }
       else
         {
           isDeletingCart = false;
           setState(() {
           });
           Fluttertoast.showToast(msg: "Error occurred !" , textColor: Colors.white , backgroundColor: Colors.black);
         }



     }
     else
       AuthService.logout(context);
   }

   deleteCash(String userId) async
   {

     bool response = await PaymentService.deleteCash(userId);
     if(response == true)
     {

       //for getting cart and refresh quantity list
       cartList = await CartService.getCartList(userId);

       if(cartList != null)
       {

         for(CartModel item in cartList)
         {
           quantityItemList.add(int.parse(item.quantity));
         }

       }

       isDeletingCart = false;
       setState(() {
       });


       Fluttertoast.showToast(msg: "Cart updated!" , textColor: Colors.white , backgroundColor: Colors.black);
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => UpdatedCartScreen("cod")),
       );
     }
     else
       {
         isDeletingCart = false;
         setState(() {
         });
         Fluttertoast.showToast(msg: "Error occurred !" , textColor: Colors.white , backgroundColor: Colors.black);
       }
   }

   payOnline() async {

       SharedPreferences prefs = await SharedPreferences.getInstance();
       String userId = prefs.getString('userId');
       if(!EmptyValidation.isEmpty(userId))
       {
         Fluttertoast.showToast(msg: "Loading for payment..." , textColor: Colors.white , backgroundColor: Colors.black);

         List updatedCartList = [];

         for(int i=0 ; i<cartList.length ; i++) {



           var product = {
             "user_id" : userId.toString(),
             "prod_sr" : cartList[i].prod_id.toString(),
             "qty" : quantityItemList[i].toString(),
             "sale_price" : cartList[i].prod_price.toString(),
           };



           updatedCartList.add(product);
         }


         bool res = await CartService.updateCart(userId, json.encode(updatedCartList));

         if(res == true)
         {

           cartList = await CartService.getCartList(userId);

           if(cartList != null)
           {

             for(CartModel item in cartList)
             {
               quantityItemList.add(int.parse(item.quantity));
             }

           }

           isDeletingCart = false;
           setState(() {
           });



           await Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => UpdatedCartScreen("online")),
           );



         }
         else
         {
           isDeletingCart = false;
           setState(() {
           });
           Fluttertoast.showToast(msg: "Error occurred !" , textColor: Colors.white , backgroundColor: Colors.black);
         }



       }
       else
         AuthService.logout(context);
     }


}
