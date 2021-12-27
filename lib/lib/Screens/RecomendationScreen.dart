
import 'package:agre/lib/Models/ShowDailog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';import 'CartScreen.dart';
import 'DrawerScreen.dart';
class RecomendationScreen extends StatefulWidget {
  @override
  _RecomendationScreenState createState() => _RecomendationScreenState();
}

class _RecomendationScreenState extends State<RecomendationScreen> {
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();

  var recoController = TextEditingController();
  List catLength=[];
  Future<void> getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      catLength=preferences.getStringList("cart");
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("المقترحات و الشكاوي",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading:  Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(icon: Icon(Icons.shopping_cart,color: Colors.white,), onPressed: (){
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen('')));
            }),
            Container(
              margin: EdgeInsets.only(left: 5,top: 5),
              height: 17,width: 17,decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(20),color: Colors.white,),
              child: Center(
                child: Transform.translate(
                  offset: Offset(0, -2),
                  child: Text("${catLength==null?"0":catLength.length}",style: TextStyle(color: Colors.red,fontSize: 10),textAlign: TextAlign.center,),
                ),),alignment: Alignment.center, )
          ],
        ),

        actions: [
          InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_forward,size: 28,color: Colors.white,)),
        ],
      ),

      //endDrawer: DrawerScreen(),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Color(0xfff2f2f2),
              ),
              child: TextFormField(
                controller: recoController,
                textAlign: TextAlign.right,
                maxLines: 15,
                decoration: InputDecoration(
                  hintText: "اكتب هنا",
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
              onTap: (){
                PostRecomendation();
              },
              child: Container(
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.red,
                ),
                child: Text("ارسال",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> PostRecomendation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwt = preferences.getString("jwt");
    showDialogShared(context);
    var mapResponse;
    http.Response response = await http.post(Uri.parse(
        "https://7agat.app/api/products/Reco"), body: {
      "body": recoController.text.toString(),

    },headers: {"Authorization": "Bearer $jwt"}).then((value) {
      setState(() {
        mapResponse=value;
      });
      Navigator.pop(context);
    });
   // Map mapResponse = json.decode(response.body);
    print(mapResponse);
    Fluttertoast.showToast(
        msg: 'تم الارسال',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }
}
