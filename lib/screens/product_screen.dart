import 'package:ecommerceapp/models/main_category_model.dart';
import 'package:ecommerceapp/models/product_model.dart';
import 'package:ecommerceapp/models/sub_categories_model.dart';
import 'package:ecommerceapp/services/product_service.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {

  MainCategories categories;
  SubCategoriesModel subCategories;

  ProductScreen(this.subCategories , this.categories);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {


  List<ProductModel> productList = [];
  List<int> quantityItemList = [];
  List<ProductModel> _searchResult = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() => {
    (() async {

      productList = await ProductService.getProductList(widget.categories.name, widget.subCategories.name);

      productList.forEach((element) {
        quantityItemList.add(1);
      });

      isLoading = false;
      setState(() {
      });

    })()

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('  Products' , style: TextStyle(color: Colors.black),),
          actions : <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundColor: Colors.white,
//              child: Image.network("")),
                child: Image.asset("images/profile_default.png" , fit: BoxFit.fill,),
              ),)
          ]
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: (!isLoading) ? Column(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 20 , right: 20 , top: 2),
                child: searchField()),
            (productList != null) ? (productList.length>0) ? Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                child:  _searchResult.length != 0 || searchController.text.isNotEmpty
                    ? _buildSearchResults()
                    : _buildResults(),
              ),
            ) : Container(
                height: 100,
                child: Center(child: Text('No Products Found !'))) : Container(
                height : 100,
                child: Center(child: Text('No Products Found !'),))
          ],
        ) : Center(
          child: Loader.getListLoader(context),
        ),
      ),
    );
  }


  Widget _buildResults() {

    return ListView.builder(
        itemCount: productList.length,
        itemBuilder: (BuildContext context , int index)
        {
          return itemCard(productList[index] , index);
        }
    );
  }


  Widget _buildSearchResults() {

    return ListView.builder(
        itemCount: _searchResult.length,
        itemBuilder: (BuildContext context , int index)
        {
          return itemCard(_searchResult[index] , index);
        }
    );
  }

  Widget itemCard(ProductModel productItem , int index)
  {
    return Container(
      margin: const EdgeInsets.only(left: 4 , right: 4 , bottom: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey , width: 0.2),
          boxShadow: [BoxShadow(
              offset: Offset(0.2 , 0.3)
          )]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10 , right: 10 , top: 30),
              height: 100,
              width: 100,
              child : Image.asset("images/gift_box.png"),
//              child: Image.network((!EmptyValidation.isEmpty(productItem.prod_image)) ? productItem.prod_image : "")
          ),
             itemDetails(productItem , index)
        ],
      ),
    );
  }

  itemDetails(ProductModel productItem , int index)
  {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//            Align(
//                alignment: Alignment.topRight,
//                child: Icon(Icons.favorite , color: Colors.grey,)),
//            SizedBox(height: 10,),
            Text(
              productItem.prod_name, style: TextStyle(fontSize: 17 , fontWeight: FontWeight.bold , color: Colors.black),),
            SizedBox(height: 6,),
            Text(productItem.quantity + " in stock"),
            SizedBox(height: 6,),
            Text.rich(TextSpan(
              children: <TextSpan>[
                new TextSpan(
                  text: "\u{20B9} "  + productItem.real_price,
                  style: new TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            ),
            SizedBox(height: 6,),
            Row(children: [
              Text('Our Price \u{20B9} ${productItem.sale_price}' , style: TextStyle(color: Colors.red),),
            ],),
            SizedBox(height: 10,),
            quantityButtons(productItem, index),
            SizedBox(height: 20,),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 10 , right: 10),
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
//                  border: Border.all(color: Colors.w),
                  color: Colors.red
              ),
              child: FittedBox(child: Text('Buy' , style: TextStyle(fontSize : 18 , color: Colors.white),)),
            )
          ],
        ),
      ),
    );

  }

  quantityButtons(cartItem , index)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (){
              if(quantityItemList[index] > 1)
              {
              quantityItemList[index]--;
              setState(() {
              });
              }
          },
          child: Container(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12) , bottomLeft: Radius.circular(12)),
                border: Border.all(),
            ),
            child: Icon(Icons.remove , color: Colors.grey, size: 25,),
          ),
        ),
        Container(
          margin : const EdgeInsets.only(left: 4 , right: 4),
          padding: const EdgeInsets.all(6.0),
          child: Text(quantityItemList[index].toString() , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold , color: Colors.black),),
        ),
        GestureDetector(
          onTap: (){
              if(quantityItemList[index] < 5)
              {
              quantityItemList[index]++;
              setState(() {
              });
              }
          },
          child: Container(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(12) , bottomRight: Radius.circular(12)),
              border: Border.all()
            ),
            child: Icon(Icons.add ,  color: Colors.grey, size: 25,),
          ),
        ),
        SizedBox(width: 30,),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.red)
            ),
            child: FittedBox(child: Text('Add To Cart' , style: TextStyle(fontSize : 13 , color: Colors.red),)),
          ),
        )
      ],
    );
  }


  searchField()
  {

    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child : Material(
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: TextField(
          onChanged: onSearchTextChanged,
          controller: searchController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0 , vertical: 14.0),
              border: InputBorder.none,
              hintText: "Search any product",
              suffixIcon: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                child: GestureDetector(
                  onTap: (){
                    searchController.clear();
                    onSearchTextChanged('');
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.black,),
                ),
              )
          ),
        ),
      ),
    );
  }


  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    productList.forEach((userDetail) {
      if (userDetail.prod_name.toLowerCase().contains(text.toLowerCase()))
      {
      _searchResult.add(userDetail);
      }
    });

    setState(() {});
  }


}



