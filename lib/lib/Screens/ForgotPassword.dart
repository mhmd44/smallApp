import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ResetPassword.dart';
class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var emailController = TextEditingController();
  bool verifyState = false;

  var code1Controller = TextEditingController();
  var code2Controller = TextEditingController();
  var code3Controller = TextEditingController();
  var code4Controller = TextEditingController();
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
              Text("أهلا بك مجددا لنقم باستعادة بريدك",
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

              !verifyState?Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xfff2f2f2),
                ),
                child: TextFormField(
                  controller: emailController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "البريد الإلكتروني",
                    suffixIcon: Icon(
                      Icons.email, color: Colors.red, size: 30,),
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
              ):Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: code1Controller,
                        onChanged: (value){
                          if(value.length==1){
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        autofocus: true,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,width: 1)
                          ),

                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: code2Controller,
                        onChanged: (value){
                          if(value.length==1){
                            FocusScope.of(context).nextFocus();
                          }
                        },

                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,width: 1)
                          ),

                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: code3Controller,
                        onChanged: (value){
                          if(value.length==1){
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,width: 1)
                          ),

                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: code4Controller,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1)
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,width: 1)
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),

              !verifyState?InkWell(
                onTap: () {
                    GetVerificationCode(emailController.text);
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
                  child: Text("ارسال الكود", textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                ),
              ):InkWell(
                onTap: () {
                  CheckCode(code1Controller.text,code2Controller.text,code3Controller.text,code4Controller.text,emailController.text);
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

  Future<void> GetVerificationCode(String email) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/getCode"), body: {
      "email": email,

    },headers: {"Authorization": "Bearer $jwt"});
    setState(() {

    });
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    if(mapResponse['status']){
      setState(() {
        verifyState = true;
      });
    }else{
      Fluttertoast.showToast(
          msg: "تمت العملية",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }

  }

  Future<void> CheckCode(String code1,code2,code3,code4, String email) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/checkcode"), body: {
      "email": email,
      "code": code1+code2+code3+code4

    },headers: {"Authorization": "Bearer $jwt"});
    setState(() {

    });
    Map mapResponse = json.decode(response.body);
    print(mapResponse);
    if(mapResponse['code']){
      Navigator.pushReplacement(context, (MaterialPageRoute(builder: (context)=>ResetPassword(email))));
    }else {
      Fluttertoast.showToast(
          msg: mapResponse['الكود خطأ حاول مرة أخري'],
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }
  }
}
