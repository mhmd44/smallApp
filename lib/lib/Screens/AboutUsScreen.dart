import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();


  Future<void> aboutUs()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://elwadyelakhdar-egy.com/api/about"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("من نحن ؟",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),

     // endDrawer: DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: aboutUs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.data['about_us'],
                  style: TextStyle(color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }
}
