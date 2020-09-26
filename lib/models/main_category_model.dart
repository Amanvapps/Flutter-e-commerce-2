class MainCategories
{
  String name;
  String icon;

  MainCategories(obj)
  {
    this.name = obj["cat_name"];
    this.icon = obj["cat_icon"];
  }


  static fromJSONList(list)
  {
    List<MainCategories> newList = [];

    list.forEach((element) {
      newList.add(new MainCategories(element));
    });
    return newList;
  }

}