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


  static saveCheckout(userId , orderType , orderStatus , paymentId) async
  {
    var response = await RequestHandler.GET(ApiConstants.CHECKOUT ,
        {
          "user_id" : userId,
          "token" : TOKEN,
          "order_type" : orderType,
          "order_status" : orderStatus,
          "payment_id" : paymentId
        });

    if(response["status"]=="1")
      return true;
    else
      return false;

  }


}