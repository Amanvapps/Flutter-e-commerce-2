import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/pages/category_page.dart';
import 'package:ecommerceapp/pages/transaction_history_page.dart';
import 'package:ecommerceapp/pages/wishlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainScreen extends StatefulWidget {

  var username;

  MainScreen(this.username);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  CategoryPage categoryPage;
  WishlistPage wishlistPage;
  TransactionHistoryPage transactionHistoryPage;
  CartPage cartPage;

  int currentTabIndex = 0;
  List<Widget> pages;
  Widget currentPage;

  DateTime currentBackPressTime;

  @override
  void initState() => {
    (() async {
      categoryPage = CategoryPage(context , widget.username);
      wishlistPage = WishlistPage(context , widget.username);
      transactionHistoryPage = TransactionHistoryPage(context , widget.username);
      cartPage = CartPage(context , widget.username);

      pages = [categoryPage , wishlistPage , cartPage  , transactionHistoryPage];
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
              label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transaction',
          ),
        ],
      ),
      body: WillPopScope(child: currentPage, onWillPop: onWillPop),

    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 6)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit the app");
      return Future.value(false);
    }
    return Future.value(true);
  }

}
