class CartModel
{
  String user_sr;
  String prod_id;
  String quantity;
  String prod_price;
  String prod_name;
  String prod_code;
  String manufacturer;
  String prod_desc;
  String image;
  String ship_charge;
  String ship_type;


  CartModel(obj)
  {
    this.user_sr = obj["user_sr"];
    this.prod_id = obj["prod_id"];
    this.quantity = obj["qty"];
    this.prod_name = obj["prod_name"];
    this.prod_price = obj["prod_price"];
    this.prod_code = obj["prod_code"];
    this.manufacturer = obj["manufacturer"];
    this.prod_desc = obj["prod_desc"];
    this.image = obj["image"];
    this.ship_charge = obj["ship_chrg"];
    this.ship_type = obj["ship_type"];
  }


  static fromJSONList(list)
  {
    List<CartModel> newList = [];

    list.forEach((element) {
      newList.add(new CartModel(element));
    });
    return newList;
  }


}