import 'package:ecommerceapp/models/user_model.dart';
import 'package:ecommerceapp/services/user_service.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {

  var mainCtx;
  ProfileScreen(this.mainCtx);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  User userProfile;
  bool isLoading = true;

  @override
  void initState() => {
    (() async {
      await getProfile();
    })()

  };

  getProfile() async
  {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');

    userProfile = await UserService.getProfile(userId);
    isLoading = false;
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('  Profile' , style: TextStyle(color: Colors.black),),
          actions : <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundColor: Colors.white,
//              child: Image.network("")),
                child: Image.asset("images/profile_default.png" , fit: BoxFit.fill,),
              ),
            )
          ]
      ),
      body: SafeArea(
        child: (!isLoading) ? Container(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 50.0 , horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Profile' , style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 20.0,),
                  _profileRow(),
                  SizedBox(height: 30.0),
                  Text('Account' , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold),),
                  SizedBox(height: 20.0,),
                  _profileAccountCard(),
                  SizedBox(height: 30.0),
//                  Text('Notifications' , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold),),
//                  SizedBox(height: 20.0,),
//                  _notificationCard(),
//                  SizedBox(height: 20.0,),
                  Text('Other' , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold),),
                  SizedBox(height: 20.0,),
                  _otherCard(),
                ],
              ),
            ),
          ),
        ) : Center(
          child: Loader.getLoader(),
        ),
      ),
    );
  }


  Widget _profileRow()
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 120.0,
          width: 120.0,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60.0),
              boxShadow:[
                BoxShadow(
                    blurRadius: 3.0,
                    offset: Offset(0,4.0),
                    color: Colors.black38
                ),
              ],
          ),
          child : Image.network('${userProfile.profile_image}',  fit: BoxFit.cover),
        ),
        SizedBox(width: 20.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${userProfile.user_name}' , style: TextStyle(fontSize: 16.0 , ),),
            SizedBox(height: 10.0,),
            Text('${userProfile.mobile}' , style: TextStyle(color: Colors.grey),),
            SizedBox(height: 20.0,),
//            smallButton()
          ],
        ),
      ],
    );
  }


  Widget _profileAccountCard()
  {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical : 5.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.email, color: Colors.blue,),
                  SizedBox(width: 15.0,),
                  Text('${userProfile.email_id}' , style: TextStyle(fontSize: 16.0),),
                ],
              ),
            ),
            Divider(height: 10.0,color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical : 5.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.blue,),
                  SizedBox(width: 15.0,),
                  Text('${userProfile.address}' , style: TextStyle(fontSize: 16.0),),
                ],
              ),
            ),
            Divider(height: 10.0,color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical : 5.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_city, color: Colors.blue,),
                  SizedBox(width: 15.0,),
                  Text('${userProfile.city}' , style: TextStyle(fontSize: 16.0),),
                ],
              ),
            ),
            Divider(height: 10.0,color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical : 5.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.payment, color: Colors.blue,),
                  SizedBox(width: 15.0,),
                  Text('${userProfile.pincode}' , style: TextStyle(fontSize: 16.0),),
                ],
              ),
            ),
            Divider(height: 10.0,color: Colors.grey,),
          ],
        ),
      ),
    );
  }

  Widget _otherCard()
  {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical : 5.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.phone, color: Colors.blue,),
                    SizedBox(width: 15.0,),
                    Text('${userProfile.mobile}' , style: TextStyle(fontSize: 16.0),),
                  ],
                ),
              ),
              Divider(height: 10.0,color: Colors.grey,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical : 5.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.payment, color: Colors.blue,),
                    SizedBox(width: 15.0,),
                    Text('${userProfile.pincode}' , style: TextStyle(fontSize: 16.0),),
                  ],
                ),
              ),
              Divider(height: 10.0,color: Colors.grey,),
            ],
          ),
        ),
      ),
    );
  }

  Widget smallButton()
  {
    return Container(
      height: 25.0,
      width: 60.0,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blue
          ),
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Center(
        child: Text('Edit' , style: TextStyle(
            color: Colors.blue , fontSize: 16.0
        ),
        ),
      ),
    );
  }




}
