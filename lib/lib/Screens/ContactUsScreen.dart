import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'DrawerScreen.dart';
class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();


  Future<void> contactUs()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    http.Response response = await http.get(Uri.parse("https://elwadyelakhdar-egy.com/api/contact"),headers: {"Authorization": "Bearer $jwt"});
    Map mapResponse = json.decode(response.body);
    return mapResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("اتصل بنا",style: TextStyle(color: Colors.white),),
        centerTitle: true,

        actions: [
          InkWell(
              onTap: (){
                Navigator.of(context).pop();

              },
              child: Icon(Icons.arrow_forward,size: 28,color: Colors.white,)),
        ],

      ),

   //   endDrawer: DrawerScreen(),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: contactUs(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Column(
                children: [
                  InkWell(
                    onTap: () async{
                      await launch("tel:${snapshot.data['data']['phone']}",
                          headers: <String, String>{
                            'header_key': 'header_value'
                          });
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      child: Text("اتصال سريع بخدمة العملاء",
                        style: TextStyle(color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),),
                    ),
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: ()async{
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: snapshot
                            .data['data']['email'],
                        query: 'subject=Agricultural Feedback&body='
                      );
                      String  url = params.toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        print( 'Could not launch $url');
                      }
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      child: Text("ارسال بريد الكتروني", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),),
                    ),
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: () async {
                      await launch(
                          "https://wa.me/+2${snapshot
                              .data['data']['phone']}?text=مرحبا");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.redAccent,
                      ),
                      child: Text(
                        "محادثة واتس اب", style: TextStyle(color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),),
                    ),
                  ),
                   Center(
                     child: Container(
                       height: 80,
                       child: Center(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             IconButton(onPressed: (){
                               setState(() {
                                 launch(snapshot.data['data']['social_facebook'].toString());
                               });
                             }, icon: Icon(
                               FontAwesomeIcons.facebook,color: Colors.red,size: 25,)),
                             InkWell(onTap: (){
                               setState(() {
                                 launch(snapshot.data['data']['social_instagram'].toString());
                               });
                             },
                               child: Icon(FontAwesomeIcons.instagram,color: Colors.red,size: 25,),
                             ),
                             IconButton(onPressed: (){
                               setState(() {
                                 launch(snapshot.data['data']['social_twitter'].toString());
                               });
                             }, icon: Icon(
                               FontAwesomeIcons.twitter,size: 25,color: Colors.red,)),
                           ],
                         ),
                       ),
                     ),
                   )
                ],
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
