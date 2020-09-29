class ProductModel
{
  String prod_id;
  String prod_name;
  String prod_code;
  String prod_desc;
  String prod_image;
  String date;
  String ship_charge;
  String cod_mode;
  String quantity;
  String sale_price;
  String real_price;
  String manufacturer;


  ProductModel(obj)
  {

    this.prod_id = obj["prod_sr"];
    this.prod_name = obj["prod_name"];
    this.prod_desc = obj["prod_desc"];
    this.prod_code = obj["prod_code"];
    this.prod_image = obj["prod_image"];
    this.date = obj["date"];
    this.ship_charge = obj["ship_chrg"];
    this.cod_mode = obj["cod_mode"];
    this.quantity = obj["qty"];
    this.sale_price = obj["sale_price"];
    this.real_price = obj["real_price"];
    this.manufacturer = obj["manufacturer"];
  }

  static fromJSONList(list)
  {
    List<ProductModel> newList = [];

    list.forEach((element) {
      newList.add(new ProductModel(element));
    });
    return newList;
  }



}