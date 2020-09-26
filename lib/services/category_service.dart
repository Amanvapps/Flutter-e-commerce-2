import 'package:ecommerceapp/models/main_category_model.dart';
import 'package:ecommerceapp/models/sub_categories_model.dart';
import 'package:ecommerceapp/utils/ApiConstants.dart';
import 'package:ecommerceapp/utils/requestHandler.dart';

class CategoryService
{
  static getCategoryList() async
  {
    var response = await RequestHandler.GET(ApiConstants.CATEGORIES);
    if(response["status"]=="1" && response["data"]!=null)
    {
      List<MainCategories> mainCategoryList = MainCategories.fromJSONList(response["data"]);
      return mainCategoryList;
    }
    else
      return null;

  }

  static getSubCategoryList(category) async
  {
    var response = await RequestHandler.GET(ApiConstants.SUB_CATEGORIES , {
      "cat_name" : category
    });

    if(response["status"]=="1" && response["data"]!=null)
    {
      List<SubCategoriesModel> subCategoryList = SubCategoriesModel.fromJSONList(response["data"]);
      return subCategoryList;
    }
    else
      return null;

  }

}