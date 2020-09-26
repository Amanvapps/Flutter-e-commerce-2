class SubCategoriesModel
{

  String name;
  String icon;

  SubCategoriesModel(obj)
  {
  this.name = obj["subcat_name"];
  this.icon = obj["subcat_icon"];
  }


  static fromJSONList(list)
  {
  List<SubCategoriesModel> newList = [];

  list.forEach((element) {
  newList.add(new SubCategoriesModel(element));
  });
  return newList;
  }

}