import 'package:ecommerceapp/models/cart_model.dart';
import 'package:ecommerceapp/screens/online_payment_webview.dart';
import 'package:ecommerceapp/screens/order_successful_screen.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/services/cart_service.dart';
import 'package:ecommerceapp/services/payment_service.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatedCartScreen extends StatefulWidget {

  var paymentMode;

  UpdatedCartScreen(this.paymentMode);

  @override
  _UpdatedCartScreenState createState() => _UpdatedCartScreenState();
}

class _UpdatedCartScreenState extends State<UpdatedCartScreen> {


  List<CartModel> cartList = [];
  bool isLoading = true;
  bool isDeletingCart = false;
  double deliveryCharge = 0.0 , cartTotal = 0.0 , totalAmount=0.0 , couponDiscount=0.0 ;

  var name , address , email , phone;
  bool isCouponApplied = false;

  TextEditingController couponController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();




  @override
  void initState() => {
    (() async {


      SharedPreferences prefs = await SharedPreferences.getInstance();

      name = prefs.getString('userName');

      email = prefs.getString('userEmailId');

      address = prefs.getString('userAddress');

      phone = prefs.getString('userMobile');

      nameController.text = name;
      emailController.text = email;
      addressController.text = address;
      phoneController.text = phone;

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
//      taxAmount = 0.0;
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



  getCoupon(userId , couponCode) async
  {
    Fluttertoast.showToast(msg: "Applying coupon...");
    
    isDeletingCart = true;
    setState(() {
    });
    
    var res = await PaymentService.getCoupon(userId, couponCode);

    if(res!=null)
      {

        couponDiscount =  double.parse(res);
        totalAmount = totalAmount - couponDiscount;
      }
    else
      {
        isCouponApplied = false;
        Fluttertoast.showToast(msg: "Invalid Coupon!");
      }

    
    isDeletingCart = false;
    setState(() {
    });
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text('Contact Info' , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),)),
                  GestureDetector(
                    onTap: () async {
                     await profileDialog();
                      setState(() {
                      });

                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 50),
                        child: Icon(Icons.edit)),
                  )
                ],
              ),
              _buildInfoContainer(),
              SizedBox(height: 10,),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text('Discounts' , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),)),
              _buildDiscountContainer(),
              SizedBox(height: 20,),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text('Order Summary' , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),)),
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
      margin: const EdgeInsets.all(8),
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
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(left : 20.0 , right: 20 , top: 30 , bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Cart Total' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text(cartTotal.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
            ],
          ),
//          SizedBox(height: 10.0,),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text('Transaction Tax' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
//              Text(taxAmount.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
//            ],
//          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Delivery Charge' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text( deliveryCharge.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Coupon Discount' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text( couponDiscount.toString() , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
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
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentWebview(isCouponApplied , couponController.text , totalAmount.toString() , name , phone , email , deliveryCharge ,  address)),
                );
              }
              else
                {
                  //call cod api and move to thanks screen.....


                  payCod();

                }
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

  _buildDiscountContainer()
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(left : 0.0 , right: 20 , top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(3),
              child: TextField(
                controller: couponController,
                decoration: InputDecoration(
                    hintText: "Coupon code",
                    border: InputBorder.none
                ),
              ),
              margin: const EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6)
              ),
            ),
          ),
          Container(
            height: 40,
            width: 100,
            margin: const EdgeInsets.only(left: 10 , right: 10),
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.red
            ),
            child: Column(
              children: [
                (!isCouponApplied) ? GestureDetector(
                    onTap: () async {
                      if(couponController.text!="")
                        {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String userId = prefs.getString('userId');
                        if(!EmptyValidation.isEmpty(userId))
                        {
                          isCouponApplied = true;
                          getCoupon(userId, couponController.text);
                        }
                        else
                          {
                            isCouponApplied = false;

                            Fluttertoast.showToast(msg: "Session expired!" , backgroundColor: Colors.black , textColor: Colors.white);
                            AuthService.logout(context);
                          }

                        }


                    },
                    child: FittedBox(child: Text('Apply' , style: TextStyle(fontSize : 18 , color: Colors.white),))) : Container(),

                (isCouponApplied) ? GestureDetector(
                    onTap: () async {
                      isCouponApplied = false;
                      totalAmount = totalAmount + couponDiscount;
                      couponDiscount = 0;
                      couponController.text = "";

                      setState(() {
                      });
                    },
                    child: FittedBox(child: Text('Remove' , style: TextStyle(fontSize : 18 , color: Colors.white),))) : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildInfoContainer()
  {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Name : ' , style: TextStyle(fontSize : 16)),
              Text(name , style: TextStyle(fontSize : 17 , color: Colors.grey),)
            ],
          ),
          SizedBox(height :10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Email : ' , style: TextStyle(fontSize : 16)),
              Text(email , style: TextStyle(fontSize : 17 , color: Colors.grey),)
            ],
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(left : 10.0 , right: 20 , top: 10),
    );
  }

  profileDialog() async
  {



    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Set Details'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return  Container(
                  height: MediaQuery.of(context).size.height/2.5,
                  width: 500,
                  child: ListView(
                    shrinkWrap: true,
//                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            border: new OutlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text('Email' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            border: new OutlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text('Address' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                            hintText: 'Address',
                            border: new OutlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text('Mobile' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            hintText: 'Ph no.',
                            border: new OutlineInputBorder()
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
              new FlatButton(
                  child: new Text('Done'),
                  onPressed: () {

                    if(phoneController.text != "" && emailController.text != "" && nameController.text !="" && addressController.text!="")
                    {
                      name = nameController.text;
                      email = emailController.text;
                      address = addressController.text;
                      phone = phoneController.text;

                      Navigator.pop(context , "done");
                    }
                    else
                      {
                        Fluttertoast.showToast(msg: "Empty Fields!");
                      }
                   
                  }
              )
            ],
          );
        });
  }

   payCod() async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String userId = prefs.getString('userId');
     if(!EmptyValidation.isEmpty(userId))
     {

       isDeletingCart = true;
       setState(() {
       });

       var res;

       if(isCouponApplied == true)
         res = await PaymentService.setPayment(userId , nameController.text , phoneController.text , emailController.text , "XYZ COD" , addressController.text ,  deliveryCharge.toString() , 1 , couponController.text);
       else
         res = await PaymentService.setPayment(userId , nameController.text , phoneController.text , emailController.text , "XYZ COD" , addressController.text ,  deliveryCharge.toString() , 0 , " ");


       if(res == true)
         {
           Fluttertoast.showToast(msg: "Payment Successful" , backgroundColor: Colors.black , textColor: Colors.white);
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => OrderSuccessfulScreen()),
           );
         }
       else
         Fluttertoast.showToast(msg: "Payment Failed!" , backgroundColor: Colors.black , textColor: Colors.white);

       isDeletingCart = false;
       setState(() {
       });

     }
     else
       {
         AuthService.logout(context);
       }
   }

}
