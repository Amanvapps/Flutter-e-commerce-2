class User
{
  String user_id;
  String user_name;
  String mobile;
  String email_id;
  String address;
  String city;
  String state;
  String reg_date;
  String profile_image;
  String pincode;
  String landmark;
  int cart_items;
  int wishlist_items;
  String webhook;
  String pageDirected;
  String apiKey;
  String apiToken;


  User(obj)
  {
    this.webhook = obj["webhook"];
    this.pageDirected = obj["page_redirect"];
    this.apiKey = obj["api_key"];
    this.apiToken = obj["api_token"];

    this.user_id = obj["user_sr"];
    this.user_name = obj["user_name"];
    this.mobile = obj["mobile"];
    this.email_id = obj["email_id"];
    this.address = obj["address"];
    this.city = obj["city"];
    this.state = obj["state"];
    this.reg_date = obj["reg_date"];
    this.profile_image = obj["profile_image"];
    this.pincode = obj["pincode"];
    this.landmark = obj["landmark"];
    this.cart_items = obj["cart_items"];
    this.wishlist_items = obj["wishlist_items"];
  }








}