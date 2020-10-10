class PaymentModel
{
  String prod_name;
  String prod_code;
  String prod_price;
  String prod_qty;
  String order_type;
  String order_status;
  String date;
  String payment_id;
  String order_id;
  String payment_status;


  PaymentModel(obj)
  {
    this.prod_name = obj["prod_name"];
    this.prod_code = obj["prod_code"];
    this.prod_price = obj["prod_price"];
    this.prod_qty = obj["prod_qty"];
    this.order_type = obj["order_type"];
    this.order_status = obj["order_status"];
    this.date = obj["datee"];
    this.payment_id = obj["payment_id"];
    this.order_id = obj["order_id"];
    this.payment_status = obj["payment_status"];
  }


  static fromJSONList(list)
  {
    List<PaymentModel> newList = [];

    list.forEach((element) {
      newList.add(new PaymentModel(element));
    });
    return newList;
  }

}