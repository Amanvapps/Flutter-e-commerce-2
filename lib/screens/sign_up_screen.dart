import 'package:ecommerceapp/screens/login_screen.dart';
import 'package:ecommerceapp/services/auth_service.dart';
import 'package:ecommerceapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {


  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController emailController , passwordController , nameController , phoneController , cityController , stateController , addressController , pincodeController , landmarkController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    addressController = TextEditingController();
    pincodeController = TextEditingController();
    landmarkController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Center(
                        child:  Container(
                          height: MediaQuery.of(context).size.height/2,
                          color: Colors.grey[200],
                          margin: EdgeInsets.all(40),
                        ),
                      ),
                      Center(
                        child: Container(
                            padding: EdgeInsets.all(40),
                            height: MediaQuery.of(context).size.height/1.5,
                            color: Colors.white,
                            margin: EdgeInsets.only(top: 60 , bottom: 20 ,left: 30 , right: 30),
                            child: Container(
                              margin: EdgeInsets.only(top: 40),
                              alignment: Alignment.center,
                              child: ListView(
                                children: [
                                  TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        hintText: 'Email'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    obscureText: true,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        hintText: 'Password'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.people),
                                        hintText: 'Name'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.phone),
                                        hintText: 'Phone'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: cityController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.location_city),
                                        hintText: 'City'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: stateController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.add_location),
                                        hintText: 'State'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: addressController,
                                    keyboardType: TextInputType.streetAddress,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.location_on),
                                        hintText: 'Address'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: pincodeController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person_pin),
                                        hintText: 'Pin code'
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: landmarkController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.near_me),
                                        hintText: 'Landmark'
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  GestureDetector(
                                    onTap: () async {
                                      String email = emailController.text;
                                      String pass = passwordController.text;
                                      String name = nameController.text;
                                      String phone = phoneController.text;
                                      String city = cityController.text;
                                      String state = stateController.text;
                                      String address = addressController.text;
                                      String pincode = pincodeController.text;
                                      String landmark = landmarkController.text;


                                      if(email!="" && pass!="" && name!="" && phone!="" && city!="" && state!="" && address!="" && pincode!="" && landmark!="") {


                                        isLoading = true;
                                        setState(() {

                                        });

                                        var res =  await AuthService.register(
                                            email,
                                            name,
                                            city,
                                            phone,
                                            pass,
                                            state,
                                            address,
                                            pincode,
                                            landmark);

                                       if(res!=null)
                                         {
                                           Fluttertoast.showToast(msg: "Successfully signed up !" , textColor: Colors.white , backgroundColor: Colors.black);
                                           Navigator.pushReplacement(
                                             context,
                                             MaterialPageRoute(builder: (context) => LoginScreen()),
                                           );
                                         }


                                       isLoading = false;
                                       setState(() {

                                       });

                                      }
                                      else
                                        {
                                          Fluttertoast.showToast(msg: 'Empty Fields!' , textColor: Colors.white , backgroundColor: Colors.black);
                                        }

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width/2,
                                      color: Colors.black54,
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      height: 40,
                                      child: Text('SIGN UP' , style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
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
                      Text('Already have an account?'  , style: TextStyle(fontSize: 18)),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text('  Log In' , style: TextStyle(color: Colors.blue ,fontSize: 18),))
                    ],
                  )
                ],

              ),
              (isLoading) ? Loader.getLoader() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
