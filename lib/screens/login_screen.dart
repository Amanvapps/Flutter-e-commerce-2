import 'package:ecommerceapp/screens/forgot_password_screen.dart';
import 'package:ecommerceapp/screens/main_screen.dart';
import 'package:ecommerceapp/screens/sign_up_screen.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController , passwordController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    phoneController = TextEditingController();
    passwordController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                     Center(
                       child:  Container(
                         height: MediaQuery.of(context).size.height/1.9,
                         color: Colors.grey[200],
                         margin: EdgeInsets.all(40),
                       ),
                     ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(40),
                          height: MediaQuery.of(context).size.height/2.1,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 60 , bottom: 20 ,left: 30 , right: 30),
                          child: Container(
                            margin: EdgeInsets.only(top: 40),
                            alignment: Alignment.center,
                            child: ListView(
                              children: [
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone),
                                      hintText: 'Phone'
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      hintText: 'Password'
                                  ),
                                ),
                                SizedBox(height: 30,),
                                GestureDetector(
                                  onTap: () async {
                                    String phone = phoneController.text;
                                    String password = passwordController.text;
                                    if(phone!="" && password!="")
                                    {
                                      isLoading = true;
                                      setState(() {

                                      });
                                      bool res = await AuthService.login(phone, password);
                                      if(res == true)
                                        {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          String userName = prefs.getString('userName');

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => MainScreen(userName)),
                                          );
                                        }
                                      else
                                        {
                                          isLoading = false;
                                          setState(() {
                                          });
                                        }
                                    }
                                    else
                                      {
                                        Fluttertoast.showToast(msg: "Empty Fields !" , textColor: Colors.white , backgroundColor: Colors.black);

                                        isLoading = false;
                                        setState(() {
                                        });
                                      }



                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width/2,
                                    color: Colors.black54,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    height: 40,
                                    child: Text('LOG IN' , style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                                      );
                                    },
                                    child: Text(' Forgot Password' , style: TextStyle(color: Colors.blue ,fontSize: 18),))
                              ],
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Don\'t have an account?'  , style: TextStyle(fontSize: 18)),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignupScreen()),
                            );
                          },
                          child: Text('  Sign up' , style: TextStyle(color: Colors.blue ,fontSize: 18),))
                    ],
                  )
                ],

              ),
            ),
            (isLoading) ? Loader.getLoader() : Container()
          ],
        ),
      ),
    );
  }
}
