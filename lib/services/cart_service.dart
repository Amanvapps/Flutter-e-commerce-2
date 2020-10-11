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


  static saveCart(String userId , String prodId , String quantity , String prodPrice) async
  {
    var response = await RequestHandler.GET(ApiConstants.ADD_CART , {
      "user_sr" : userId,
      "prod_id" : prodId,
      "qty" : quantity,
      "prod_price" : prodPrice,
      "token" : TOKEN
    });

    if(response["status"]=="1")
    {
      return true;
    }
    else
      return false;
  }


  static deleteCart(String userId , String prodId) async
  {
    var response = await RequestHandler.DELETE_QUERY(ApiConstants.DELETE_CART , {
      "user_id" : userId,
      "prod_id" : prodId,
      "token" : TOKEN
    });

    if(response["status"]=="1")
    {
      return true;
    }
    else
      return false;
  }

  static updateCart(String userId , data) async
  {
    var response = await RequestHandler.GET(ApiConstants.UPDATE_CART , {
      "user_id" : userId,
      "data" : data,
      "token" : TOKEN
    });

    if(response["status"]=="1")
    {
      return true;
    }
    else
      return false;
  }


}