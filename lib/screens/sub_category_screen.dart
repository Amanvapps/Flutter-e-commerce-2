import 'package:ecommerceapp/models/main_category_model.dart';
import 'package:ecommerceapp/models/sub_categories_model.dart';
import 'package:ecommerceapp/screens/product_screen.dart';
import 'package:ecommerceapp/services/category_service.dart';
import 'package:ecommerceapp/utils/empty_validation.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatefulWidget {

  var mainCtx , username;
  MainCategories categories;

  SubCategoryScreen(this.categories , this.mainCtx , this.username);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

  List<SubCategoriesModel> categoryList = [];
  bool isLoading = true;

  @override
  void initState() => {
    (() async {
      await getSubCategories(widget.categories.name);
    })()

  };


  getSubCategories(categoryName) async
  {
    categoryList = await CategoryService.getSubCategoryList(categoryName);
    isLoading = false;
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('  Sub Categories' , style: TextStyle(color: Colors.black),),
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
      body: SafeArea(
        child: (!isLoading) ? (categoryList != null) ? Container(
            margin: EdgeInsets.only(left: 5 , right: 5),
            child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (1 / 1.5),
              controller:  ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: categoryList.map((SubCategoriesModel category) {
                return categoryCard(category);
              }).toList(),
            )
        )  : Center(
            child: Text('No categories found !' , style: TextStyle(fontSize: 20),)):
        Center(
          child: Container(
            child: Loader.getListLoader(context),
          ),
        ),
      ),
    );
  }


  Widget categoryCard(SubCategoriesModel category)
  {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen(category , widget.categories , widget.mainCtx , widget.username)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10,),
            new Container(
              height: 100,
              margin: EdgeInsets.only(top : 10),
              child: new Center(
                  child: Image.network((category.icon).toString())
              ),
            ),
            SizedBox(height: 20,),
            Text((!EmptyValidation.isEmpty(category.name)) ? category.name : "" , style: TextStyle(fontSize: 20 , fontFamily: "Lato" , fontStyle: FontStyle.values[0] , fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text('SHOP NOW'),
            Container(
              alignment: Alignment.center,
              width: 100,
              child: Divider(
                color: Colors.black,
                thickness: 3,
              ),
            )
          ],
        ),
      ),
    );
  }


}
