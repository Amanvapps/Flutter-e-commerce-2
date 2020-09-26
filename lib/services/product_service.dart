import 'package:ecommerceapp/models/product_model.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';

class ProductService
{
  static getProductList(catName , subCatName) async
  {
    var response = await RequestHandler.GET(ApiConstants.PRODUCTS , {
      "cat_name" : catName,
      "subcat_name" : subCatName
    });

    if(response["status"]=="1" && response["data"]!=null)
    {
      List<ProductModel> productList = ProductModel.fromJSONList(response["data"]);
      return productList;
    }
    else
      return null;

  }
}