import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/pages/category_page.dart';
import 'package:ecommerceapp/pages/offer_page.dart';
import 'package:ecommerceapp/pages/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  CategoryPage categoryPage;
  SearchPage searchPage;
  OfferPage offerPage;
  CartPage cartPage;

  int currentTabIndex = 0;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() => {
    (() async {
      categoryPage = CategoryPage();
      searchPage = SearchPage();
      offerPage = OfferPage();
      cartPage = CartPage();

      pages = [categoryPage , searchPage , offerPage , cartPage];
      currentPage = categoryPage;

    })()

  };


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index)
        {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        selectedItemColor: Colors.blueAccent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title:Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            title:Text('Offers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title:Text('Cart'),
          ),
        ],
      ),
      body: currentPage,
    );
  }


}
