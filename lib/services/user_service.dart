import 'package:ecommerceapp/models/user_model.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';

class UserService
{

  static const String TOKEN = "9306488494";

  static getProfile(userId) async
  {
    var res = await RequestHandler.GET(ApiConstants.USER_PROFILE , {
      "user_sr" : userId,
      "token" : TOKEN
    });

    if(res["status"]=="1" && res["data"]!=null)
    {
      User user = User(res["data"][0]);
      return user;
    }
    else
      return null;
  }
}