import 'package:ecommerceapp/models/cart_model.dart';
import 'package:ecommerceapp/models/product_model.dart';
import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/screens/online_payment_webview.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/services/cart_service.dart';
import 'package:ecommerceapp/services/payment_service.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyScreen extends StatefulWidget {

  var mainCtx;
 ProductModel productItem;
 int quantity;
 var username;

  BuyScreen(this.mainCtx , this.productItem , this.quantity , this.username);

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {

  double discountPercentage , deliveryCharge ,  totalAmount=0.0 , couponDiscount=0.0;
  var name , address , email , phone;
  bool isCouponApplied = false;

  TextEditingController couponController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isDeletingCart = false;
  bool isLoading = true;



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


      discountPercentage = ((double.parse(widget.productItem.real_price) - double.parse(widget.productItem.sale_price))/double.parse(widget.productItem.real_price)) * 100;
      deliveryCharge = double.parse(widget.productItem.ship_charge) * widget.quantity;

      totalAmount = (double.parse(widget.productItem.sale_price) * widget.quantity) + deliveryCharge;


      isLoading = false;
      setState(() {
      });




    })()

  };



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
          title: Text('  Purchase' , style: TextStyle(color: Colors.black),),
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
      body: Stack(
        children: [
          ListView(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 30 , top: 10),
                  child: Icon(Icons.favorite , size: 30, color: Colors.red,),
                ),
              ),

              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: 200,
                    child: Image.network(widget.productItem.prod_image),
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.only(top: 5 , right: 40),
                          height: 70,
                          child: Image.asset("images/price_tag.png"),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              margin: const EdgeInsets.only(top: 35 , right: 52),
                              child: Text('${discountPercentage.toInt()}% off' , style: TextStyle(fontSize: 16 , color: Colors.white),)))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                margin: const EdgeInsets.all(15),
                                child: Text('${widget.productItem.prod_name}' , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.w500),))),
                      ),
                      SizedBox(width: 20,),
                      Container(
                        margin: const EdgeInsets.all(15),
                          child: Text("\u{20B9}${widget.productItem.sale_price}" ,  style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: const EdgeInsets.all(15),
                          child: Text('Highlights' , style: TextStyle(fontSize: 20 , color: Colors.deepPurple),))),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description   ' , style: TextStyle(fontSize: 18)),
                            Expanded(child: Text(widget.productItem.prod_desc , style: TextStyle(fontSize: 18 , color: Colors.black54)))
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity   ' , style: TextStyle(fontSize: 18)),
                            Expanded(child: Text('${widget.quantity}' , style: TextStyle(fontSize: 18 , color: Colors.black54)))
                          ],
                        )
                      ],
                    ),
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
                  SizedBox(height: 10,),
                  _buildInfoContainer(),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text('Discounts' , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),)),
                  ),
                  _buildDiscountContainer(),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Text('Summary' ,  style: TextStyle(fontSize: 18 , color: Colors.black)),
                    ),
                  ),
                  SizedBox(height: 10,),
                  _buildTotalContainer(),
                  SizedBox(height: 20,),
                  actionButtons()
                ],
              ),
            ],
          ),
          (!isDeletingCart) ? Container(): Center(
            child: SpinKitCircle(
              size: 125,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  actionButtons() 
  {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                print(widget.productItem.cod_mode);

                if(int.parse(widget.productItem.cod_mode) == 1 )
                  {
                    Fluttertoast.showToast(msg: "This item is only available in online payment mode!" , textColor: Colors.white , backgroundColor: Colors.black);
                  }
                else
                  {
                    isDeletingCart = true;
                    setState(() {


                      payCash();

                    });
                  }
              },
              child: Container(
                height: 70,
                color: Colors.grey[300],
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Text('Pay Cash' , style: TextStyle(color: Colors.black , fontSize: 20),),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                payOnline();
              },
              child: Container(
                height: 70,
                color: Colors.red,
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Text('Pay Online' , style: TextStyle(color: Colors.white , fontSize: 20),),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTotalContainer()
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(left : 20.0 , right: 20 , top: 0 , bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Cart Total' , style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.grey),),
              Text((double.parse(widget.productItem.sale_price) * widget.quantity).toString(), style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.black),),
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

   payCash() async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String userId = prefs.getString('userId');
     if(!EmptyValidation.isEmpty(userId))
       {


        List<CartModel> cartList = await CartService.getCartList(userId);

        if(cartList==null)
          {

            //add to cart...
            bool result = await updateCart(userId);

            if(result == true)
            {
              bool res;

              if(isCouponApplied == true)
              {

                res = await PaymentService.setPayment(userId , nameController.text , phoneController.text , emailController.text , widget.productItem.prod_name , addressController.text ,  deliveryCharge.toString() , 1 , couponController.text);

              }
              else
              {
                res = await PaymentService.setPayment(userId , nameController.text , phoneController.text , emailController.text , widget.productItem.prod_name , addressController.text ,  deliveryCharge.toString() , 0 , " ");
              }

              if(res == true)
                Fluttertoast.showToast(msg: "Payment Successful" , backgroundColor: Colors.black , textColor: Colors.white);
              else
                Fluttertoast.showToast(msg: "Payment Failed!" , backgroundColor: Colors.black , textColor: Colors.white);

            }
            else
            {
              Fluttertoast.showToast(msg: "Not added to cart!" , textColor: Colors.white , backgroundColor: Colors.black);
            }



          }
        else
          {
            if(cartList.length>0)
            {
              //add to cart and take to cart page...


              bool result = await updateCart(userId);

              if(result == true)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage(widget.mainCtx, widget.username)),
                );
              }
              else
              {
                Fluttertoast.showToast(msg: "Not added to cart!" , textColor: Colors.white , backgroundColor: Colors.black);
              }


            }
          }


         isDeletingCart = false;
         setState(() {
         });

       }
     else
       {
         AuthService.logout(context);
       }
   }

  Future<bool> updateCart(userID) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId');

      if(!EmptyValidation.isEmpty(userId))
      {

        bool res = await CartService.saveCart(userId, widget.productItem.prod_id, widget.quantity.toString(), widget.productItem.sale_price);

        return res;

      }

  }

   payOnline() async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String userId = prefs.getString('userId');

     if(!EmptyValidation.isEmpty(userId))
     {

       isDeletingCart = true;
       setState(() {
       });

       List<CartModel> cartList = await CartService.getCartList(userId);

       if(cartList==null)
       {
         bool result = await updateCart(userId);

         if(result == true)
         {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => PaymentWebview(isCouponApplied , couponController.text , totalAmount.toString() , name , phone , email , deliveryCharge ,  address)),
           );
         }
         else
           {
             Fluttertoast.showToast(msg: "Not added to cart!" , textColor: Colors.white , backgroundColor: Colors.black);
           }

       }
       else
       {
         if(cartList.length>0)
         {
           //add to cart and take to cart page...


           bool result = await updateCart(userId);

           if(result == true)
           {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => CartPage(widget.mainCtx, widget.username)),
             );
           }
           else
           {
             Fluttertoast.showToast(msg: "Not added to cart!" , textColor: Colors.white , backgroundColor: Colors.black);
           }


         }
       }

     }
     else
       {
         AuthService.logout(context);
         Fluttertoast.showToast(msg: "Session expired!" , backgroundColor: Colors.black , textColor: Colors.white);
       }

     isDeletingCart = false;
     setState(() {
     });

   }


}
