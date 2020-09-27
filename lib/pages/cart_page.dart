import 'dart:convert';

import 'package:ecommerceapp/models/cart_model.dart';
import 'package:ecommerceapp/widgets/navigation_drawer_elements.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
  double deliveryCharge = 0.0 , taxAmount = 0.0 , cartTotal = 0.0 , totalAmount=0.0 ;


  Razorpay _razorpay = Razorpay();


  List<int> quantityItemList = [];

  @override
  void initState() => {
    (() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId');
      if(!EmptyValidation.isEmpty(userId))
      {
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


            taxAmount = (2/100) * cartTotal;
            totalAmount = cartTotal + taxAmount + deliveryCharge;


            _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
            _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
            _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


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


  void checkout()
  {
    var options = {
      'key': 'rzp_test_KM39B5YUIlg8Iw',
      'amount': 11 * 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {
        'contact': '918171508475',
        'email': 'amanapp19@gmail.com'
      },
      "external" : {
        "wallets" :  ["paytm"]
      }
    };


    try{
      _razorpay.open(options);
    } catch(e)
    {}



  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Successfull" , backgroundColor: Colors.black , textColor: Colors.white);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment error :" + response.message , backgroundColor: Colors.black , textColor: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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
      body: (!isLoading) ? (cartList!=null) ? ListView(
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
          _buildTotalContainer()
        ],
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

                      if(result ==  "true")
                        {
                          cartList.removeAt(index);
                          quantityItemList.removeAt(index);

                          cartTotal = 0.0;
                          for(int i=0 ; i<cartList.length ; i++){
                            cartTotal = cartTotal + (quantityItemList[i] * double.parse(cartList[i].prod_price));
                          };
                          taxAmount = (2/100)*cartTotal;
                          totalAmount = cartTotal + taxAmount + deliveryCharge;


                          setState(() {
                          });
                        }
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
            onTap: (){
              if(quantityItemList[index] > 0)
                {
                  quantityItemList[index]--;

                  cartTotal = 0.0;
                  for(int i=0 ; i<cartList.length ; i++){
                    cartTotal = cartTotal + (quantityItemList[i] * double.parse(cartList[i].prod_price));
                  };
                  taxAmount = (2/100)*cartTotal;
                  totalAmount = cartTotal + taxAmount + deliveryCharge;


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

                cartTotal = 0.0;
                for(int i=0 ; i<cartList.length ; i++){
                  cartTotal = cartTotal + (quantityItemList[i] * double.parse(cartList[i].prod_price));
                };
                taxAmount = (2/100)*cartTotal;
                totalAmount = cartTotal + taxAmount + deliveryCharge;

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


  Widget _buildTotalContainer()
  {
    return Container(
      height: 240.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(left : 20.0 , right: 20 , top: 50),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Cart Total' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text(cartTotal.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Transaction Tax' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text(taxAmount.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Delivery Charge' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text( deliveryCharge.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
            ],
          ),
          Divider(height: 40.0 , color: Color(0xFFD3D3D3),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Sub Total' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text(totalAmount.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
            ],
          ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: (){
              checkout();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: Text('Proceed to Checkout',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),),
              ),
            ),
          )
        ],
      ),

    );
  }

}
