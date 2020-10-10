import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/widgets/routes.dart';
import 'package:flutter/material.dart';

class DrawerElements {


  static getDrawer(pageName , BuildContext context,  mainCtx , name)  {

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child : Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Image.asset('images/profile_default.png'),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    )
                  ),
                ),
                SizedBox(height: 10,),
                FittedBox(child: Text('  ${name}' , style: TextStyle(fontSize: 20),))
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.blueAccent,
          ),
        ),
        ...Routes.getUserRoutes(context, pageName , mainCtx),                 //assigned collection of navigation elements
        ListTile(
          title: Text("Logout"),
          leading: Icon(Icons.refresh),
          onTap: (){
            AuthService.logout(mainCtx);
          },
        ),
      ],
    );
  }


}