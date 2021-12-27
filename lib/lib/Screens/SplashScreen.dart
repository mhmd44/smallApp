import 'dart:convert';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ConfirmScreen.dart';

import 'HomeScreen.dart';
import 'LogInScreen.dart';
import 'SignUpScreen.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {






  Future<void> aboutUs()async{


    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://elwadyelakhdar-egy.com/api/about"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }

  Map map;
  Future getProfileUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.post(Uri.parse("https://7agat.app/api/current/user"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool loginState = preferences.getBool("logInState");
      if(loginState!=null) {
        loginState ? getProfileUserData().then((data) {
          if(data['data']['confirm'] != 0){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomeScreen()
            ));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomeScreen()
            ));
          }
        }) : Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) =>
                LogInScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) => LogInScreen(pagename: "",)));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
        body: Center(
          child: Container(
            width:MediaQuery.of(context).size.width-60,
            child: Image(image: AssetImage("assets/images/logo.png"),),
          ),
        )
    );
  }
}
