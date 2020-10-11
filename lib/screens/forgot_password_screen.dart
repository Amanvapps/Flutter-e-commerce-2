import 'package:ecommerceapp/screens/login_screen.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController phoneController , passwordController , reEnterPasswordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    phoneController = TextEditingController();
    passwordController = TextEditingController();
    reEnterPasswordController = TextEditingController();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Stack(
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    hintText: 'Email'
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
                              SizedBox(height: 10,),
                              TextField(
                                controller: reEnterPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Confirm Password'
                                ),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: () async {

                                  if(phoneController.text == "" || passwordController.text == "" || reEnterPasswordController.text == "")
                                    {
                                      Fluttertoast.showToast(msg: "Empty Fields!" , backgroundColor: Colors.black , textColor: Colors.white);
                                    }
                                  else
                                    {
                                      if(passwordController.text == reEnterPasswordController.text)
                                        {

                                          isLoading = true;
                                          setState(() {
                                          });

                                          bool result = await AuthService.resetPassword(phoneController.text , passwordController.text);
                                          if(result == true)
                                          {
                                            Fluttertoast.showToast(msg: "Reset email has been sent to your email id" , backgroundColor: Colors.black , textColor: Colors.white);
                                          }
                                          else
                                            {
                                              Fluttertoast.showToast(msg: "Error reset password!" , backgroundColor: Colors.black , textColor: Colors.white);
                                            }

                                          isLoading = false;
                                          setState(() {
                                          });

                                        }
                                      else
                                        Fluttertoast.showToast(msg: "Password different!" , backgroundColor: Colors.black , textColor: Colors.white);

                                    }

                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width/2,
                                  color: Colors.black54,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  height: 40,
                                  child: Text('Reset Password' , style: TextStyle(color: Colors.white),),
                                ),
                              ),
                              SizedBox(height: 20,),
                              GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: Text(' Sign In' , style: TextStyle(color: Colors.blue ,fontSize: 18),))
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
            (isLoading) ? Center(
              child : Container(
                child: Loader.getLoader(),
              )
            ) : Container()
          ],
        ),
      ),
    );
  }
}
