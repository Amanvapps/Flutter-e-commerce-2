import 'package:ecommerceapp/models/product_model.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';

class WishlistService
{
  static const String TOKEN = "9306488494";

  static add(String userId, String prod_id, String quantity, String sale_price) async
  {
    var response = await RequestHandler.GET(ApiConstants.ADD_WISHLIST , {
      "user_id" : userId,
      "prod_id" : prod_id,
      "qty" : quantity,
      "price" : sale_price,
      "token" : TOKEN
    });

    if(response["status"]=="1")
    {
      return true;
    }
    else
      return false;
  }

  static getWishList(String userId)
  async {
    var res =  await RequestHandler.GET(ApiConstants.GET_WISHLIST , {
      "user_id" : userId,
      "token" : TOKEN
    });

    if(res["status"]=="1" && res["data"]!=null)
    {
      List<ProductModel> wishlist = ProductModel.fromJSONList(res["data"]);
      return wishlist;
    }
    else
      return null;
  }


  static deleteWishlist(String userId , String prodId) async
  {
    var response = await RequestHandler.DELETE_QUERY(ApiConstants.DELETE_WISHLIST , {
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



}