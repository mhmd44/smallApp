import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignUpScreen.dart';
class ConfirmScreen extends StatefulWidget {
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}
class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Center(child: Text("شكرا لك،",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 25),))
              ),
              SizedBox(height: 20),
              Container(
                child: Center(child: Text("سيتم مراجعة الحساب والموافقة عليه في اقرب وقت ممكن"))
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.clear();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen(pagename: '',)));
                },
                child: Container(
                  height: 50,
                  width: 100,
                  color: Colors.red,
                  child: Center(child: Text("تسجيل خروج",style: TextStyle(color: Colors.white),))
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
