import 'package:ecommerceapp/models/cart_model.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/services/cart_service.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatedCartScreen extends StatefulWidget {

  var paymentMode;

  UpdatedCartScreen(this.paymentMode);

  @override
  _UpdatedCartScreenState createState() => _UpdatedCartScreenState();
}

class _UpdatedCartScreenState extends State<UpdatedCartScreen> {


  Razorpay _razorpay = Razorpay();

  List<CartModel> cartList = [];
  bool isLoading = true;
  bool isDeletingCart = false;
  double deliveryCharge = 0.0 , taxAmount = 0.0 , cartTotal = 0.0 , totalAmount=0.0 ;



  void checkout()
  {
    var options = {
      'key': 'rzp_live_zo0oXKAv5gykEf',
      'amount': 11 * 100,
      'name': 'My delivery',
      'description': 'Products',
//      'prefill': {
//        'contact': '918171508475',
//        'email': 'amanapp19@gmail.com'
//      },
      "external" : {
        "wallets" :  ["paytm" , "phonepe"]
      }
    };


    try{
      _razorpay.open(options);
    } catch(e)
    {}



  }


  @override
  void initState() => {
    (() async {


      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      await getCart();

      isLoading = false;
      setState(() {
      });




    })()

  };


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  getCart() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');
    if(!EmptyValidation.isEmpty(userId))
    {


      deliveryCharge=0.0;
      taxAmount = 0.0;
      cartTotal = 0.0;
      totalAmount = 0.0;


      cartList = await CartService.getCartList(userId);

      if(cartList != null)
      {


        cartList.forEach((element) {

          if(!EmptyValidation.isEmpty(element.ship_charge))
          deliveryCharge = deliveryCharge + (int.parse(element.quantity) * int.parse(element.ship_charge));

          cartTotal = cartTotal + (int.parse(element.quantity) * int.parse(element.prod_price));
        });


        taxAmount = (2/100) * cartTotal;
        totalAmount = cartTotal + taxAmount + deliveryCharge;



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


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("done");
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
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('  Payment' , style: TextStyle(color: Colors.black),),
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
        child: (!isLoading) ? (cartList!=null) ? Stack(
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
              _buildTotalContainer()
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
      ),
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
        padding: EdgeInsets.all(6),
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1,),
            Text("\u{20B9} ${cartItem.prod_price}" , style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text((!EmptyValidation.isEmpty(cartItem.prod_name)) ? cartItem.prod_name : ""),
            SizedBox(height: 15,),
            Row(
              children: [
                Text('Quantity : ' , style: TextStyle(fontWeight: FontWeight.bold),),
                Text((!EmptyValidation.isEmpty(cartItem.quantity)) ?  cartItem.quantity : ""),
              ],
            ),
            SizedBox(height: 5,),

          ],
        ),
      ),
    );
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
              if(widget.paymentMode == "online")
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
