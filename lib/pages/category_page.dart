import 'package:ecommerceapp/models/main_category_model.dart';
import 'package:ecommerceapp/screens/sub_category_screen.dart';
import 'package:ecommerceapp/services/category_service.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:ecommerceapp/widgets/navigation_drawer_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CategoryPage extends StatefulWidget {

  var mainCtx;
  var username;

  CategoryPage(this.mainCtx , this.username);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<CategoryPage> {

  List<MainCategories> mainCategoryList = [];
  bool isLoading = true;

  @override
  void initState() => {
    (() async {
      await getMainCategories();
    })()

  };

  getMainCategories() async
  {
    mainCategoryList = await CategoryService.getCategoryList();
    isLoading = false;
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: Drawer(
        child: DrawerElements.getDrawer("category_page", context, widget.mainCtx , widget.username),
      ),
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('  Categories' , style: TextStyle(color: Colors.black),),
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
        child: ListView(
          children: [
            Container(
              width: size.width,
              height: MediaQuery.of(context).size.height/4,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Image.asset('images/banner_image.jpg' , fit: BoxFit.fill,),
            ),
            (!isLoading) ? Container(
                margin: EdgeInsets.only(left: 5 , right: 5),
                child: new GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (1 / 1.5),
                  controller:  ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: mainCategoryList.map((MainCategories category) {
                    return categoryCard(category);
                  }).toList(),
                )
            ) : Center(
              child: Container(
                child: Loader.getListLoader(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categoryCard(MainCategories category)
  {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubCategoryScreen(category , widget.mainCtx)),
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
            FittedBox(child: Text(category.name , style: TextStyle(fontSize: 20 , fontFamily: "Lato" , fontStyle: FontStyle.values[0] , fontWeight: FontWeight.bold),)),
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
