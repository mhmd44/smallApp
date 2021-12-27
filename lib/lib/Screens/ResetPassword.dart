
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'HomeScreen.dart';


class ResetPassword extends StatefulWidget {
  String email;

  ResetPassword(this.email);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool passwordVisability = false;
  bool passwordVisability2 = false;

  var passController = TextEditingController();

  var passConfirmationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60,),
              Text("نسيت كلمة المرور", textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("أهلا بك مجددا لنقم بتأكيد كلمة المرور",
                style: TextStyle(fontSize: 17),),
              SizedBox(height: 50,),

              Container(
                height: 70,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Colors.red[100],
                ),
                child: Icon(Icons.person, size: 35, color: Colors.red,),
              ),
              SizedBox(height: 25,),


              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: passController,
                  textAlign: TextAlign.right,
                  obscureText: passwordVisability == false ?true:false,
                  decoration: InputDecoration(
                    hintText: "كلمة المرور",
                    suffixIcon: Icon(Icons.lock,color: Colors.red,size: 30,),
                    prefixIcon: passwordVisability == false ?
                    IconButton(
                      icon: Icon(Icons.visibility_off,color: Colors.red,size: 30,),
                      onPressed: (){
                        passwordVisabilityState();
                      },
                    ):
                    IconButton(
                      icon: Icon(Icons.visibility,color: Colors.red,size: 30,),
                      onPressed: (){
                        passwordVisabilityState();
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: passConfirmationController,
                  textAlign: TextAlign.right,
                  obscureText: passwordVisability2==false?true:false,
                  decoration: InputDecoration(
                    hintText: "تأكيد كلمة المرور",
                    suffixIcon: Icon(Icons.lock,color: Colors.red,size: 30,),
                    prefixIcon: passwordVisability2 == false ?
                    IconButton(
                      icon: Icon(Icons.visibility_off,color: Colors.red,size: 30,),
                      onPressed: (){
                        passwordVisabilityState2();
                      },
                    ):
                    IconButton(
                      icon: Icon(Icons.visibility,color: Colors.red,size: 30,),
                      onPressed: (){
                        passwordVisabilityState2();
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.red, width: 1)
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15,),

              InkWell(
                onTap: () {
                  UpdatePassword(widget.email,passController.text,passConfirmationController.text);
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: Text("تأكيد", textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                ),
              ),

              SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
  void passwordVisabilityState (){
    setState(() {
      passwordVisability = !passwordVisability;
    });
  }

  void passwordVisabilityState2 (){
    setState(() {
      passwordVisability2 = !passwordVisability2;
    });
  }

  Future<void> UpdatePassword(String email,pass,conPass) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/reset"), body: {
      "email": email,
      "password":pass,
      "password_confirmation": conPass

    },headers: {"Authorization": "Bearer $jwt"});
    setState(() {

    });
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    if(mapResponse['success']){
      preferences.setBool("logInState", true);
      preferences.setString("currentLogedEmail", email);
      preferences.setString("jwt",mapResponse['data']['token']);
      preferences.setInt("balance", mapResponse['data']['balance']);
      Fluttertoast.showToast(
          msg: "تم تسجيل الدخول بنجاح",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => HomeScreen()), (
          Route<dynamic> route) => false);
    }else{
      Fluttertoast.showToast(
          msg: 'فشل تسجيل الدخول',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }

  }
}
