import 'package:ecommerceapp/models/payment_model.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';

class PaymentService
{

  static const String TOKEN = "9306488494";

  static deleteCash(userId) async
  {
    var response = await RequestHandler.DELETE_QUERY(ApiConstants.DELETE_CASH ,
    {
      "user_id" : userId,
      "token" : TOKEN
    });


    print("del cash response ${response.toString()}");

    if(response["status"]=="1")
    {
      return true;
    }
    else
      return false;

  }

//
//  static saveCheckout(userId , orderType , orderStatus , paymentId) async
//  {
//    var response = await RequestHandler.GET(ApiConstants.CHECKOUT ,
//        {
//          "user_id" : userId,
//          "token" : TOKEN,
//          "order_type" : orderType,
//          "order_status" : orderStatus,
//          "payment_id" : paymentId
//        });
//
//    if(response["status"]=="1")
//      return true;
//    else
//      return false;
//
//  }

  static getCoupon(userId , couponCode) async
  {
    var response = await RequestHandler.GET(ApiConstants.APPLY_COUPONS ,
        {
          "user_id" : userId,
          "token" : TOKEN,
          "coupon_code" : couponCode
        });


    if(response["status"]=="1" && response["data"]!=null && response["data"]!="null" )
      return response["data"][0]["coupon_value"];
    else
      return null;

  }

  static paymentHistory(userId) async
  {
    var resposne = await RequestHandler.GET(ApiConstants.PAYMENT_HISTORY , {
      "user_sr" : userId,
      "token" : TOKEN
    });

    if(resposne["status"] == "1")
      {
        List<PaymentModel> history = PaymentModel.fromJSONList(resposne["data"]);
        return history;
      }

  }

  static setPayment(userId , name , phone , email , productName , address , shipCharge , couponApplied , couponCode) async
  {
    var response = await RequestHandler.GET(ApiConstants.CASH_PAYMENT ,
        {
          "user_sr" : userId,
          "token" : TOKEN,
          "coupon_code" : couponCode,
          "product_name" : productName,
          "address" : address,
          "name" : name,
          "phone" : phone,
          "email" : email,
          "total_ship_charge" : shipCharge,
          "coupon_applied" : couponApplied
        });



    if(response["status"]=="1")
      return true;
    else
      return false;

  }



}