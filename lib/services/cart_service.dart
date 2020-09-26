import 'package:ecommerceapp/models/cart_model.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';

class CartService
{

  static const String TOKEN = "9306488494";

  static getCartList(String userId) async
  {

    var res =  await RequestHandler.GET(ApiConstants.GET_CART , {
      "user_sr" : userId,
      "token" : TOKEN
    });

    if(res["status"]=="1" && res["data"]!=null)
    {
      List<CartModel> cartList = CartModel.fromJSONList(res["data"]);
      return cartList;
    }
    else
      return null;
  }




}